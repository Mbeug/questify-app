package com.questify.backend.xp;

public record LevelUpResult(
    long totalXp,
    int level,
    boolean leveledUp,
    int xpGained,
    long xpToNextLevel,
    int coinsEarned,
    int gemsEarned
) {}
