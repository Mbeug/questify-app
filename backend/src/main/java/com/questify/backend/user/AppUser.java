package com.questify.backend.user;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class AppUser {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 255)
    private String email;

    @Column(nullable = false)
    private String passwordHash;

    @Column(nullable = false, length = 100)
    private String displayName;

    @Builder.Default
    @Column(nullable = false)
    private Long xp = 0L;

    @Builder.Default
    @Column(nullable = false)
    private Integer level = 1;

    // FCM token for push notifications (set by the mobile client)
    @Column(length = 512)
    private String fcmToken;

    @Builder.Default
    @Column(nullable = false)
    private Boolean notificationsEnabled = true;

    @Builder.Default
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @PrePersist
    void prePersist() {
        if (createdAt == null) createdAt = LocalDateTime.now();
        if (xp == null) xp = 0L;
        if (level == null) level = 1;
    }
}
