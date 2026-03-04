package com.questify.backend.quest;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface QuestRepository extends JpaRepository<Quest, Long> {
    List<Quest> findByUserIdOrderByCreatedAtDesc(Long userId);
    List<Quest> findByUserIdAndStatusOrderByCreatedAtDesc(Long userId, QuestStatus status);
    long countByUserIdAndStatus(Long userId, QuestStatus status);

    // Find quests with upcoming due dates that haven't been reminded yet
    @Query("SELECT q FROM Quest q WHERE q.status != 'COMPLETED' " +
           "AND q.reminderSent = false " +
           "AND q.dueDate IS NOT NULL " +
           "AND q.dueDate BETWEEN :now AND :deadline " +
           "AND q.user.fcmToken IS NOT NULL " +
           "AND q.user.notificationsEnabled = true")
    List<Quest> findQuestsDueForReminder(
            @Param("now") LocalDateTime now,
            @Param("deadline") LocalDateTime deadline);
}
