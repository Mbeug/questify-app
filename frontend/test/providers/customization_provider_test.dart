import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/models/app_theme.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/providers/customization_provider.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApi;
  late CustomizationNotifier notifier;

  const theme1 = AppThemeModel(
    id: 1,
    themeKey: 'default',
    name: 'Défaut',
    primaryColor: '#6200EE',
    secondaryColor: '#03DAC5',
    backgroundColor: '#FAFAFA',
    surfaceColor: '#FFFFFF',
    rarity: ThemeRarity.COMMON,
    isDefault: true,
    owned: true,
    active: true,
  );

  const theme2 = AppThemeModel(
    id: 2,
    themeKey: 'ocean',
    name: 'Océan',
    primaryColor: '#0077BE',
    secondaryColor: '#00A6ED',
    backgroundColor: '#E0F7FA',
    surfaceColor: '#FFFFFF',
    rarity: ThemeRarity.RARE,
    price: 500,
    owned: false,
    active: false,
  );

  setUp(() {
    mockApi = MockApiService();
    notifier = CustomizationNotifier(mockApi);
  });

  group('CustomizationNotifier', () {
    test('initial state is empty and not loading', () {
      expect(notifier.state.themes, isEmpty);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.error, isNull);
    });

    test('loadThemes success populates themes', () async {
      when(() => mockApi.getThemes())
          .thenAnswer((_) async => [theme1, theme2]);

      await notifier.loadThemes();

      expect(notifier.state.themes.length, 2);
      expect(notifier.state.themes[0].themeKey, 'default');
      expect(notifier.state.themes[1].themeKey, 'ocean');
      expect(notifier.state.isLoading, false);
      expect(notifier.state.error, isNull);
    });

    test('loadThemes ApiException sets error', () async {
      when(() => mockApi.getThemes())
          .thenThrow(ApiException('Erreur serveur', statusCode: 500));

      await notifier.loadThemes();

      expect(notifier.state.themes, isEmpty);
      expect(notifier.state.error, 'Erreur serveur');
    });

    test('loadThemes generic exception sets default error', () async {
      when(() => mockApi.getThemes()).thenThrow(Exception('network'));

      await notifier.loadThemes();

      expect(notifier.state.error, 'Erreur de chargement');
    });

    test('buyTheme success reloads themes', () async {
      when(() => mockApi.buyTheme(2)).thenAnswer((_) async => theme2.copyWith(owned: true));
      // After buying, loadThemes is called
      when(() => mockApi.getThemes()).thenAnswer(
          (_) async => [theme1, theme2.copyWith(owned: true)]);

      final result = await notifier.buyTheme(2);

      expect(result, true);
      verify(() => mockApi.buyTheme(2)).called(1);
      verify(() => mockApi.getThemes()).called(1); // Reload was triggered
    });

    test('buyTheme ApiException returns false and sets error', () async {
      when(() => mockApi.buyTheme(2))
          .thenThrow(ApiException('Pas assez de pièces', statusCode: 400));

      final result = await notifier.buyTheme(2);

      expect(result, false);
      expect(notifier.state.error, 'Pas assez de pièces');
    });

    test('applyTheme success reloads themes', () async {
      when(() => mockApi.applyTheme(1)).thenAnswer((_) async => theme1);
      when(() => mockApi.getThemes())
          .thenAnswer((_) async => [theme1, theme2]);

      final result = await notifier.applyTheme(1);

      expect(result, true);
      verify(() => mockApi.applyTheme(1)).called(1);
      verify(() => mockApi.getThemes()).called(1);
    });

    test('applyTheme ApiException returns false and sets error', () async {
      when(() => mockApi.applyTheme(2))
          .thenThrow(ApiException('Thème non possédé', statusCode: 403));

      final result = await notifier.applyTheme(2);

      expect(result, false);
      expect(notifier.state.error, 'Thème non possédé');
    });
  });
}
