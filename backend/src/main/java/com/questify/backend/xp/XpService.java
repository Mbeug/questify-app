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
    public LevelUpResult addXp(AppUser user, int xpGained) {
        long oldXp = user.getXp();
        int oldLevel = user.getLevel();

        user.setXp(oldXp + xpGained);

        // Verifier les level-ups
        while (user.getXp() >= totalXpForLevel(user.getLevel() + 1)) {
            user.setLevel(user.getLevel() + 1);
        }

        userRepository.save(user);

        boolean leveledUp = user.getLevel() > oldLevel;
        if (leveledUp) {
            log.info("Utilisateur {} a monte au niveau {} !", user.getId(), user.getLevel());
        }

        return new LevelUpResult(
                user.getXp(),
                user.getLevel(),
                leveledUp,
                xpGained,
                totalXpForLevel(user.getLevel() + 1) - user.getXp()
        );
    }
}
