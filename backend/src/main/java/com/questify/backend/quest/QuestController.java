package com.questify.backend.quest;

import com.questify.backend.user.AppUser;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/quests")
@RequiredArgsConstructor
public class QuestController {

    private final QuestService questService;

    @GetMapping
    public List<QuestDto> getQuests(
            @AuthenticationPrincipal AppUser user,
            @RequestParam(required = false) QuestStatus status) {
        if (status != null) {
            return questService.getQuestsByStatus(user, status);
        }
        return questService.getQuests(user);
    }

    @GetMapping("/{id}")
    public QuestDto getQuest(@AuthenticationPrincipal AppUser user, @PathVariable Long id) {
        return questService.getQuest(user, id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public QuestDto createQuest(@AuthenticationPrincipal AppUser user,
                                @Valid @RequestBody CreateQuestRequest request) {
        return questService.createQuest(user, request);
    }

    @PutMapping("/{id}")
    public QuestDto updateQuest(@AuthenticationPrincipal AppUser user,
                                @PathVariable Long id,
                                @Valid @RequestBody UpdateQuestRequest request) {
        return questService.updateQuest(user, id, request);
    }

    @PostMapping("/{id}/complete")
    public QuestDto completeQuest(@AuthenticationPrincipal AppUser user, @PathVariable Long id) {
        return questService.completeQuest(user, id);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteQuest(@AuthenticationPrincipal AppUser user, @PathVariable Long id) {
        questService.deleteQuest(user, id);
    }
}
