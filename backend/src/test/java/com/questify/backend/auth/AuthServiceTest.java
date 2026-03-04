package com.questify.backend.auth;

import com.questify.backend.user.AppUser;
import com.questify.backend.user.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.server.ResponseStatusException;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtService jwtService;

    @InjectMocks
    private AuthService authService;

    private AppUser user;

    @BeforeEach
    void setUp() {
        user = AppUser.builder()
                .id(1L)
                .email("test@test.com")
                .passwordHash("encodedPassword")
                .displayName("Testeur")
                .xp(0L)
                .level(1)
                .build();
    }

    @Test
    @DisplayName("signup cree un utilisateur et retourne les tokens")
    void signup_createsUserAndReturnsTokens() {
        SignupRequest request = new SignupRequest();
        request.setEmail("new@test.com");
        request.setPassword("password");
        request.setDisplayName("Nouveau");

        when(userRepository.existsByEmail("new@test.com")).thenReturn(false);
        when(passwordEncoder.encode("password")).thenReturn("encodedPwd");
        when(userRepository.save(any(AppUser.class))).thenReturn(user);
        when(jwtService.generateAccessToken(any(), anyString())).thenReturn("access-token");
        when(jwtService.generateRefreshToken(any(), anyString())).thenReturn("refresh-token");

        AuthResponse response = authService.signup(request);

        assertThat(response.getAccessToken()).isEqualTo("access-token");
        assertThat(response.getRefreshToken()).isEqualTo("refresh-token");
        assertThat(response.getUser().getEmail()).isEqualTo("test@test.com");
        verify(userRepository).save(any(AppUser.class));
    }

    @Test
    @DisplayName("signup lance 409 si email deja utilise")
    void signup_duplicateEmail_throwsConflict() {
        SignupRequest request = new SignupRequest();
        request.setEmail("test@test.com");
        request.setPassword("password");
        request.setDisplayName("Duplicate");

        when(userRepository.existsByEmail("test@test.com")).thenReturn(true);

        assertThatThrownBy(() -> authService.signup(request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("deja utilise");
    }

    @Test
    @DisplayName("login retourne les tokens si credentials valides")
    void login_validCredentials_returnsTokens() {
        LoginRequest request = new LoginRequest();
        request.setEmail("test@test.com");
        request.setPassword("password");

        when(userRepository.findByEmail("test@test.com")).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("password", "encodedPassword")).thenReturn(true);
        when(jwtService.generateAccessToken(any(), anyString())).thenReturn("access-token");
        when(jwtService.generateRefreshToken(any(), anyString())).thenReturn("refresh-token");

        AuthResponse response = authService.login(request);

        assertThat(response.getAccessToken()).isEqualTo("access-token");
        assertThat(response.getUser().getDisplayName()).isEqualTo("Testeur");
    }

    @Test
    @DisplayName("login lance 401 si email inconnu")
    void login_unknownEmail_throwsUnauthorized() {
        LoginRequest request = new LoginRequest();
        request.setEmail("unknown@test.com");
        request.setPassword("password");

        when(userRepository.findByEmail("unknown@test.com")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("incorrect");
    }

    @Test
    @DisplayName("login lance 401 si mot de passe incorrect")
    void login_wrongPassword_throwsUnauthorized() {
        LoginRequest request = new LoginRequest();
        request.setEmail("test@test.com");
        request.setPassword("wrong");

        when(userRepository.findByEmail("test@test.com")).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("wrong", "encodedPassword")).thenReturn(false);

        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("incorrect");
    }

    @Test
    @DisplayName("refresh retourne les tokens si refresh token valide")
    void refresh_validToken_returnsNewTokens() {
        RefreshRequest request = new RefreshRequest();
        request.setRefreshToken("valid-refresh-token");

        when(jwtService.isTokenValid("valid-refresh-token")).thenReturn(true);
        when(jwtService.extractTokenType("valid-refresh-token")).thenReturn("refresh");
        when(jwtService.extractUserId("valid-refresh-token")).thenReturn(1L);
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(jwtService.generateAccessToken(any(), anyString())).thenReturn("new-access");
        when(jwtService.generateRefreshToken(any(), anyString())).thenReturn("new-refresh");

        AuthResponse response = authService.refresh(request);

        assertThat(response.getAccessToken()).isEqualTo("new-access");
        assertThat(response.getRefreshToken()).isEqualTo("new-refresh");
    }

    @Test
    @DisplayName("refresh lance 401 si token invalide")
    void refresh_invalidToken_throwsUnauthorized() {
        RefreshRequest request = new RefreshRequest();
        request.setRefreshToken("invalid-token");

        when(jwtService.isTokenValid("invalid-token")).thenReturn(false);

        assertThatThrownBy(() -> authService.refresh(request))
                .isInstanceOf(ResponseStatusException.class);
    }
}
