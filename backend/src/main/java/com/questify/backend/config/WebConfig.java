package com.questify.backend.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Configuration CORS globale cote MVC.
 * - Autorise localhost/127.0.0.1 sur n'importe quel port (utile en dev Flutter Web).
 * - Expose quelques en-tetes utiles.
 * En prod: remplace par les domaines exacts de ton frontend.
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

  @Override
  public void addCorsMappings(CorsRegistry registry) {
    registry.addMapping("/**")
        .allowedOriginPatterns("http://localhost:*", "http://127.0.0.1:*")
        .allowedMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
        .allowedHeaders("*")
        .exposedHeaders("Location", "Content-Disposition")
        .allowCredentials(true)
        .maxAge(3600);
  }
}
