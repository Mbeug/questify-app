package com.questify.backend.theme;

import com.questify.backend.user.AppUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/themes")
@RequiredArgsConstructor
public class ThemeController {

    private final ThemeService themeService;

    @GetMapping
    public List<ThemeDto> getAllThemes(@AuthenticationPrincipal AppUser user) {
        return themeService.getAllThemes(user);
    }

    @PostMapping("/{id}/buy")
    public ThemeDto buyTheme(@AuthenticationPrincipal AppUser user, @PathVariable Long id) {
        return themeService.buyTheme(user, id);
    }

    @PostMapping("/{id}/apply")
    public ThemeDto applyTheme(@AuthenticationPrincipal AppUser user, @PathVariable Long id) {
        return themeService.applyTheme(user, id);
    }
}
