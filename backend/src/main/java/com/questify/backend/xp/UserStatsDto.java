package com.questify.backend.xp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data @Builder @AllArgsConstructor
public class UserStatsDto {
    private Long xp;
    private Integer level;
    private Long xpToNextLevel;
    private Long xpForCurrentLevel;
    private Long totalQuestsCompleted;
    private double progressPercent;
    // Currency & streak fields
    private Long coins;
    private Long gems;
    private Integer currentStreak;
    private Integer bestStreak;
}
