package com.questify.backend.auth;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class SocialLoginRequest {
    // ID token (used on mobile, where Google SDK provides it directly)
    private String idToken;

    // Access token (used on web, where Google Identity Services provides it instead of idToken)
    private String accessToken;

    @NotBlank(message = "Provider requis (google ou apple)")
    private String provider; // "google" or "apple"

    // Optional: display name (Apple may provide it only on first sign-in)
    private String displayName;
}
