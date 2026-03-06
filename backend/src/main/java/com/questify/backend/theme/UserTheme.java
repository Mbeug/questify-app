package com.questify.backend.theme;

import com.questify.backend.user.AppUser;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_themes", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"user_id", "theme_id"})
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class UserTheme {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private AppUser user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "theme_id", nullable = false)
    private AppTheme theme;

    @Builder.Default
    @Column(nullable = false, updatable = false)
    private LocalDateTime purchasedAt = LocalDateTime.now();
}
