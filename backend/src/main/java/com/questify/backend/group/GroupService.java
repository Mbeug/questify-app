package com.questify.backend.group;

import com.questify.backend.user.AppUser;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.security.SecureRandom;
import java.util.List;

@Service
@RequiredArgsConstructor
public class GroupService {

    private final GroupRepository groupRepository;
    private final GroupMemberRepository groupMemberRepository;

    private static final String CODE_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    private static final SecureRandom RANDOM = new SecureRandom();

    private String generateInviteCode() {
        StringBuilder sb = new StringBuilder(8);
        for (int i = 0; i < 8; i++) {
            sb.append(CODE_CHARS.charAt(RANDOM.nextInt(CODE_CHARS.length())));
        }
        return sb.toString();
    }

    @Transactional
    public GroupDto createGroup(AppUser user, CreateGroupRequest request) {
        String code = generateInviteCode();
        // Ensure unique
        while (groupRepository.findByInviteCode(code).isPresent()) {
            code = generateInviteCode();
        }

        QuestGroup group = QuestGroup.builder()
                .name(request.getName())
                .description(request.getDescription())
                .bannerEmoji(request.getBannerEmoji())
                .inviteCode(code)
                .weeklyGoal(request.getWeeklyGoal() != null ? request.getWeeklyGoal() : 10)
                .build();

        group = groupRepository.save(group);

        // Creator is the leader
        GroupMember member = GroupMember.builder()
                .group(group)
                .user(user)
                .role(GroupRole.LEADER)
                .build();
        groupMemberRepository.save(member);

        return toDto(group);
    }

    @Transactional
    public GroupDto joinGroup(AppUser user, String inviteCode) {
        QuestGroup group = groupRepository.findByInviteCode(inviteCode.toUpperCase())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Code d'invitation invalide"));

        if (groupMemberRepository.existsByGroupIdAndUserId(group.getId(), user.getId())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Vous etes deja membre de ce groupe");
        }

        GroupMember member = GroupMember.builder()
                .group(group)
                .user(user)
                .role(GroupRole.MEMBER)
                .build();
        groupMemberRepository.save(member);

        return toDto(group);
    }

    public List<GroupDto> getUserGroups(AppUser user) {
        List<GroupMember> memberships = groupMemberRepository.findByUserId(user.getId());
        return memberships.stream()
                .map(m -> toDto(m.getGroup()))
                .toList();
    }

    public GroupDto getGroup(AppUser user, Long groupId) {
        QuestGroup group = groupRepository.findById(groupId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Groupe introuvable"));

        if (!groupMemberRepository.existsByGroupIdAndUserId(groupId, user.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Vous n'etes pas membre de ce groupe");
        }

        return toDto(group);
    }

    @Transactional
    public void leaveGroup(AppUser user, Long groupId) {
        GroupMember member = groupMemberRepository.findByGroupIdAndUserId(groupId, user.getId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Vous n'etes pas membre de ce groupe"));

        if (member.getRole() == GroupRole.LEADER) {
            long memberCount = groupMemberRepository.countByGroupId(groupId);
            if (memberCount <= 1) {
                // Last member, delete the group
                groupMemberRepository.delete(member);
                groupRepository.deleteById(groupId);
                return;
            }
            // Transfer leadership to the next member
            List<GroupMember> members = groupMemberRepository.findByGroupIdOrderByWeeklyXpDesc(groupId);
            for (GroupMember m : members) {
                if (!m.getUser().getId().equals(user.getId())) {
                    m.setRole(GroupRole.LEADER);
                    groupMemberRepository.save(m);
                    break;
                }
            }
        }
        groupMemberRepository.delete(member);
    }

    @Transactional
    public void removeMember(AppUser user, Long groupId, Long userId) {
        GroupMember leader = groupMemberRepository.findByGroupIdAndUserId(groupId, user.getId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.FORBIDDEN, "Acces refuse"));

        if (leader.getRole() != GroupRole.LEADER) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Seul le leader peut retirer des membres");
        }

        if (user.getId().equals(userId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Le leader ne peut pas se retirer lui-meme");
        }

        GroupMember memberToRemove = groupMemberRepository.findByGroupIdAndUserId(groupId, userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Membre introuvable"));

        groupMemberRepository.delete(memberToRemove);
    }

    /**
     * Called when a user completes a quest — updates their weekly stats in all groups.
     */
    @Transactional
    public void onQuestCompleted(AppUser user, int xpGained) {
        List<GroupMember> memberships = groupMemberRepository.findByUserId(user.getId());
        for (GroupMember member : memberships) {
            member.setWeeklyXp(member.getWeeklyXp() + xpGained);
            member.setWeeklyQuestsCompleted(member.getWeeklyQuestsCompleted() + 1);
            groupMemberRepository.save(member);

            // Update group weekly progress
            QuestGroup group = member.getGroup();
            group.setWeeklyProgress(group.getWeeklyProgress() + 1);
            groupRepository.save(group);
        }
    }

    private GroupDto toDto(QuestGroup group) {
        List<GroupMember> members = groupMemberRepository.findByGroupIdOrderByWeeklyXpDesc(group.getId());

        return GroupDto.builder()
                .id(group.getId())
                .name(group.getName())
                .description(group.getDescription())
                .bannerEmoji(group.getBannerEmoji())
                .inviteCode(group.getInviteCode())
                .weeklyGoal(group.getWeeklyGoal())
                .weeklyProgress(group.getWeeklyProgress())
                .memberCount(members.size())
                .createdAt(group.getCreatedAt())
                .members(members.stream().map(this::toMemberDto).toList())
                .build();
    }

    private GroupMemberDto toMemberDto(GroupMember member) {
        return GroupMemberDto.builder()
                .userId(member.getUser().getId())
                .displayName(member.getUser().getDisplayName())
                .avatarId(member.getUser().getAvatarId())
                .level(member.getUser().getLevel())
                .weeklyXp(member.getWeeklyXp())
                .weeklyQuestsCompleted(member.getWeeklyQuestsCompleted())
                .role(member.getRole())
                .joinedAt(member.getJoinedAt())
                .build();
    }
}
