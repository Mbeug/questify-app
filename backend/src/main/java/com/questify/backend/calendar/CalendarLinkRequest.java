package com.questify.backend.calendar;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CalendarLinkRequest {
    @NotBlank(message = "Calendar event ID requis")
    private String calendarEventId;
}
