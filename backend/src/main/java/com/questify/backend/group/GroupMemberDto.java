package com.questify.backend.group;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

@Data @Builder @AllArgsConstructor
public class GroupMemberDto {
    private Long userId;
    private String displayName;
    private String avatarId;
    private Integer level;
    private Long weeklyXp;
    private Integer weeklyQuestsCompleted;
    private GroupRole role;
    private LocalDateTime joinedAt;
}
