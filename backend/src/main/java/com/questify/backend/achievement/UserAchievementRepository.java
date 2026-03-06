package com.questify.backend.achievement;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface UserAchievementRepository extends JpaRepository<UserAchievement, Long> {
    List<UserAchievement> findByUserId(Long userId);
    Optional<UserAchievement> findByUserIdAndAchievementId(Long userId, Long achievementId);
    List<UserAchievement> findByUserIdAndUnlockedTrue(Long userId);
    long countByUserIdAndUnlockedTrue(Long userId);
}
