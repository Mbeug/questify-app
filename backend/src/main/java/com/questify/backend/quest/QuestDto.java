package com.questify.backend.quest;

import com.questify.backend.xp.LevelUpResult;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data @Builder @AllArgsConstructor
public class QuestDto {
    private Long id;
    private String title;
    private String description;
    private QuestStatus status;
    private QuestDifficulty difficulty;
    private Integer xpReward;
    private LocalDateTime dueDate;
    private LocalDateTime completedAt;
    private LocalDateTime createdAt;
    private String calendarEventId;

    // Rempli uniquement lors d'une completion de quete
    private LevelUpResult levelUpResult;

    public static QuestDto from(Quest quest) {
        return QuestDto.builder()
                .id(quest.getId())
                .title(quest.getTitle())
                .description(quest.getDescription())
                .status(quest.getStatus())
                .difficulty(quest.getDifficulty())
                .xpReward(quest.getXpReward())
                .dueDate(quest.getDueDate())
                .completedAt(quest.getCompletedAt())
                .createdAt(quest.getCreatedAt())
                .calendarEventId(quest.getCalendarEventId())
                .build();
    }
}
