package com.questify.backend.notification;

import com.questify.backend.quest.Quest;
import com.questify.backend.quest.QuestRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Periodically checks for quests with upcoming due dates and sends
 * push notification reminders to users who have FCM tokens.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class QuestReminderScheduler {

    private final QuestRepository questRepository;
    private final NotificationService notificationService;

    @Value("${questify.reminders.enabled:true}")
    private boolean remindersEnabled;

    @Value("${questify.reminders.hours-before:24}")
    private int hoursBefore;

    /**
     * Runs every 15 minutes. Finds quests due within {@code hoursBefore} hours
     * that have not been reminded yet, sends a notification, and marks them as reminded.
     */
    @Scheduled(fixedRateString = "${questify.reminders.check-interval-ms:900000}")
    @Transactional
    public void checkAndSendReminders() {
        if (!remindersEnabled) return;

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime deadline = now.plusHours(hoursBefore);

        List<Quest> dueQuests = questRepository.findQuestsDueForReminder(now, deadline);

        if (dueQuests.isEmpty()) return;

        log.info("Found {} quests due for reminder", dueQuests.size());

        for (Quest quest : dueQuests) {
            String fcmToken = quest.getUser().getFcmToken();
            if (fcmToken != null && !fcmToken.isBlank()) {
                notificationService.sendQuestReminder(fcmToken, quest.getTitle(), quest.getId());
                quest.setReminderSent(true);
                questRepository.save(quest);
                log.debug("Reminder sent for quest {} to user {}", quest.getId(), quest.getUser().getId());
            }
        }
    }
}
