package com.questify.backend.notification;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import jakarta.annotation.PostConstruct;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.FileInputStream;

/**
 * Initializes Firebase Admin SDK if credentials are provided.
 * If not configured, all notification sends are silently skipped.
 */
@Component
@Slf4j
public class FirebaseMessagingProvider {

    @Value("${firebase.credentials-path:}")
    private String credentialsPath;

    @Value("${firebase.enabled:false}")
    @Getter
    private boolean enabled;

    @PostConstruct
    public void init() {
        if (!enabled || credentialsPath == null || credentialsPath.isBlank()) {
            log.info("Firebase push notifications DISABLED (firebase.enabled={}, path={})",
                    enabled, credentialsPath);
            return;
        }

        if (!FirebaseApp.getApps().isEmpty()) {
            log.info("Firebase already initialized");
            return;
        }

        try (FileInputStream fis = new FileInputStream(credentialsPath)) {
            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(fis))
                    .build();
            FirebaseApp.initializeApp(options);
            log.info("Firebase initialized from {}", credentialsPath);
        } catch (Exception e) {
            log.error("Failed to initialize Firebase: {}", e.getMessage(), e);
            enabled = false;
        }
    }
}
