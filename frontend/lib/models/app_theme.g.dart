// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppThemeModel _$AppThemeModelFromJson(Map<String, dynamic> json) =>
    _AppThemeModel(
      id: (json['id'] as num).toInt(),
      themeKey: json['themeKey'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      dayPrimaryColor: json['dayPrimaryColor'] as String,
      daySecondaryColor: json['daySecondaryColor'] as String,
      dayBackgroundColor: json['dayBackgroundColor'] as String,
      daySurfaceColor: json['daySurfaceColor'] as String,
      nightPrimaryColor: json['nightPrimaryColor'] as String,
      nightSecondaryColor: json['nightSecondaryColor'] as String,
      nightBackgroundColor: json['nightBackgroundColor'] as String,
      nightSurfaceColor: json['nightSurfaceColor'] as String,
      rarity: $enumDecode(_$ThemeRarityEnumMap, json['rarity']),
      price: (json['price'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      owned: json['owned'] as bool? ?? false,
      active: json['active'] as bool? ?? false,
    );

Map<String, dynamic> _$AppThemeModelToJson(_AppThemeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'themeKey': instance.themeKey,
      'name': instance.name,
      'description': instance.description,
      'dayPrimaryColor': instance.dayPrimaryColor,
      'daySecondaryColor': instance.daySecondaryColor,
      'dayBackgroundColor': instance.dayBackgroundColor,
      'daySurfaceColor': instance.daySurfaceColor,
      'nightPrimaryColor': instance.nightPrimaryColor,
      'nightSecondaryColor': instance.nightSecondaryColor,
      'nightBackgroundColor': instance.nightBackgroundColor,
      'nightSurfaceColor': instance.nightSurfaceColor,
      'rarity': _$ThemeRarityEnumMap[instance.rarity]!,
      'price': instance.price,
      'currency': instance.currency,
      'isDefault': instance.isDefault,
      'owned': instance.owned,
      'active': instance.active,
    };

const _$ThemeRarityEnumMap = {
  ThemeRarity.COMMON: 'COMMON',
  ThemeRarity.UNCOMMON: 'UNCOMMON',
  ThemeRarity.RARE: 'RARE',
  ThemeRarity.EPIC: 'EPIC',
  ThemeRarity.LEGENDARY: 'LEGENDARY',
};
