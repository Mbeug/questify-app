package com.questify.backend.xp;

import com.questify.backend.quest.QuestDifficulty;
import com.questify.backend.user.AppUser;
import com.questify.backend.user.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class XpServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private XpService xpService;

    private AppUser user;

    @BeforeEach
    void setUp() {
        user = AppUser.builder()
                .id(1L)
                .email("test@test.com")
                .passwordHash("hash")
                .displayName("Testeur")
                .xp(0L)
                .level(1)
                .build();
    }

    @Test
    @DisplayName("getBaseXp retourne le bon XP par difficulte")
    void getBaseXp_returnsCorrectValues() {
        assertThat(xpService.getBaseXp(QuestDifficulty.EASY)).isEqualTo(25);
        assertThat(xpService.getBaseXp(QuestDifficulty.MEDIUM)).isEqualTo(50);
        assertThat(xpService.getBaseXp(QuestDifficulty.HARD)).isEqualTo(100);
        assertThat(xpService.getBaseXp(QuestDifficulty.EPIC)).isEqualTo(200);
    }

    @Test
    @DisplayName("xpRequiredForLevel retourne la bonne formule 100*level^1.5")
    void xpRequiredForLevel_formula() {
        assertThat(xpService.xpRequiredForLevel(1)).isEqualTo(100L);
        assertThat(xpService.xpRequiredForLevel(2)).isEqualTo(Math.round(100 * Math.pow(2, 1.5)));
        assertThat(xpService.xpRequiredForLevel(3)).isEqualTo(Math.round(100 * Math.pow(3, 1.5)));
    }

    @Test
    @DisplayName("totalXpForLevel cumule les XP requis pour tous les niveaux precedents")
    void totalXpForLevel_cumulative() {
        // Level 1: 0 (rien a cumuler)
        assertThat(xpService.totalXpForLevel(1)).isEqualTo(0L);
        // Level 2: xp(1) = 100
        assertThat(xpService.totalXpForLevel(2)).isEqualTo(100L);
        // Level 3: xp(1) + xp(2)
        long expected = 100L + Math.round(100 * Math.pow(2, 1.5));
        assertThat(xpService.totalXpForLevel(3)).isEqualTo(expected);
    }

    @Test
    @DisplayName("addXp ajoute l'XP et ne level-up pas quand insuffisant")
    void addXp_noLevelUp() {
        when(userRepository.save(any(AppUser.class))).thenReturn(user);

        LevelUpResult result = xpService.addXp(user, 50);

        assertThat(result.totalXp()).isEqualTo(50L);
        assertThat(result.level()).isEqualTo(1);
        assertThat(result.leveledUp()).isFalse();
        assertThat(result.xpGained()).isEqualTo(50);
        verify(userRepository).save(user);
    }

    @Test
    @DisplayName("addXp declenche un level-up quand assez d'XP")
    void addXp_triggersLevelUp() {
        when(userRepository.save(any(AppUser.class))).thenReturn(user);

        // Level 2 requires totalXpForLevel(2) = 100 XP
        LevelUpResult result = xpService.addXp(user, 100);

        assertThat(result.level()).isEqualTo(2);
        assertThat(result.leveledUp()).isTrue();
        assertThat(result.totalXp()).isEqualTo(100L);
    }

    @Test
    @DisplayName("addXp gere plusieurs level-ups d'un coup")
    void addXp_multipleLeveUps() {
        when(userRepository.save(any(AppUser.class))).thenReturn(user);

        // Donner assez d'XP pour passer niveaux 2 et 3
        long xpForLevel3 = xpService.totalXpForLevel(3);
        LevelUpResult result = xpService.addXp(user, (int) xpForLevel3);

        assertThat(result.level()).isGreaterThanOrEqualTo(3);
        assertThat(result.leveledUp()).isTrue();
    }
}
