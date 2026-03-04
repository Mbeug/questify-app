package com.questify.backend.auth;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Service
public class JwtService {

    private final SecretKey signingKey;
    private final long accessTokenExpMs;
    private final long refreshTokenExpMs;

    public JwtService(
            @Value("${jwt.secret:questify-super-secret-key-change-in-production-min-256-bits!!}") String secret,
            @Value("${jwt.access-token-expiration-ms:900000}") long accessTokenExpMs,     // 15 min
            @Value("${jwt.refresh-token-expiration-ms:604800000}") long refreshTokenExpMs  // 7 jours
    ) {
        this.signingKey = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        this.accessTokenExpMs = accessTokenExpMs;
        this.refreshTokenExpMs = refreshTokenExpMs;
    }

    public String generateAccessToken(Long userId, String email) {
        return buildToken(userId, email, accessTokenExpMs, "access");
    }

    public String generateRefreshToken(Long userId, String email) {
        return buildToken(userId, email, refreshTokenExpMs, "refresh");
    }

    public Claims parseToken(String token) {
        return Jwts.parser()
                .verifyWith(signingKey)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    public boolean isTokenValid(String token) {
        try {
            parseToken(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    public Long extractUserId(String token) {
        return parseToken(token).get("userId", Long.class);
    }

    public String extractEmail(String token) {
        return parseToken(token).getSubject();
    }

    public String extractTokenType(String token) {
        return parseToken(token).get("type", String.class);
    }

    private String buildToken(Long userId, String email, long expirationMs, String type) {
        Date now = new Date();
        return Jwts.builder()
                .subject(email)
                .claim("userId", userId)
                .claim("type", type)
                .issuedAt(now)
                .expiration(new Date(now.getTime() + expirationMs))
                .signWith(signingKey)
                .compact();
    }
}
