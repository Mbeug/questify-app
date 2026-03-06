package com.questify.backend.user;

import lombok.Data;

@Data
public class UpdateProfileRequest {
    private String displayName;
    private String fcmToken;
    private Boolean notificationsEnabled;
    private String avatarId;
}
