package com.questify.backend.quest;

import com.questify.backend.user.AppUser;
import com.questify.backend.xp.LevelUpResult;
import com.questify.backend.xp.XpService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class QuestServiceTest {

    @Mock
    private QuestRepository questRepository;

    @Mock
    private XpService xpService;

    @InjectMocks
    private QuestService questService;

    private AppUser user;
    private Quest quest;

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

        quest = Quest.builder()
                .id(10L)
                .title("Quete test")
                .description("Description")
                .difficulty(QuestDifficulty.MEDIUM)
                .status(QuestStatus.PENDING)
                .xpReward(50)
                .user(user)
                .createdAt(LocalDateTime.now())
                .build();
    }

    @Test
    @DisplayName("getQuests retourne les quetes de l'utilisateur")
    void getQuests_returnsUserQuests() {
        when(questRepository.findByUserIdOrderByCreatedAtDesc(1L))
                .thenReturn(List.of(quest));

        List<QuestDto> result = questService.getQuests(user);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getTitle()).isEqualTo("Quete test");
    }

    @Test
    @DisplayName("createQuest cree une quete avec le bon XP reward")
    void createQuest_setsCorrectXp() {
        CreateQuestRequest request = new CreateQuestRequest();
        request.setTitle("Nouvelle quete");
        request.setDifficulty(QuestDifficulty.HARD);

        when(xpService.getBaseXp(QuestDifficulty.HARD)).thenReturn(100);
        when(questRepository.save(any(Quest.class))).thenReturn(quest);

        QuestDto result = questService.createQuest(user, request);

        assertThat(result).isNotNull();
        verify(xpService).getBaseXp(QuestDifficulty.HARD);
        verify(questRepository).save(any(Quest.class));
    }

    @Test
    @DisplayName("completeQuest change le status et ajoute l'XP")
    void completeQuest_updatesStatusAndAddsXp() {
        when(questRepository.findById(10L)).thenReturn(Optional.of(quest));
        when(questRepository.save(any(Quest.class))).thenReturn(quest);

        LevelUpResult levelUpResult = new LevelUpResult(50L, 1, false, 50, 50L);
        when(xpService.addXp(user, 50)).thenReturn(levelUpResult);

        QuestDto result = questService.completeQuest(user, 10L);

        assertThat(result.getLevelUpResult()).isNotNull();
        assertThat(result.getLevelUpResult().xpGained()).isEqualTo(50);
        verify(xpService).addXp(user, 50);
    }

    @Test
    @DisplayName("completeQuest lance une erreur si la quete est deja terminee")
    void completeQuest_alreadyCompleted_throws() {
        quest.setStatus(QuestStatus.COMPLETED);
        when(questRepository.findById(10L)).thenReturn(Optional.of(quest));

        assertThatThrownBy(() -> questService.completeQuest(user, 10L))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("deja terminee");
    }

    @Test
    @DisplayName("deleteQuest supprime la quete de l'utilisateur")
    void deleteQuest_removesQuest() {
        when(questRepository.findById(10L)).thenReturn(Optional.of(quest));

        questService.deleteQuest(user, 10L);

        verify(questRepository).delete(quest);
    }

    @Test
    @DisplayName("getQuest lance 403 si la quete n'appartient pas au user")
    void getQuest_wrongUser_throws403() {
        AppUser otherUser = AppUser.builder()
                .id(99L)
                .email("other@test.com")
                .passwordHash("hash")
                .displayName("Autre")
                .build();

        when(questRepository.findById(10L)).thenReturn(Optional.of(quest));

        assertThatThrownBy(() -> questService.getQuest(otherUser, 10L))
                .isInstanceOf(ResponseStatusException.class);
    }

    @Test
    @DisplayName("getQuest lance 404 si la quete n'existe pas")
    void getQuest_notFound_throws404() {
        when(questRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> questService.getQuest(user, 999L))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("introuvable");
    }
}
