package com.questify.backend.demo;
import jakarta.persistence.*;
import lombok.*;

@Entity @Table(name = "demo_items")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class DemoItem {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  @Column(nullable = false, length = 100)
  private String name;
}
