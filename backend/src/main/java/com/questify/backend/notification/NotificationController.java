package com.questify.backend.notification;

import com.questify.backend.user.AppUser;
import com.questify.backend.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final UserRepository userRepository;

    /**
     * Register or update the FCM token for the authenticated user.
     * Called by the mobile client at startup / token refresh.
     */
    @PostMapping("/register")
    public Map<String, Object> registerFcmToken(
            @AuthenticationPrincipal AppUser user,
            @RequestBody RegisterFcmTokenRequest request) {

        user.setFcmToken(request.getFcmToken());
        userRepository.save(user);

        return Map.of(
                "success", true,
                "message", "FCM token enregistre"
        );
    }

    /**
     * Toggle notification preferences for the authenticated user.
     */
    @PatchMapping("/preferences")
    public Map<String, Object> updatePreferences(
            @AuthenticationPrincipal AppUser user,
            @RequestBody NotificationPreferencesRequest request) {

        if (request.getEnabled() != null) {
            user.setNotificationsEnabled(request.getEnabled());
        }
        userRepository.save(user);

        return Map.of(
                "success", true,
                "notificationsEnabled", user.getNotificationsEnabled()
        );
    }

    /**
     * Get notification preferences for the authenticated user.
     */
    @GetMapping("/preferences")
    public Map<String, Object> getPreferences(@AuthenticationPrincipal AppUser user) {
        return Map.of(
                "notificationsEnabled", user.getNotificationsEnabled(),
                "hasFcmToken", user.getFcmToken() != null && !user.getFcmToken().isBlank()
        );
    }
}
