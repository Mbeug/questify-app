package com.questify.backend.achievement;

import com.questify.backend.user.AppUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/achievements")
@RequiredArgsConstructor
public class AchievementController {

    private final AchievementService achievementService;

    @GetMapping
    public List<AchievementDto> getAchievements(@AuthenticationPrincipal AppUser user) {
        return achievementService.getUserAchievements(user);
    }
}
