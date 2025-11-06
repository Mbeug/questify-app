package com.questify.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Sécurité Spring.
 * Points clés:
 *  - .cors(Customizer.withDefaults()) pour ACTIVER CORS (et donc utiliser WebConfig ci-dessus)
 *  - /api/hello et /actuator/health autorisés en public
 *  - CSRF désactivé pour les tests d'API (à ajuster si tu fais des formulaires)
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

  @Bean
  public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .cors(Customizer.withDefaults()) // <-- active la config CORS
        .csrf(csrf -> csrf.disable())
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/api/hello", "/actuator/health").permitAll()
            .anyRequest().authenticated()
        );

    return http.build();
  }
}