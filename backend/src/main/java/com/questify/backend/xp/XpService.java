package com.questify.backend.xp;

import com.questify.backend.quest.QuestDifficulty;
import com.questify.backend.user.AppUser;
import com.questify.backend.user.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class XpService {

    private final UserRepository userRepository;

    /**
     * XP de base par difficulte de quete.
     */
    public int getBaseXp(QuestDifficulty difficulty) {
        return switch (difficulty) {
            case EASY   -> 25;
            case MEDIUM -> 50;
            case HARD   -> 100;
            case EPIC   -> 200;
        };
    }

    /**
     * Coins de base par difficulte.
     */
    public int getBaseCoins(QuestDifficulty difficulty) {
        return switch (difficulty) {
            case EASY   -> 10;
            case MEDIUM -> 20;
            case HARD   -> 50;
            case EPIC   -> 100;
        };
    }

    /**
     * Gems bonus (rares - seulement pour HARD et EPIC).
     */
    public int getBaseGems(QuestDifficulty difficulty) {
        return switch (difficulty) {
            case EASY   -> 0;
            case MEDIUM -> 0;
            case HARD   -> 1;
            case EPIC   -> 3;
        };
    }

    /**
     * XP requis pour atteindre un niveau donne.
     * Formule : 100 * level^1.5 (arrondi)
     */
    public long xpRequiredForLevel(int level) {
        return Math.round(100 * Math.pow(level, 1.5));
    }

    /**
     * XP total requis depuis le debut pour atteindre un niveau.
     */
    public long totalXpForLevel(int level) {
        long total = 0;
        for (int i = 1; i < level; i++) {
            total += xpRequiredForLevel(i);
        }
        return total;
    }

    /**
     * Ajoute de l'XP a un utilisateur et gere les level-ups.
     */
    @Transactional
    public LevelUpResult addXp(AppUser user, int xpGained, QuestDifficulty difficulty) {
        long oldXp = user.getXp();
        int oldLevel = user.getLevel();

        user.setXp(oldXp + xpGained);

        // Verifier les level-ups
        while (user.getXp() >= totalXpForLevel(user.getLevel() + 1)) {
            user.setLevel(user.getLevel() + 1);
        }

        // Award coins and gems
        int coinsEarned = getBaseCoins(difficulty);
        int gemsEarned = getBaseGems(difficulty);

        // Bonus coins on level-up
        boolean leveledUp = user.getLevel() > oldLevel;
        if (leveledUp) {
            coinsEarned += 50 * user.getLevel();
            gemsEarned += 5;
        }

        user.setCoins(user.getCoins() + coinsEarned);
        user.setGems(user.getGems() + gemsEarned);

        userRepository.save(user);

        if (leveledUp) {
            log.info("Utilisateur {} a monte au niveau {} !", user.getId(), user.getLevel());
        }

        return new LevelUpResult(
                user.getXp(),
                user.getLevel(),
                leveledUp,
                xpGained,
                totalXpForLevel(user.getLevel() + 1) - user.getXp(),
                coinsEarned,
                gemsEarned
        );
    }
}
