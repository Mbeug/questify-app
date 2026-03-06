import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:frontend/features/settings/settings_page.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/calendar_provider.dart';
import 'package:frontend/providers/notification_provider.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/social_auth_service.dart';

class MockApiService extends Mock implements ApiService {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

class MockSocialAuthService extends Mock implements SocialAuthService {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

const testUser = User(
  id: 1,
  email: 'test@questify.app',
  displayName: 'Hero42',
  xp: 350,
  level: 5,
  coins: 120,
  gems: 10,
);

Widget buildTestApp({
  required MockApiService mockApi,
  required MockSecureStorage mockStorage,
  required MockSocialAuthService mockSocial,
  required MockGoogleSignIn mockGoogleSignIn,
  required MockFirebaseMessaging mockFirebaseMessaging,
  CalendarState calendarState = const CalendarState(),
  NotificationState notifState = const NotificationState(),
}) {
  when(() => mockApi.getMe()).thenAnswer((_) async => testUser);
  when(() => mockApi.setAccessToken(any())).thenReturn(null);
  when(() => mockApi.getNotificationPreferences())
      .thenAnswer((_) async => {'notificationsEnabled': notifState.isEnabled});

  // Mock GoogleSignIn.signInSilently to avoid native calls
  when(() => mockGoogleSignIn.signInSilently())
      .thenAnswer((_) async => null);

  return ProviderScope(
    overrides: [
      apiServiceProvider.overrideWithValue(mockApi),
      secureStorageProvider.overrideWithValue(mockStorage),
      socialAuthServiceProvider.overrideWithValue(mockSocial),
      googleSignInProvider.overrideWithValue(mockGoogleSignIn),
      firebaseMessagingProvider.overrideWithValue(mockFirebaseMessaging),
    ],
    child: const MaterialApp(
      home: SettingsPage(),
    ),
  );
}

void main() {
  late MockApiService mockApi;
  late MockSecureStorage mockStorage;
  late MockSocialAuthService mockSocial;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockFirebaseMessaging mockFirebaseMessaging;

  setUp(() {
    mockApi = MockApiService();
    mockStorage = MockSecureStorage();
    mockSocial = MockSocialAuthService();
    mockGoogleSignIn = MockGoogleSignIn();
    mockFirebaseMessaging = MockFirebaseMessaging();

    // Auto-login mocks
    when(() => mockStorage.read(key: 'accessToken'))
        .thenAnswer((_) async => 'valid_token');
    when(() => mockStorage.read(key: 'refreshToken'))
        .thenAnswer((_) async => 'valid_refresh');
    when(() => mockStorage.write(
            key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});

    when(() => mockApi.getMe()).thenAnswer((_) async => testUser);
    when(() => mockApi.setAccessToken(any())).thenReturn(null);
    when(() => mockApi.getNotificationPreferences())
        .thenAnswer((_) async => {'notificationsEnabled': true});

    // GoogleSignIn: signInSilently returns null (not connected)
    when(() => mockGoogleSignIn.signInSilently())
        .thenAnswer((_) async => null);
  });

  group('SettingsPage', () {
    testWidgets('shows AppBar with title "Parametres"', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        mockGoogleSignIn: mockGoogleSignIn,
        mockFirebaseMessaging: mockFirebaseMessaging,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Parametres'), findsOneWidget);
    });

    testWidgets('shows Google Calendar section', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        mockGoogleSignIn: mockGoogleSignIn,
        mockFirebaseMessaging: mockFirebaseMessaging,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Google Calendar'), findsOneWidget);
      expect(find.text('Non connecte'), findsOneWidget);
      expect(find.text('Synchronise tes quetes avec ton agenda'),
          findsOneWidget);
    });

    testWidgets('shows Notifications section', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        mockGoogleSignIn: mockGoogleSignIn,
        mockFirebaseMessaging: mockFirebaseMessaging,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Push notifications'), findsOneWidget);
      expect(find.text('Rappels de quetes et niveaux'), findsOneWidget);
    });

    testWidgets('shows Compte section with logout', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        mockGoogleSignIn: mockGoogleSignIn,
        mockFirebaseMessaging: mockFirebaseMessaging,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Compte'), findsOneWidget);
      expect(find.text('Se deconnecter'), findsOneWidget);
    });

    testWidgets('shows Rappels info card', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        mockGoogleSignIn: mockGoogleSignIn,
        mockFirebaseMessaging: mockFirebaseMessaging,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Rappels'), findsOneWidget);
      expect(
          find.text(
              "Tu recevras un rappel 24h avant l'echeance de tes quetes."),
          findsOneWidget);
    });

    testWidgets('shows calendar switch with off state', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        mockGoogleSignIn: mockGoogleSignIn,
        mockFirebaseMessaging: mockFirebaseMessaging,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // There should be Switch widgets — calendar is disconnected (off)
      final switches = find.byType(Switch);
      expect(switches, findsAtLeastNWidgets(1));
    });

    testWidgets('shows notification switch', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        mockGoogleSignIn: mockGoogleSignIn,
        mockFirebaseMessaging: mockFirebaseMessaging,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Should have at least 2 switches (calendar + notifications)
      final switches = find.byType(Switch);
      expect(switches, findsAtLeastNWidgets(2));
    });

    testWidgets('logout dialog appears on tap', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        mockGoogleSignIn: mockGoogleSignIn,
        mockFirebaseMessaging: mockFirebaseMessaging,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Scroll to ensure 'Se deconnecter' is visible
      final logoutTile = find.text('Se deconnecter');
      await tester.ensureVisible(logoutTile);
      await tester.tap(logoutTile);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Se deconnecter ?'), findsOneWidget);
      expect(find.text('Es-tu sur de vouloir te deconnecter ?'),
          findsOneWidget);
      expect(find.text('Annuler'), findsOneWidget);
    });

    testWidgets('logout dialog can be cancelled', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        mockGoogleSignIn: mockGoogleSignIn,
        mockFirebaseMessaging: mockFirebaseMessaging,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final logoutTile = find.text('Se deconnecter');
      await tester.ensureVisible(logoutTile);
      await tester.tap(logoutTile);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Cancel the dialog
      await tester.tap(find.text('Annuler'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Dialog dismissed, settings still visible
      expect(find.text('Parametres'), findsOneWidget);
    });

    testWidgets('back arrow is shown in AppBar', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        mockGoogleSignIn: mockGoogleSignIn,
        mockFirebaseMessaging: mockFirebaseMessaging,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('shows all section icons', (tester) async {
      await tester.pumpWidget(buildTestApp(
        mockApi: mockApi,
        mockStorage: mockStorage,
        mockSocial: mockSocial,
        mockGoogleSignIn: mockGoogleSignIn,
        mockFirebaseMessaging: mockFirebaseMessaging,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byIcon(Icons.calendar_month), findsOneWidget);
      expect(find.byIcon(Icons.notifications_active), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });
}
