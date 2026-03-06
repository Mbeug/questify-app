package com.questify.backend.auth;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.questify.backend.user.AppUser;
import com.questify.backend.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Collections;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    @Value("${google.client-id:}")
    private String googleClientId;

    public AuthResponse signup(SignupRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Cet email est deja utilise");
        }

        AppUser user = AppUser.builder()
                .email(request.getEmail())
                .passwordHash(passwordEncoder.encode(request.getPassword()))
                .displayName(request.getDisplayName())
                .authProvider("local")
                .build();

        user = userRepository.save(user);
        return buildAuthResponse(user);
    }

    public AuthResponse login(LoginRequest request) {
        AppUser user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Email ou mot de passe incorrect"));

        // Social-only accounts have no password
        if (user.getPasswordHash() == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED,
                    "Ce compte utilise la connexion " + user.getAuthProvider() + ". Utilisez le bouton correspondant.");
        }

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Email ou mot de passe incorrect");
        }

        return buildAuthResponse(user);
    }

    public AuthResponse refresh(RefreshRequest request) {
        String token = request.getRefreshToken();

        if (!jwtService.isTokenValid(token)) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Refresh token invalide");
        }

        if (!"refresh".equals(jwtService.extractTokenType(token))) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Token invalide");
        }

        Long userId = jwtService.extractUserId(token);
        AppUser user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Utilisateur introuvable"));

        return buildAuthResponse(user);
    }

    // ── Social login (Google & Apple) ──────────────────────

    public AuthResponse socialLogin(SocialLoginRequest request) {
        String provider = request.getProvider().toLowerCase();

        return switch (provider) {
            case "google" -> handleGoogleLogin(request.getIdToken(), request.getAccessToken(), request.getDisplayName());
            case "apple" -> handleAppleLogin(request.getIdToken(), request.getDisplayName());
            default -> throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Provider inconnu: " + provider);
        };
    }

    private AuthResponse handleGoogleLogin(String idToken, String accessToken, String displayNameHint) {
        String email;
        String name;

        if (idToken != null && !idToken.isBlank()) {
            // Mobile flow: verify the ID token directly
            GoogleIdToken.Payload payload = verifyGoogleToken(idToken);
            email = payload.getEmail();
            name = (String) payload.get("name");
        } else if (accessToken != null && !accessToken.isBlank()) {
            // Web flow: verify using Google's userinfo endpoint
            GoogleUserInfo userInfo = verifyGoogleAccessToken(accessToken);
            email = userInfo.email();
            name = userInfo.name();
        } else {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "idToken ou accessToken requis pour Google");
        }

        if (name == null || name.isBlank()) {
            name = displayNameHint != null ? displayNameHint : email.split("@")[0];
        }

        return findOrCreateSocialUser(email, name, "google");
    }

    private AuthResponse handleAppleLogin(String idToken, String displayNameHint) {
        // Apple ID tokens are standard JWTs signed by Apple.
        // For a robust implementation, you would verify with Apple's public keys.
        // Here we decode the JWT payload to extract email + sub.
        AppleTokenPayload payload = decodeAppleToken(idToken);
        String email = payload.email();
        String name = displayNameHint != null && !displayNameHint.isBlank()
                ? displayNameHint
                : (email != null ? email.split("@")[0] : "Utilisateur Apple");

        return findOrCreateSocialUser(email, name, "apple");
    }

    private AuthResponse findOrCreateSocialUser(String email, String displayName, String provider) {
        Optional<AppUser> existing = userRepository.findByEmail(email);

        if (existing.isPresent()) {
            AppUser user = existing.get();
            // If the user was created via a different provider, update to allow this provider too
            // (or just let them log in — the email is verified by the provider)
            return buildAuthResponse(user);
        }

        // Create new user (no password for social accounts)
        AppUser newUser = AppUser.builder()
                .email(email)
                .displayName(displayName)
                .authProvider(provider)
                .passwordHash(null)
                .build();

        newUser = userRepository.save(newUser);
        return buildAuthResponse(newUser);
    }

    // ── Google token verification ──────────────────────────

    private record GoogleUserInfo(String email, String name, boolean emailVerified) {}

    /**
     * Verify a Google access token by calling Google's userinfo endpoint.
     * Used for the web flow where only an access_token is available.
     */
    private GoogleUserInfo verifyGoogleAccessToken(String accessToken) {
        try {
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://www.googleapis.com/oauth2/v3/userinfo"))
                    .header("Authorization", "Bearer " + accessToken)
                    .GET()
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Access token Google invalide");
            }

            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            var node = mapper.readTree(response.body());

            String email = node.has("email") ? node.get("email").asText() : null;
            String name = node.has("name") ? node.get("name").asText() : null;
            boolean emailVerified = node.has("email_verified") && node.get("email_verified").asBoolean();

            if (email == null || email.isBlank()) {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Email non disponible dans le token Google");
            }
            if (!emailVerified) {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Email Google non verifie");
            }

            return new GoogleUserInfo(email, name, emailVerified);
        } catch (ResponseStatusException e) {
            throw e;
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Erreur de verification du token Google");
        }
    }

    private GoogleIdToken.Payload verifyGoogleToken(String idTokenString) {
        try {
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    new NetHttpTransport(), GsonFactory.getDefaultInstance())
                    .setAudience(Collections.singletonList(googleClientId))
                    .build();

            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken == null) {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Token Google invalide");
            }

            GoogleIdToken.Payload payload = idToken.getPayload();
            if (!Boolean.TRUE.equals(payload.getEmailVerified())) {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Email Google non verifie");
            }

            return payload;
        } catch (ResponseStatusException e) {
            throw e;
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Erreur de verification du token Google");
        }
    }

    // ── Apple token decoding ───────────────────────────────
    // Apple Sign-In sends a JWT signed by Apple. We decode the payload
    // to get the email. For production, you should verify the signature
    // against Apple's public keys (https://appleid.apple.com/auth/keys).

    private record AppleTokenPayload(String sub, String email) {}

    private AppleTokenPayload decodeAppleToken(String idToken) {
        try {
            // JWT = header.payload.signature — decode the payload part
            String[] parts = idToken.split("\\.");
            if (parts.length < 2) {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Token Apple invalide");
            }
            String payloadJson = new String(java.util.Base64.getUrlDecoder().decode(parts[1]));
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            var node = mapper.readTree(payloadJson);
            String sub = node.has("sub") ? node.get("sub").asText() : null;
            String email = node.has("email") ? node.get("email").asText() : null;

            if (sub == null || sub.isBlank()) {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Token Apple invalide: sub manquant");
            }
            if (email == null || email.isBlank()) {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Token Apple invalide: email manquant");
            }

            return new AppleTokenPayload(sub, email);
        } catch (ResponseStatusException e) {
            throw e;
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Erreur de verification du token Apple");
        }
    }

    // ── Response builder ───────────────────────────────────

    private AuthResponse buildAuthResponse(AppUser user) {
        String accessToken = jwtService.generateAccessToken(user.getId(), user.getEmail());
        String refreshToken = jwtService.generateRefreshToken(user.getId(), user.getEmail());

        return AuthResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .user(AuthResponse.UserDto.builder()
                        .id(user.getId())
                        .email(user.getEmail())
                        .displayName(user.getDisplayName())
                        .xp(user.getXp())
                        .level(user.getLevel())
                        .coins(user.getCoins())
                        .gems(user.getGems())
                        .avatarId(user.getAvatarId())
                        .build())
                .build();
    }
}
