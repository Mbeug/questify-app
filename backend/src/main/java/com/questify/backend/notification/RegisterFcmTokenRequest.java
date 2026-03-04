package com.questify.backend.notification;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RegisterFcmTokenRequest {
    @NotBlank(message = "FCM token requis")
    private String fcmToken;
}
