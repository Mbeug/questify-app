import 'package:test/test.dart';
import 'package:frontend/models/app_theme.dart';

void main() {
  group('AppThemeModel', () {
    test('fromJson creates a valid AppThemeModel with all fields', () {
      final json = {
        'id': 1,
        'themeKey': 'ocean_blue',
        'name': 'Ocean Bleu',
        'description': 'Un thème inspiré de l\'océan',
        'primaryColor': '#0077BE',
        'secondaryColor': '#00A6ED',
        'backgroundColor': '#E0F7FA',
        'surfaceColor': '#FFFFFF',
        'rarity': 'RARE',
        'price': 500,
        'currency': 'coins',
        'isDefault': false,
        'owned': true,
        'active': true,
      };

      final theme = AppThemeModel.fromJson(json);

      expect(theme.id, 1);
      expect(theme.themeKey, 'ocean_blue');
      expect(theme.name, 'Ocean Bleu');
      expect(theme.description, 'Un thème inspiré de l\'océan');
      expect(theme.primaryColor, '#0077BE');
      expect(theme.secondaryColor, '#00A6ED');
      expect(theme.backgroundColor, '#E0F7FA');
      expect(theme.surfaceColor, '#FFFFFF');
      expect(theme.rarity, ThemeRarity.RARE);
      expect(theme.price, 500);
      expect(theme.currency, 'coins');
      expect(theme.isDefault, false);
      expect(theme.owned, true);
      expect(theme.active, true);
    });

    test('fromJson with minimal fields uses defaults', () {
      final json = {
        'id': 2,
        'themeKey': 'default',
        'name': 'Défaut',
        'primaryColor': '#6200EE',
        'secondaryColor': '#03DAC5',
        'backgroundColor': '#FAFAFA',
        'surfaceColor': '#FFFFFF',
        'rarity': 'COMMON',
      };

      final theme = AppThemeModel.fromJson(json);

      expect(theme.id, 2);
      expect(theme.description, isNull);
      expect(theme.price, 0);
      expect(theme.currency, isNull);
      expect(theme.isDefault, false);
      expect(theme.owned, false);
      expect(theme.active, false);
    });

    test('toJson produces correct map', () {
      const theme = AppThemeModel(
        id: 1,
        themeKey: 'fire',
        name: 'Feu',
        primaryColor: '#FF5722',
        secondaryColor: '#FF9800',
        backgroundColor: '#FFF3E0',
        surfaceColor: '#FFFFFF',
        rarity: ThemeRarity.EPIC,
        price: 1000,
        owned: true,
      );

      final json = theme.toJson();

      expect(json['id'], 1);
      expect(json['themeKey'], 'fire');
      expect(json['rarity'], 'EPIC');
      expect(json['price'], 1000);
      expect(json['owned'], true);
      expect(json['active'], false);
    });

    test('all ThemeRarity values deserialize correctly', () {
      for (final rarity in ThemeRarity.values) {
        final json = {
          'id': 1,
          'themeKey': 'test',
          'name': 'Test',
          'primaryColor': '#000',
          'secondaryColor': '#000',
          'backgroundColor': '#000',
          'surfaceColor': '#000',
          'rarity': rarity.name,
        };
        final theme = AppThemeModel.fromJson(json);
        expect(theme.rarity, rarity);
      }
    });

    test('toJson/fromJson roundtrip is consistent', () {
      const original = AppThemeModel(
        id: 3,
        themeKey: 'forest',
        name: 'Forêt',
        description: 'Thème vert',
        primaryColor: '#2E7D32',
        secondaryColor: '#66BB6A',
        backgroundColor: '#E8F5E9',
        surfaceColor: '#FFFFFF',
        rarity: ThemeRarity.UNCOMMON,
        price: 200,
        currency: 'coins',
        isDefault: false,
        owned: true,
        active: false,
      );

      final json = original.toJson();
      final restored = AppThemeModel.fromJson(json);

      expect(restored, equals(original));
    });

    test('equality works via freezed', () {
      const a = AppThemeModel(
        id: 1,
        themeKey: 'k',
        name: 'N',
        primaryColor: '#000',
        secondaryColor: '#000',
        backgroundColor: '#000',
        surfaceColor: '#000',
        rarity: ThemeRarity.COMMON,
      );
      const b = AppThemeModel(
        id: 1,
        themeKey: 'k',
        name: 'N',
        primaryColor: '#000',
        secondaryColor: '#000',
        backgroundColor: '#000',
        surfaceColor: '#000',
        rarity: ThemeRarity.COMMON,
      );

      expect(a, equals(b));
    });
  });
}
