package com.questify.backend.quest;

import jakarta.validation.constraints.Size;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class UpdateQuestRequest {
    @Size(max = 200, message = "Le titre ne doit pas depasser 200 caracteres")
    private String title;

    @Size(max = 1000, message = "La description ne doit pas depasser 1000 caracteres")
    private String description;

    private QuestDifficulty difficulty;

    private QuestStatus status;

    private LocalDateTime dueDate;

    // Google Calendar event ID (sent from mobile client after creating calendar event)
    private String calendarEventId;
}
