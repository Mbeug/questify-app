package com.questify.backend.theme;

import com.questify.backend.user.AppUser;
import com.questify.backend.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ThemeService {

    private final ThemeRepository themeRepository;
    private final UserThemeRepository userThemeRepository;
    private final UserRepository userRepository;

    /**
     * Seed predefined themes on startup.
     * Each theme now has both day (light) and night (dark) color sets.
     */
    @Bean
    CommandLineRunner seedThemes() {
        return args -> {
            if (themeRepository.count() > 0) return;

            List<AppTheme> themes = List.of(
                AppTheme.builder()
                    .themeKey("default")
                    .name("Questify Classique")
                    .description("Le theme par defaut de Questify")
                    .dayPrimaryColor("#A75EFF")
                    .daySecondaryColor("#FFD166")
                    .dayBackgroundColor("#F5F7FA")
                    .daySurfaceColor("#FFFFFF")
                    .nightPrimaryColor("#A75EFF")
                    .nightSecondaryColor("#FFD166")
                    .nightBackgroundColor("#1B1B2F")
                    .nightSurfaceColor("#25274D")
                    .rarity(ThemeRarity.COMMON)
                    .price(0)
                    .currency("coins")
                    .isDefault(true)
                    .build(),
                AppTheme.builder()
                    .themeKey("ocean_depths")
                    .name("Profondeurs Oceaniques")
                    .description("Un theme inspire des abysses marines")
                    .dayPrimaryColor("#0077B6")
                    .daySecondaryColor("#00B4D8")
                    .dayBackgroundColor("#E8F4FD")
                    .daySurfaceColor("#FFFFFF")
                    .nightPrimaryColor("#0077B6")
                    .nightSecondaryColor("#00B4D8")
                    .nightBackgroundColor("#023E8A")
                    .nightSurfaceColor("#0353A4")
                    .rarity(ThemeRarity.UNCOMMON)
                    .price(200)
                    .currency("coins")
                    .isDefault(false)
                    .build(),
                AppTheme.builder()
                    .themeKey("emerald_forest")
                    .name("Foret d'Emeraude")
                    .description("Un theme verdoyant et apaisant")
                    .dayPrimaryColor("#06D6A0")
                    .daySecondaryColor("#118AB2")
                    .dayBackgroundColor("#ECFDF5")
                    .daySurfaceColor("#FFFFFF")
                    .nightPrimaryColor("#06D6A0")
                    .nightSecondaryColor("#118AB2")
                    .nightBackgroundColor("#1B4332")
                    .nightSurfaceColor("#2D6A4F")
                    .rarity(ThemeRarity.UNCOMMON)
                    .price(200)
                    .currency("coins")
                    .isDefault(false)
                    .build(),
                AppTheme.builder()
                    .themeKey("solar_flare")
                    .name("Eruption Solaire")
                    .description("Un theme ardent et energique")
                    .dayPrimaryColor("#FF6B6B")
                    .daySecondaryColor("#FFD166")
                    .dayBackgroundColor("#FFF5F5")
                    .daySurfaceColor("#FFFFFF")
                    .nightPrimaryColor("#FF6B6B")
                    .nightSecondaryColor("#FFD166")
                    .nightBackgroundColor("#2B0A0A")
                    .nightSurfaceColor("#4A1515")
                    .rarity(ThemeRarity.RARE)
                    .price(500)
                    .currency("coins")
                    .isDefault(false)
                    .build(),
                AppTheme.builder()
                    .themeKey("cyber_neon")
                    .name("Neon Cybernetique")
                    .description("Un theme futuriste aux couleurs electriques")
                    .dayPrimaryColor("#FF00FF")
                    .daySecondaryColor("#00FFFF")
                    .dayBackgroundColor("#F8F0FF")
                    .daySurfaceColor("#FFFFFF")
                    .nightPrimaryColor("#FF00FF")
                    .nightSecondaryColor("#00FFFF")
                    .nightBackgroundColor("#0D0221")
                    .nightSurfaceColor("#1A0533")
                    .rarity(ThemeRarity.EPIC)
                    .price(50)
                    .currency("gems")
                    .isDefault(false)
                    .build(),
                AppTheme.builder()
                    .themeKey("legendary_gold")
                    .name("Or Legendaire")
                    .description("Le theme ultime reserve aux vrais champions")
                    .dayPrimaryColor("#FFD700")
                    .daySecondaryColor("#FFA500")
                    .dayBackgroundColor("#FFFDF0")
                    .daySurfaceColor("#FFFFFF")
                    .nightPrimaryColor("#FFD700")
                    .nightSecondaryColor("#FFA500")
                    .nightBackgroundColor("#1A1A00")
                    .nightSurfaceColor("#333300")
                    .rarity(ThemeRarity.LEGENDARY)
                    .price(100)
                    .currency("gems")
                    .isDefault(false)
                    .build()
            );

            themeRepository.saveAll(themes);
        };
    }

    private ThemeDto toDto(AppTheme theme, boolean owned, boolean active) {
        return ThemeDto.builder()
                .id(theme.getId())
                .themeKey(theme.getThemeKey())
                .name(theme.getName())
                .description(theme.getDescription())
                .dayPrimaryColor(theme.getDayPrimaryColor())
                .daySecondaryColor(theme.getDaySecondaryColor())
                .dayBackgroundColor(theme.getDayBackgroundColor())
                .daySurfaceColor(theme.getDaySurfaceColor())
                .nightPrimaryColor(theme.getNightPrimaryColor())
                .nightSecondaryColor(theme.getNightSecondaryColor())
                .nightBackgroundColor(theme.getNightBackgroundColor())
                .nightSurfaceColor(theme.getNightSurfaceColor())
                .rarity(theme.getRarity())
                .price(theme.getPrice())
                .currency(theme.getCurrency())
                .isDefault(theme.getIsDefault())
                .owned(owned)
                .active(active)
                .build();
    }

    public List<ThemeDto> getAllThemes(AppUser user) {
        List<AppTheme> themes = themeRepository.findAllByOrderByPriceAsc();
        List<UserTheme> ownedThemes = userThemeRepository.findByUserId(user.getId());
        List<Long> ownedThemeIds = ownedThemes.stream().map(ut -> ut.getTheme().getId()).toList();

        return themes.stream().map(theme -> toDto(
                theme,
                theme.getIsDefault() || ownedThemeIds.contains(theme.getId()),
                theme.getThemeKey().equals(user.getSelectedThemeId())
        )).toList();
    }

    @Transactional
    public ThemeDto buyTheme(AppUser user, Long themeId) {
        AppTheme theme = themeRepository.findById(themeId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Theme introuvable"));

        if (theme.getIsDefault()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ce theme est gratuit");
        }

        if (userThemeRepository.existsByUserIdAndThemeId(user.getId(), themeId)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Vous possedez deja ce theme");
        }

        // Check and deduct currency
        if ("gems".equals(theme.getCurrency())) {
            if (user.getGems() < theme.getPrice()) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Pas assez de gemmes");
            }
            user.setGems(user.getGems() - theme.getPrice());
        } else {
            if (user.getCoins() < theme.getPrice()) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Pas assez de pieces");
            }
            user.setCoins(user.getCoins() - theme.getPrice());
        }

        userRepository.save(user);

        UserTheme userTheme = UserTheme.builder()
                .user(user)
                .theme(theme)
                .build();
        userThemeRepository.save(userTheme);

        return toDto(theme, true, false);
    }

    @Transactional
    public ThemeDto applyTheme(AppUser user, Long themeId) {
        AppTheme theme = themeRepository.findById(themeId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Theme introuvable"));

        // Check ownership (default themes are always available)
        if (!theme.getIsDefault() && !userThemeRepository.existsByUserIdAndThemeId(user.getId(), themeId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Vous ne possedez pas ce theme");
        }

        user.setSelectedThemeId(theme.getThemeKey());
        userRepository.save(user);

        return toDto(theme, true, true);
    }
}
