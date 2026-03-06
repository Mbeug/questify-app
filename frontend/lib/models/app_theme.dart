import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_theme.freezed.dart';
part 'app_theme.g.dart';

enum ThemeRarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }

@freezed
abstract class AppThemeModel with _$AppThemeModel {
  const factory AppThemeModel({
    required int id,
    required String themeKey,
    required String name,
    String? description,
    // Day variant colours
    required String dayPrimaryColor,
    required String daySecondaryColor,
    required String dayBackgroundColor,
    required String daySurfaceColor,
    // Night variant colours
    required String nightPrimaryColor,
    required String nightSecondaryColor,
    required String nightBackgroundColor,
    required String nightSurfaceColor,
    required ThemeRarity rarity,
    @Default(0) int price,
    String? currency,
    @Default(false) bool isDefault,
    @Default(false) bool owned,
    @Default(false) bool active,
  }) = _AppThemeModel;

  factory AppThemeModel.fromJson(Map<String, dynamic> json) =>
      _$AppThemeModelFromJson(json);
}
