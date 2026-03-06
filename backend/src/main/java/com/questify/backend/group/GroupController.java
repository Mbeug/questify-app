package com.questify.backend.group;

import com.questify.backend.user.AppUser;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/groups")
@RequiredArgsConstructor
public class GroupController {

    private final GroupService groupService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public GroupDto createGroup(@AuthenticationPrincipal AppUser user,
                                @Valid @RequestBody CreateGroupRequest request) {
        return groupService.createGroup(user, request);
    }

    @PostMapping("/join")
    public GroupDto joinGroup(@AuthenticationPrincipal AppUser user,
                              @Valid @RequestBody JoinGroupRequest request) {
        return groupService.joinGroup(user, request.getInviteCode());
    }

    @GetMapping
    public List<GroupDto> getMyGroups(@AuthenticationPrincipal AppUser user) {
        return groupService.getUserGroups(user);
    }

    @GetMapping("/{id}")
    public GroupDto getGroup(@AuthenticationPrincipal AppUser user, @PathVariable Long id) {
        return groupService.getGroup(user, id);
    }

    @PostMapping("/{id}/leave")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void leaveGroup(@AuthenticationPrincipal AppUser user, @PathVariable Long id) {
        groupService.leaveGroup(user, id);
    }

    @DeleteMapping("/{id}/members/{userId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void removeMember(@AuthenticationPrincipal AppUser user,
                             @PathVariable Long id,
                             @PathVariable Long userId) {
        groupService.removeMember(user, id, userId);
    }
}
