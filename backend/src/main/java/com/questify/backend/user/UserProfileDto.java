package com.questify.backend.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data @Builder @AllArgsConstructor
public class UserProfileDto {
    private Long id;
    private String email;
    private String displayName;
    private Long xp;
    private Integer level;
    private LocalDateTime createdAt;
    private Boolean notificationsEnabled;
    private Long coins;
    private Long gems;
    private String avatarId;
    private Integer currentStreak;
    private Integer bestStreak;
}
