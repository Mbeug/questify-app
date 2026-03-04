package com.questify.backend.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class LoginRequest {
    @NotBlank(message = "Email requis")
    @Email(message = "Email invalide")
    private String email;

    @NotBlank(message = "Mot de passe requis")
    private String password;
}
