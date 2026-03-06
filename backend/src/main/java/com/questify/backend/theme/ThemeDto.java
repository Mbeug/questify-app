package com.questify.backend.theme;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data @Builder @AllArgsConstructor
public class ThemeDto {
    private Long id;
    private String themeKey;
    private String name;
    private String description;

    // Day (light) colors
    private String dayPrimaryColor;
    private String daySecondaryColor;
    private String dayBackgroundColor;
    private String daySurfaceColor;

    // Night (dark) colors
    private String nightPrimaryColor;
    private String nightSecondaryColor;
    private String nightBackgroundColor;
    private String nightSurfaceColor;

    private ThemeRarity rarity;
    private Integer price;
    private String currency;
    private Boolean isDefault;
    private Boolean owned;
    private Boolean active;
}
