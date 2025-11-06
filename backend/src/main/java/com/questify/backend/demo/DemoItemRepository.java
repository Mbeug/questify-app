package com.questify.backend.demo;
import org.springframework.data.jpa.repository.JpaRepository;
public interface DemoItemRepository extends JpaRepository<DemoItem, Long> {}
