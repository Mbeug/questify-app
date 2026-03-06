package com.questify.backend.group;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class JoinGroupRequest {
    @NotBlank(message = "Code d'invitation requis")
    private String inviteCode;
}
