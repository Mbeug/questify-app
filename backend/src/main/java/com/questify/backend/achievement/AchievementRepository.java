package com.questify.backend.achievement;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface AchievementRepository extends JpaRepository<Achievement, Long> {
    Optional<Achievement> findByAchievementKey(String key);
    List<Achievement> findByCategory(AchievementCategory category);
}
