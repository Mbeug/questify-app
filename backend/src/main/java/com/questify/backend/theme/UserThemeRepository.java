package com.questify.backend.theme;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface UserThemeRepository extends JpaRepository<UserTheme, Long> {
    List<UserTheme> findByUserId(Long userId);
    boolean existsByUserIdAndThemeId(Long userId, Long themeId);
    Optional<UserTheme> findByUserIdAndThemeId(Long userId, Long themeId);
}
