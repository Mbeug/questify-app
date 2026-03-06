package com.questify.backend.group;

import com.questify.backend.user.AppUser;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "group_members", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"group_id", "user_id"})
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class GroupMember {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_id", nullable = false)
    private QuestGroup group;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private AppUser user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private GroupRole role = GroupRole.MEMBER;

    // XP earned this week within the group
    @Builder.Default
    @Column(nullable = false)
    private Long weeklyXp = 0L;

    // Quests completed this week within the group
    @Builder.Default
    @Column(nullable = false)
    private Integer weeklyQuestsCompleted = 0;

    @Builder.Default
    @Column(nullable = false, updatable = false)
    private LocalDateTime joinedAt = LocalDateTime.now();

    @PrePersist
    void prePersist() {
        if (joinedAt == null) joinedAt = LocalDateTime.now();
        if (role == null) role = GroupRole.MEMBER;
        if (weeklyXp == null) weeklyXp = 0L;
        if (weeklyQuestsCompleted == null) weeklyQuestsCompleted = 0;
    }
}
