package com.questify.backend.group;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data @Builder @AllArgsConstructor
public class GroupDto {
    private Long id;
    private String name;
    private String description;
    private String bannerEmoji;
    private String inviteCode;
    private Integer weeklyGoal;
    private Integer weeklyProgress;
    private Integer memberCount;
    private LocalDateTime createdAt;
    private List<GroupMemberDto> members;
}
