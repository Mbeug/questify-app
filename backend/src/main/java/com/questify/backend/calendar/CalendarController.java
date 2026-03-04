package com.questify.backend.calendar;

import com.questify.backend.quest.Quest;
import com.questify.backend.quest.QuestDto;
import com.questify.backend.quest.QuestRepository;
import com.questify.backend.user.AppUser;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

/**
 * Endpoints for Google Calendar synchronization.
 * <p>
 * The actual Calendar API calls happen on the mobile client (Flutter)
 * using the user's Google OAuth access token. The backend only stores
 * the Calendar event ID so that we can link quests to calendar events
 * for future operations (update / delete sync).
 */
@RestController
@RequestMapping("/api/calendar")
@RequiredArgsConstructor
public class CalendarController {

    private final QuestRepository questRepository;

    /**
     * Link a Google Calendar event to a quest.
     * Called by the mobile client after it creates a calendar event.
     */
    @PostMapping("/link/{questId}")
    public QuestDto linkCalendarEvent(
            @AuthenticationPrincipal AppUser user,
            @PathVariable Long questId,
            @Valid @RequestBody CalendarLinkRequest request) {

        Quest quest = questRepository.findById(questId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Quete introuvable"));

        if (!quest.getUser().getId().equals(user.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Acces refuse");
        }

        quest.setCalendarEventId(request.getCalendarEventId());
        quest = questRepository.save(quest);
        return QuestDto.from(quest);
    }

    /**
     * Unlink a Google Calendar event from a quest.
     * Called by the mobile client after it deletes the calendar event.
     */
    @DeleteMapping("/link/{questId}")
    public QuestDto unlinkCalendarEvent(
            @AuthenticationPrincipal AppUser user,
            @PathVariable Long questId) {

        Quest quest = questRepository.findById(questId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Quete introuvable"));

        if (!quest.getUser().getId().equals(user.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Acces refuse");
        }

        quest.setCalendarEventId(null);
        quest = questRepository.save(quest);
        return QuestDto.from(quest);
    }
}
