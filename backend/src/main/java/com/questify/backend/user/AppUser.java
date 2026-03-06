package com.questify.backend.user;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
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

    @Column // nullable for social login users (Google/Apple)
    private String passwordHash;

    @Builder.Default
    @Column(nullable = false, length = 20)
    private String authProvider = "local"; // "local", "google", "apple"

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
    @Column(nullable = false)
    private Long coins = 0L;

    @Builder.Default
    @Column(nullable = false)
    private Long gems = 0L;

    @Column(length = 50)
    private String avatarId;

    @Column(length = 100)
    private String selectedThemeId;

    @Builder.Default
    @Column(nullable = false)
    private Integer currentStreak = 0;

    @Builder.Default
    @Column(nullable = false)
    private Integer bestStreak = 0;

    private LocalDate lastQuestCompletedDate;

    @Builder.Default
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @PrePersist
    void prePersist() {
        if (createdAt == null) createdAt = LocalDateTime.now();
        if (xp == null) xp = 0L;
        if (level == null) level = 1;
        if (coins == null) coins = 0L;
        if (gems == null) gems = 0L;
        if (currentStreak == null) currentStreak = 0;
        if (bestStreak == null) bestStreak = 0;
        if (authProvider == null) authProvider = "local";
    }
}
