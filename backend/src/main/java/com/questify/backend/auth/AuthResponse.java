package com.questify.backend.auth;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data @Builder @AllArgsConstructor
public class AuthResponse {
    private String accessToken;
    private String refreshToken;
    private UserDto user;

    @Data @Builder @AllArgsConstructor
    public static class UserDto {
        private Long id;
        private String email;
        private String displayName;
        private Long xp;
        private Integer level;
        private Long coins;
        private Long gems;
        private String avatarId;
    }
}
