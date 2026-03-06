package com.questify.backend.achievement;

import com.questify.backend.user.AppUser;
import com.questify.backend.user.UserRepository;
import com.questify.backend.quest.QuestRepository;
import com.questify.backend.quest.QuestStatus;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class AchievementService {

    private final AchievementRepository achievementRepository;
    private final UserAchievementRepository userAchievementRepository;
    private final UserRepository userRepository;
    private final QuestRepository questRepository;

    @Bean
    CommandLineRunner seedAchievements() {
        return args -> {
            if (achievementRepository.count() > 0) return;

            List<Achievement> achievements = List.of(
                // Quest achievements
                Achievement.builder()
                    .achievementKey("first_quest")
                    .name("Premier Pas")
                    .description("Completez votre premiere quete")
                    .icon("\uD83C\uDFAF")
                    .category(AchievementCategory.QUESTS)
                    .threshold(1)
                    .coinReward(50)
                    .gemReward(1)
                    .build(),
                Achievement.builder()
                    .achievementKey("quest_10")
                    .name("Aventurier")
                    .description("Completez 10 quetes")
                    .icon("\u2694\uFE0F")
                    .category(AchievementCategory.QUESTS)
                    .threshold(10)
                    .coinReward(100)
                    .gemReward(2)
                    .build(),
                Achievement.builder()
                    .achievementKey("quest_50")
                    .name("Heros")
                    .description("Completez 50 quetes")
                    .icon("\uD83D\uDEE1\uFE0F")
                    .category(AchievementCategory.QUESTS)
                    .threshold(50)
                    .coinReward(300)
                    .gemReward(5)
                    .build(),
                Achievement.builder()
                    .achievementKey("quest_100")
                    .name("Legende Vivante")
                    .description("Completez 100 quetes")
                    .icon("\uD83D\uDC51")
                    .category(AchievementCategory.QUESTS)
                    .threshold(100)
                    .coinReward(500)
                    .gemReward(10)
                    .build(),

                // Streak achievements
                Achievement.builder()
                    .achievementKey("streak_3")
                    .name("Regulier")
                    .description("Maintenez une serie de 3 jours")
                    .icon("\uD83D\uDD25")
                    .category(AchievementCategory.STREAKS)
                    .threshold(3)
                    .coinReward(50)
                    .gemReward(1)
                    .build(),
                Achievement.builder()
                    .achievementKey("streak_7")
                    .name("Discipline")
                    .description("Maintenez une serie de 7 jours")
                    .icon("\uD83D\uDCAA")
                    .category(AchievementCategory.STREAKS)
                    .threshold(7)
                    .coinReward(150)
                    .gemReward(3)
                    .build(),
                Achievement.builder()
                    .achievementKey("streak_30")
                    .name("Indestructible")
                    .description("Maintenez une serie de 30 jours")
                    .icon("\u26A1")
                    .category(AchievementCategory.STREAKS)
                    .threshold(30)
                    .coinReward(500)
                    .gemReward(10)
                    .build(),

                // Level achievements
                Achievement.builder()
                    .achievementKey("level_5")
                    .name("Apprenti")
                    .description("Atteignez le niveau 5")
                    .icon("\uD83D\uDCD6")
                    .category(AchievementCategory.LEVELS)
                    .threshold(5)
                    .coinReward(100)
                    .gemReward(2)
                    .build(),
                Achievement.builder()
                    .achievementKey("level_10")
                    .name("Expert")
                    .description("Atteignez le niveau 10")
                    .icon("\uD83C\uDF93")
                    .category(AchievementCategory.LEVELS)
                    .threshold(10)
                    .coinReward(200)
                    .gemReward(5)
                    .build(),
                Achievement.builder()
                    .achievementKey("level_25")
                    .name("Maitre")
                    .description("Atteignez le niveau 25")
                    .icon("\uD83C\uDFC6")
                    .category(AchievementCategory.LEVELS)
                    .threshold(25)
                    .coinReward(500)
                    .gemReward(15)
                    .build(),

                // Social achievements
                Achievement.builder()
                    .achievementKey("join_group")
                    .name("Esprit d'Equipe")
                    .description("Rejoignez un groupe")
                    .icon("\uD83E\uDD1D")
                    .category(AchievementCategory.SOCIAL)
                    .threshold(1)
                    .coinReward(50)
                    .gemReward(1)
                    .build(),

                // Collection achievements
                Achievement.builder()
                    .achievementKey("buy_theme")
                    .name("Collectionneur")
                    .description("Achetez votre premier theme")
                    .icon("\uD83C\uDFA8")
                    .category(AchievementCategory.COLLECTION)
                    .threshold(1)
                    .coinReward(50)
                    .gemReward(1)
                    .build()
            );

            achievementRepository.saveAll(achievements);
            log.info("Seeded {} achievements", achievements.size());
        };
    }

    public List<AchievementDto> getUserAchievements(AppUser user) {
        List<Achievement> allAchievements = achievementRepository.findAll();
        List<UserAchievement> userAchievements = userAchievementRepository.findByUserId(user.getId());

        return allAchievements.stream().map(achievement -> {
            UserAchievement ua = userAchievements.stream()
                    .filter(u -> u.getAchievement().getId().equals(achievement.getId()))
                    .findFirst()
                    .orElse(null);

            return AchievementDto.builder()
                    .id(achievement.getId())
                    .achievementKey(achievement.getAchievementKey())
                    .name(achievement.getName())
                    .description(achievement.getDescription())
                    .icon(achievement.getIcon())
                    .category(achievement.getCategory())
                    .threshold(achievement.getThreshold())
                    .coinReward(achievement.getCoinReward())
                    .gemReward(achievement.getGemReward())
                    .progress(ua != null ? ua.getProgress() : 0)
                    .unlocked(ua != null && ua.getUnlocked())
                    .unlockedAt(ua != null ? ua.getUnlockedAt() : null)
                    .build();
        }).toList();
    }

    /**
     * Check and award achievements after quest completion.
     * Returns list of newly unlocked achievements.
     */
    @Transactional
    public List<AchievementDto> checkQuestAchievements(AppUser user) {
        long completedCount = questRepository.countByUserIdAndStatus(user.getId(), QuestStatus.COMPLETED);
        List<AchievementDto> newlyUnlocked = new ArrayList<>();

        // Check quest-count achievements
        List<Achievement> questAchievements = achievementRepository.findByCategory(AchievementCategory.QUESTS);
        for (Achievement achievement : questAchievements) {
            newlyUnlocked.addAll(checkAndAward(user, achievement, (int) completedCount));
        }

        // Check streak achievements
        List<Achievement> streakAchievements = achievementRepository.findByCategory(AchievementCategory.STREAKS);
        for (Achievement achievement : streakAchievements) {
            newlyUnlocked.addAll(checkAndAward(user, achievement, user.getCurrentStreak()));
        }

        // Check level achievements
        List<Achievement> levelAchievements = achievementRepository.findByCategory(AchievementCategory.LEVELS);
        for (Achievement achievement : levelAchievements) {
            newlyUnlocked.addAll(checkAndAward(user, achievement, user.getLevel()));
        }

        return newlyUnlocked;
    }

    /**
     * Check a specific achievement type (e.g., SOCIAL for joining a group).
     */
    @Transactional
    public List<AchievementDto> checkAchievement(AppUser user, String achievementKey, int currentValue) {
        Achievement achievement = achievementRepository.findByAchievementKey(achievementKey).orElse(null);
        if (achievement == null) return List.of();
        return checkAndAward(user, achievement, currentValue);
    }

    private List<AchievementDto> checkAndAward(AppUser user, Achievement achievement, int currentValue) {
        List<AchievementDto> result = new ArrayList<>();

        UserAchievement ua = userAchievementRepository.findByUserIdAndAchievementId(user.getId(), achievement.getId())
                .orElseGet(() -> {
                    UserAchievement newUa = UserAchievement.builder()
                            .user(user)
                            .achievement(achievement)
                            .progress(0)
                            .unlocked(false)
                            .build();
                    return userAchievementRepository.save(newUa);
                });

        // Update progress
        ua.setProgress(Math.min(currentValue, achievement.getThreshold()));

        // Check if newly unlocked
        if (!ua.getUnlocked() && currentValue >= achievement.getThreshold()) {
            ua.setUnlocked(true);
            ua.setUnlockedAt(LocalDateTime.now());
            userAchievementRepository.save(ua);

            // Award coins and gems
            user.setCoins(user.getCoins() + achievement.getCoinReward().longValue());
            user.setGems(user.getGems() + achievement.getGemReward().longValue());
            userRepository.save(user);

            log.info("Achievement unlocked: {} for user {}", achievement.getName(), user.getId());

            result.add(AchievementDto.builder()
                    .id(achievement.getId())
                    .achievementKey(achievement.getAchievementKey())
                    .name(achievement.getName())
                    .description(achievement.getDescription())
                    .icon(achievement.getIcon())
                    .category(achievement.getCategory())
                    .threshold(achievement.getThreshold())
                    .coinReward(achievement.getCoinReward())
                    .gemReward(achievement.getGemReward())
                    .progress(achievement.getThreshold())
                    .unlocked(true)
                    .unlockedAt(ua.getUnlockedAt())
                    .build());
        } else {
            userAchievementRepository.save(ua);
        }

        return result;
    }
}
