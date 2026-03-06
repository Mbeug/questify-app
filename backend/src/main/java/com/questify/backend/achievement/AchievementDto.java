package com.questify.backend.achievement;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

@Data @Builder @AllArgsConstructor
public class AchievementDto {
    private Long id;
    private String achievementKey;
    private String name;
    private String description;
    private String icon;
    private AchievementCategory category;
    private Integer threshold;
    private Integer coinReward;
    private Integer gemReward;
    private Integer progress;
    private Boolean unlocked;
    private LocalDateTime unlockedAt;
}
