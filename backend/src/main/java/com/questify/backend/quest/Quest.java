package com.questify.backend.quest;

import com.questify.backend.user.AppUser;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "quests")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Quest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(length = 1000)
    private String description;

    @Builder.Default
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private QuestStatus status = QuestStatus.PENDING;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 10)
    private QuestDifficulty difficulty;

    @Column(nullable = false)
    private Integer xpReward;

    private LocalDateTime dueDate;

    private LocalDateTime completedAt;

    // Google Calendar event ID (synced from the mobile client)
    @Column(length = 512)
    private String calendarEventId;

    // Whether a due-date reminder notification was already sent
    @Builder.Default
    @Column(nullable = false)
    private Boolean reminderSent = false;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private AppUser user;

    @Builder.Default
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @PrePersist
    void prePersist() {
        if (createdAt == null) createdAt = LocalDateTime.now();
        if (status == null) status = QuestStatus.PENDING;
    }
}
