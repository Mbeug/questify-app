package com.questify.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            // OK pour le prototypage ; on affinera plus tard
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                // Autorise l'endpoint de test sans authentification
                .requestMatchers("/api/hello").permitAll()
                // Tout le reste nécessite une auth
                .anyRequest().authenticated()
            )
            // Auth basique par défaut (utile pour plus tard)
            .httpBasic(Customizer.withDefaults());

        return http.build();
    }
}

