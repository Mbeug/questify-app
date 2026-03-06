package com.questify.backend.user;

import com.questify.backend.quest.QuestRepository;
import com.questify.backend.quest.QuestStatus;
import com.questify.backend.xp.UserStatsDto;
import com.questify.backend.xp.XpService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final XpService xpService;
    private final QuestRepository questRepository;

    @GetMapping("/me")
    public UserProfileDto getMe(@AuthenticationPrincipal AppUser user) {
        return UserProfileDto.builder()
                .id(user.getId())
                .email(user.getEmail())
                .displayName(user.getDisplayName())
                .xp(user.getXp())
                .level(user.getLevel())
                .createdAt(user.getCreatedAt())
                .notificationsEnabled(user.getNotificationsEnabled())
                .coins(user.getCoins())
                .gems(user.getGems())
                .avatarId(user.getAvatarId())
                .currentStreak(user.getCurrentStreak())
                .bestStreak(user.getBestStreak())
                .build();
    }

    @GetMapping("/me/stats")
    public UserStatsDto getMyStats(@AuthenticationPrincipal AppUser user) {
        long completedCount = questRepository.countByUserIdAndStatus(user.getId(), QuestStatus.COMPLETED);
        long xpForNextLevel = xpService.totalXpForLevel(user.getLevel() + 1);
        long xpForCurrentLevel = xpService.totalXpForLevel(user.getLevel());
        long xpInCurrentLevel = user.getXp() - xpForCurrentLevel;
        long xpNeededForLevel = xpForNextLevel - xpForCurrentLevel;
        double progress = xpNeededForLevel > 0 ? (double) xpInCurrentLevel / xpNeededForLevel * 100 : 100;

        return UserStatsDto.builder()
                .xp(user.getXp())
                .level(user.getLevel())
                .xpToNextLevel(xpForNextLevel - user.getXp())
                .xpForCurrentLevel(xpNeededForLevel)
                .totalQuestsCompleted(completedCount)
                .progressPercent(Math.min(progress, 100))
                .coins(user.getCoins())
                .gems(user.getGems())
                .currentStreak(user.getCurrentStreak())
                .bestStreak(user.getBestStreak())
                .build();
    }

    @PatchMapping("/me")
    public UserProfileDto updateMe(@AuthenticationPrincipal AppUser user,
                                   @RequestBody UpdateProfileRequest request) {
        if (request.getDisplayName() != null && !request.getDisplayName().isBlank()) {
            user.setDisplayName(request.getDisplayName());
        }
        if (request.getFcmToken() != null) {
            user.setFcmToken(request.getFcmToken());
        }
        if (request.getNotificationsEnabled() != null) {
            user.setNotificationsEnabled(request.getNotificationsEnabled());
        }
        if (request.getAvatarId() != null) {
            user.setAvatarId(request.getAvatarId());
        }
        // Pas besoin de repo.save ici car user est managed par JPA dans la transaction
        return UserProfileDto.builder()
                .id(user.getId())
                .email(user.getEmail())
                .displayName(user.getDisplayName())
                .xp(user.getXp())
                .level(user.getLevel())
                .createdAt(user.getCreatedAt())
                .notificationsEnabled(user.getNotificationsEnabled())
                .coins(user.getCoins())
                .gems(user.getGems())
                .avatarId(user.getAvatarId())
                .currentStreak(user.getCurrentStreak())
                .bestStreak(user.getBestStreak())
                .build();
    }
}
