package com.questify.backend.group;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class CreateGroupRequest {
    @NotBlank(message = "Nom du groupe requis")
    @Size(max = 100)
    private String name;

    @Size(max = 500)
    private String description;

    private String bannerEmoji;
    private Integer weeklyGoal;
}
