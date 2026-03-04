package com.questify.backend.auth;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RefreshRequest {
    @NotBlank(message = "Refresh token requis")
    private String refreshToken;
}
