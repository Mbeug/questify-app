package com.questify.backend.group;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface GroupRepository extends JpaRepository<QuestGroup, Long> {
    Optional<QuestGroup> findByInviteCode(String inviteCode);
}
