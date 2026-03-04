package com.questify.backend.xp;

public record LevelUpResult(
    long totalXp,
    int level,
    boolean leveledUp,
    int xpGained,
    long xpToNextLevel
) {}
