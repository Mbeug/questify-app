package com.questify.backend.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class SignupRequest {
    @NotBlank(message = "Email requis")
    @Email(message = "Email invalide")
    private String email;

    @NotBlank(message = "Mot de passe requis")
    @Size(min = 6, message = "Le mot de passe doit faire au moins 6 caracteres")
    private String password;

    @NotBlank(message = "Nom requis")
    @Size(min = 2, max = 100, message = "Le nom doit faire entre 2 et 100 caracteres")
    private String displayName;
}
