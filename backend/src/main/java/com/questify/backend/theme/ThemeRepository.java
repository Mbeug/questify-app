package com.questify.backend.theme;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface ThemeRepository extends JpaRepository<AppTheme, Long> {
    Optional<AppTheme> findByThemeKey(String themeKey);
    List<AppTheme> findAllByOrderByPriceAsc();
}
