package com.questify.backend.notification;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class NotificationService {

    private final FirebaseMessagingProvider firebaseProvider;

    /**
     * Send a push notification to a specific device.
     *
     * @param fcmToken  the device FCM registration token
     * @param title     notification title
     * @param body      notification body
     * @param data      optional key-value data payload (can be null)
     */
    public void sendNotification(String fcmToken, String title, String body,
                                  java.util.Map<String, String> data) {
        if (!firebaseProvider.isEnabled()) {
            log.debug("Firebase disabled — skipping notification to {}", fcmToken);
            return;
        }

        try {
            Message.Builder builder = Message.builder()
                    .setToken(fcmToken)
                    .setNotification(Notification.builder()
                            .setTitle(title)
                            .setBody(body)
                            .build());

            if (data != null && !data.isEmpty()) {
                builder.putAllData(data);
            }

            String messageId = FirebaseMessaging.getInstance().send(builder.build());
            log.info("Notification envoyee: {} -> {}", messageId, fcmToken.substring(0, 10));
        } catch (Exception e) {
            log.error("Erreur envoi notification FCM: {}", e.getMessage(), e);
        }
    }

    /**
     * Send a quest reminder notification.
     */
    public void sendQuestReminder(String fcmToken, String questTitle, Long questId) {
        sendNotification(
                fcmToken,
                "Rappel de quete",
                "Ta quete \"" + questTitle + "\" arrive bientot a echeance !",
                java.util.Map.of(
                        "type", "QUEST_REMINDER",
                        "questId", String.valueOf(questId)
                )
        );
    }

    /**
     * Send a level-up congratulation notification.
     */
    public void sendLevelUpNotification(String fcmToken, int newLevel, int xpGained) {
        sendNotification(
                fcmToken,
                "Niveau " + newLevel + " atteint !",
                "Felicitations ! Tu as gagne " + xpGained + " XP et atteint le niveau " + newLevel + ".",
                java.util.Map.of(
                        "type", "LEVEL_UP",
                        "level", String.valueOf(newLevel)
                )
        );
    }
}
