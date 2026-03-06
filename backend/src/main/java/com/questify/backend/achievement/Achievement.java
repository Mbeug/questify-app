package com.questify.backend.achievement;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "achievements")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Achievement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String achievementKey;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 500)
    private String description;

    @Column(length = 10)
    private String icon;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private AchievementCategory category;

    // The threshold to unlock this achievement (e.g., complete 10 quests)
    @Column(nullable = false)
    private Integer threshold;

    // Coin reward for unlocking
    @Builder.Default
    @Column(nullable = false)
    private Integer coinReward = 0;

    // Gem reward for unlocking
    @Builder.Default
    @Column(nullable = false)
    private Integer gemReward = 0;
}
