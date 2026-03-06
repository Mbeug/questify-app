package com.questify.backend.theme;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "app_themes")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class AppTheme {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String themeKey;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 500)
    private String description;

    // ── Day (light) colors ──
    @Column(nullable = false, length = 7)
    private String dayPrimaryColor;

    @Column(nullable = false, length = 7)
    private String daySecondaryColor;

    @Column(nullable = false, length = 7)
    private String dayBackgroundColor;

    @Column(nullable = false, length = 7)
    private String daySurfaceColor;

    // ── Night (dark) colors ──
    @Column(nullable = false, length = 7)
    private String nightPrimaryColor;

    @Column(nullable = false, length = 7)
    private String nightSecondaryColor;

    @Column(nullable = false, length = 7)
    private String nightBackgroundColor;

    @Column(nullable = false, length = 7)
    private String nightSurfaceColor;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ThemeRarity rarity;

    @Builder.Default
    @Column(nullable = false)
    private Integer price = 0;

    @Column(length = 10)
    private String currency; // "coins" or "gems"

    @Builder.Default
    @Column(nullable = false)
    private Boolean isDefault = false;
}
