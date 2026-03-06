package com.questify.backend.quest;

import com.questify.backend.achievement.AchievementService;
import com.questify.backend.group.GroupService;
import com.questify.backend.notification.NotificationService;
import com.questify.backend.user.AppUser;
import com.questify.backend.xp.LevelUpResult;
import com.questify.backend.xp.XpService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class QuestService {

    private final QuestRepository questRepository;
    private final XpService xpService;
    private final NotificationService notificationService;
    private final GroupService groupService;
    private final AchievementService achievementService;

    public List<QuestDto> getQuests(AppUser user) {
        return questRepository.findByUserIdOrderByCreatedAtDesc(user.getId())
                .stream()
                .map(QuestDto::from)
                .toList();
    }

    public List<QuestDto> getQuestsByStatus(AppUser user, QuestStatus status) {
        return questRepository.findByUserIdAndStatusOrderByCreatedAtDesc(user.getId(), status)
                .stream()
                .map(QuestDto::from)
                .toList();
    }

    public QuestDto getQuest(AppUser user, Long questId) {
        Quest quest = findQuestForUser(user, questId);
        return QuestDto.from(quest);
    }

    @Transactional
    public QuestDto createQuest(AppUser user, CreateQuestRequest request) {
        int xpReward = xpService.getBaseXp(request.getDifficulty());
        int coinReward = xpService.getBaseCoins(request.getDifficulty());

        Quest quest = Quest.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .difficulty(request.getDifficulty())
                .xpReward(xpReward)
                .coinReward(coinReward)
                .category(request.getCategory())
                .recurrence(request.getRecurrence() != null ? request.getRecurrence() : QuestRecurrence.ONE_TIME)
                .dueDate(request.getDueDate())
                .user(user)
                .build();

        quest = questRepository.save(quest);
        return QuestDto.from(quest);
    }

    @Transactional
    public QuestDto updateQuest(AppUser user, Long questId, UpdateQuestRequest request) {
        Quest quest = findQuestForUser(user, questId);

        if (quest.getStatus() == QuestStatus.COMPLETED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Impossible de modifier une quete terminee");
        }

        if (request.getTitle() != null) quest.setTitle(request.getTitle());
        if (request.getDescription() != null) quest.setDescription(request.getDescription());
        if (request.getDueDate() != null) quest.setDueDate(request.getDueDate());
        if (request.getCalendarEventId() != null) quest.setCalendarEventId(request.getCalendarEventId());

        if (request.getDifficulty() != null && request.getDifficulty() != quest.getDifficulty()) {
            quest.setDifficulty(request.getDifficulty());
            quest.setXpReward(xpService.getBaseXp(request.getDifficulty()));
            quest.setCoinReward(xpService.getBaseCoins(request.getDifficulty()));
        }

        if (request.getCategory() != null) quest.setCategory(request.getCategory());
        if (request.getRecurrence() != null) quest.setRecurrence(request.getRecurrence());

        quest = questRepository.save(quest);
        return QuestDto.from(quest);
    }

    @Transactional
    public QuestDto completeQuest(AppUser user, Long questId) {
        Quest quest = findQuestForUser(user, questId);

        if (quest.getStatus() == QuestStatus.COMPLETED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Cette quete est deja terminee");
        }

        quest.setStatus(QuestStatus.COMPLETED);
        quest.setCompletedAt(LocalDateTime.now());
        questRepository.save(quest);

        LevelUpResult result = xpService.addXp(user, quest.getXpReward(), quest.getDifficulty());

        // Update streak
        LocalDate today = LocalDate.now();
        LocalDate lastCompleted = user.getLastQuestCompletedDate();

        if (lastCompleted == null || lastCompleted.isBefore(today.minusDays(1))) {
            // Streak broken or first quest ever
            user.setCurrentStreak(1);
        } else if (lastCompleted.isBefore(today)) {
            // Consecutive day
            user.setCurrentStreak(user.getCurrentStreak() + 1);
        }
        // If lastCompleted equals today, streak already counted for today

        user.setLastQuestCompletedDate(today);
        if (user.getCurrentStreak() > user.getBestStreak()) {
            user.setBestStreak(user.getCurrentStreak());
        }

        // Update group progress
        groupService.onQuestCompleted(user, quest.getXpReward());

        // Check achievements
        achievementService.checkQuestAchievements(user);

        // Send push notification on level-up
        if (result.leveledUp() && user.getFcmToken() != null
                && user.getNotificationsEnabled()) {
            notificationService.sendLevelUpNotification(
                    user.getFcmToken(), result.level(), result.xpGained());
        }

        QuestDto dto = QuestDto.from(quest);
        dto.setLevelUpResult(result);
        return dto;
    }

    @Transactional
    public void deleteQuest(AppUser user, Long questId) {
        Quest quest = findQuestForUser(user, questId);
        questRepository.delete(quest);
    }

    private Quest findQuestForUser(AppUser user, Long questId) {
        Quest quest = questRepository.findById(questId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Quete introuvable"));

        if (!quest.getUser().getId().equals(user.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Acces refuse");
        }

        return quest;
    }
}
