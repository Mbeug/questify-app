package com.questify.backend.demo;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class DbSmokeRunner implements CommandLineRunner {
    private final DemoItemRepository repo;

    
    @Override 
    public void run(String... args) {
        repo.save(DemoItem.builder().name("ok").build());
        log.info("✅ DB OK — demo_items count = {}", repo.count());
    }
}
