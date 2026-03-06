package com.questify.backend.quest;

import com.questify.backend.quest.QuestDifficulty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CreateQuestRequest {
    @NotBlank(message = "Titre requis")
    @Size(max = 200, message = "Le titre ne doit pas depasser 200 caracteres")
    private String title;

    @Size(max = 1000, message = "La description ne doit pas depasser 1000 caracteres")
    private String description;

    @NotNull(message = "Difficulte requise")
    private QuestDifficulty difficulty;

    private LocalDateTime dueDate;

    private QuestCategory category;
    private QuestRecurrence recurrence;
}
