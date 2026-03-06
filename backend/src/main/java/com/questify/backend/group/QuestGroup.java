package com.questify.backend.group;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "quest_groups")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class QuestGroup {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 500)
    private String description;

    @Column(length = 100)
    private String bannerEmoji;

    // Unique invite code (8 chars)
    @Column(nullable = false, unique = true, length = 8)
    private String inviteCode;

    @Builder.Default
    @Column(nullable = false)
    private Integer weeklyGoal = 10;

    @Builder.Default
    @Column(nullable = false)
    private Integer weeklyProgress = 0;

    @Builder.Default
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @PrePersist
    void prePersist() {
        if (createdAt == null) createdAt = LocalDateTime.now();
        if (weeklyGoal == null) weeklyGoal = 10;
        if (weeklyProgress == null) weeklyProgress = 0;
    }
}
