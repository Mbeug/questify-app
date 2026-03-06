// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppThemeModel {
  int get id;
  String get themeKey;
  String get name;
  String? get description; // Day variant colours
  String get dayPrimaryColor;
  String get daySecondaryColor;
  String get dayBackgroundColor;
  String get daySurfaceColor; // Night variant colours
  String get nightPrimaryColor;
  String get nightSecondaryColor;
  String get nightBackgroundColor;
  String get nightSurfaceColor;
  ThemeRarity get rarity;
  int get price;
  String? get currency;
  bool get isDefault;
  bool get owned;
  bool get active;

  /// Create a copy of AppThemeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppThemeModelCopyWith<AppThemeModel> get copyWith =>
      _$AppThemeModelCopyWithImpl<AppThemeModel>(
          this as AppThemeModel, _$identity);

  /// Serializes this AppThemeModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppThemeModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.themeKey, themeKey) ||
                other.themeKey == themeKey) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dayPrimaryColor, dayPrimaryColor) ||
                other.dayPrimaryColor == dayPrimaryColor) &&
            (identical(other.daySecondaryColor, daySecondaryColor) ||
                other.daySecondaryColor == daySecondaryColor) &&
            (identical(other.dayBackgroundColor, dayBackgroundColor) ||
                other.dayBackgroundColor == dayBackgroundColor) &&
            (identical(other.daySurfaceColor, daySurfaceColor) ||
                other.daySurfaceColor == daySurfaceColor) &&
            (identical(other.nightPrimaryColor, nightPrimaryColor) ||
                other.nightPrimaryColor == nightPrimaryColor) &&
            (identical(other.nightSecondaryColor, nightSecondaryColor) ||
                other.nightSecondaryColor == nightSecondaryColor) &&
            (identical(other.nightBackgroundColor, nightBackgroundColor) ||
                other.nightBackgroundColor == nightBackgroundColor) &&
            (identical(other.nightSurfaceColor, nightSurfaceColor) ||
                other.nightSurfaceColor == nightSurfaceColor) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.owned, owned) || other.owned == owned) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      themeKey,
      name,
      description,
      dayPrimaryColor,
      daySecondaryColor,
      dayBackgroundColor,
      daySurfaceColor,
      nightPrimaryColor,
      nightSecondaryColor,
      nightBackgroundColor,
      nightSurfaceColor,
      rarity,
      price,
      currency,
      isDefault,
      owned,
      active);

  @override
  String toString() {
    return 'AppThemeModel(id: $id, themeKey: $themeKey, name: $name, description: $description, dayPrimaryColor: $dayPrimaryColor, daySecondaryColor: $daySecondaryColor, dayBackgroundColor: $dayBackgroundColor, daySurfaceColor: $daySurfaceColor, nightPrimaryColor: $nightPrimaryColor, nightSecondaryColor: $nightSecondaryColor, nightBackgroundColor: $nightBackgroundColor, nightSurfaceColor: $nightSurfaceColor, rarity: $rarity, price: $price, currency: $currency, isDefault: $isDefault, owned: $owned, active: $active)';
  }
}

/// @nodoc
abstract mixin class $AppThemeModelCopyWith<$Res> {
  factory $AppThemeModelCopyWith(
          AppThemeModel value, $Res Function(AppThemeModel) _then) =
      _$AppThemeModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String themeKey,
      String name,
      String? description,
      String dayPrimaryColor,
      String daySecondaryColor,
      String dayBackgroundColor,
      String daySurfaceColor,
      String nightPrimaryColor,
      String nightSecondaryColor,
      String nightBackgroundColor,
      String nightSurfaceColor,
      ThemeRarity rarity,
      int price,
      String? currency,
      bool isDefault,
      bool owned,
      bool active});
}

/// @nodoc
class _$AppThemeModelCopyWithImpl<$Res>
    implements $AppThemeModelCopyWith<$Res> {
  _$AppThemeModelCopyWithImpl(this._self, this._then);

  final AppThemeModel _self;
  final $Res Function(AppThemeModel) _then;

  /// Create a copy of AppThemeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? themeKey = null,
    Object? name = null,
    Object? description = freezed,
    Object? dayPrimaryColor = null,
    Object? daySecondaryColor = null,
    Object? dayBackgroundColor = null,
    Object? daySurfaceColor = null,
    Object? nightPrimaryColor = null,
    Object? nightSecondaryColor = null,
    Object? nightBackgroundColor = null,
    Object? nightSurfaceColor = null,
    Object? rarity = null,
    Object? price = null,
    Object? currency = freezed,
    Object? isDefault = null,
    Object? owned = null,
    Object? active = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      themeKey: null == themeKey
          ? _self.themeKey
          : themeKey // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      dayPrimaryColor: null == dayPrimaryColor
          ? _self.dayPrimaryColor
          : dayPrimaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      daySecondaryColor: null == daySecondaryColor
          ? _self.daySecondaryColor
          : daySecondaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      dayBackgroundColor: null == dayBackgroundColor
          ? _self.dayBackgroundColor
          : dayBackgroundColor // ignore: cast_nullable_to_non_nullable
              as String,
      daySurfaceColor: null == daySurfaceColor
          ? _self.daySurfaceColor
          : daySurfaceColor // ignore: cast_nullable_to_non_nullable
              as String,
      nightPrimaryColor: null == nightPrimaryColor
          ? _self.nightPrimaryColor
          : nightPrimaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      nightSecondaryColor: null == nightSecondaryColor
          ? _self.nightSecondaryColor
          : nightSecondaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      nightBackgroundColor: null == nightBackgroundColor
          ? _self.nightBackgroundColor
          : nightBackgroundColor // ignore: cast_nullable_to_non_nullable
              as String,
      nightSurfaceColor: null == nightSurfaceColor
          ? _self.nightSurfaceColor
          : nightSurfaceColor // ignore: cast_nullable_to_non_nullable
              as String,
      rarity: null == rarity
          ? _self.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as ThemeRarity,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      currency: freezed == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _self.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      owned: null == owned
          ? _self.owned
          : owned // ignore: cast_nullable_to_non_nullable
              as bool,
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [AppThemeModel].
extension AppThemeModelPatterns on AppThemeModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AppThemeModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppThemeModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AppThemeModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppThemeModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AppThemeModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppThemeModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int id,
            String themeKey,
            String name,
            String? description,
            String dayPrimaryColor,
            String daySecondaryColor,
            String dayBackgroundColor,
            String daySurfaceColor,
            String nightPrimaryColor,
            String nightSecondaryColor,
            String nightBackgroundColor,
            String nightSurfaceColor,
            ThemeRarity rarity,
            int price,
            String? currency,
            bool isDefault,
            bool owned,
            bool active)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppThemeModel() when $default != null:
        return $default(
            _that.id,
            _that.themeKey,
            _that.name,
            _that.description,
            _that.dayPrimaryColor,
            _that.daySecondaryColor,
            _that.dayBackgroundColor,
            _that.daySurfaceColor,
            _that.nightPrimaryColor,
            _that.nightSecondaryColor,
            _that.nightBackgroundColor,
            _that.nightSurfaceColor,
            _that.rarity,
            _that.price,
            _that.currency,
            _that.isDefault,
            _that.owned,
            _that.active);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int id,
            String themeKey,
            String name,
            String? description,
            String dayPrimaryColor,
            String daySecondaryColor,
            String dayBackgroundColor,
            String daySurfaceColor,
            String nightPrimaryColor,
            String nightSecondaryColor,
            String nightBackgroundColor,
            String nightSurfaceColor,
            ThemeRarity rarity,
            int price,
            String? currency,
            bool isDefault,
            bool owned,
            bool active)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppThemeModel():
        return $default(
            _that.id,
            _that.themeKey,
            _that.name,
            _that.description,
            _that.dayPrimaryColor,
            _that.daySecondaryColor,
            _that.dayBackgroundColor,
            _that.daySurfaceColor,
            _that.nightPrimaryColor,
            _that.nightSecondaryColor,
            _that.nightBackgroundColor,
            _that.nightSurfaceColor,
            _that.rarity,
            _that.price,
            _that.currency,
            _that.isDefault,
            _that.owned,
            _that.active);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int id,
            String themeKey,
            String name,
            String? description,
            String dayPrimaryColor,
            String daySecondaryColor,
            String dayBackgroundColor,
            String daySurfaceColor,
            String nightPrimaryColor,
            String nightSecondaryColor,
            String nightBackgroundColor,
            String nightSurfaceColor,
            ThemeRarity rarity,
            int price,
            String? currency,
            bool isDefault,
            bool owned,
            bool active)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppThemeModel() when $default != null:
        return $default(
            _that.id,
            _that.themeKey,
            _that.name,
            _that.description,
            _that.dayPrimaryColor,
            _that.daySecondaryColor,
            _that.dayBackgroundColor,
            _that.daySurfaceColor,
            _that.nightPrimaryColor,
            _that.nightSecondaryColor,
            _that.nightBackgroundColor,
            _that.nightSurfaceColor,
            _that.rarity,
            _that.price,
            _that.currency,
            _that.isDefault,
            _that.owned,
            _that.active);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AppThemeModel implements AppThemeModel {
  const _AppThemeModel(
      {required this.id,
      required this.themeKey,
      required this.name,
      this.description,
      required this.dayPrimaryColor,
      required this.daySecondaryColor,
      required this.dayBackgroundColor,
      required this.daySurfaceColor,
      required this.nightPrimaryColor,
      required this.nightSecondaryColor,
      required this.nightBackgroundColor,
      required this.nightSurfaceColor,
      required this.rarity,
      this.price = 0,
      this.currency,
      this.isDefault = false,
      this.owned = false,
      this.active = false});
  factory _AppThemeModel.fromJson(Map<String, dynamic> json) =>
      _$AppThemeModelFromJson(json);

  @override
  final int id;
  @override
  final String themeKey;
  @override
  final String name;
  @override
  final String? description;
// Day variant colours
  @override
  final String dayPrimaryColor;
  @override
  final String daySecondaryColor;
  @override
  final String dayBackgroundColor;
  @override
  final String daySurfaceColor;
// Night variant colours
  @override
  final String nightPrimaryColor;
  @override
  final String nightSecondaryColor;
  @override
  final String nightBackgroundColor;
  @override
  final String nightSurfaceColor;
  @override
  final ThemeRarity rarity;
  @override
  @JsonKey()
  final int price;
  @override
  final String? currency;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  @JsonKey()
  final bool owned;
  @override
  @JsonKey()
  final bool active;

  /// Create a copy of AppThemeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AppThemeModelCopyWith<_AppThemeModel> get copyWith =>
      __$AppThemeModelCopyWithImpl<_AppThemeModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AppThemeModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppThemeModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.themeKey, themeKey) ||
                other.themeKey == themeKey) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dayPrimaryColor, dayPrimaryColor) ||
                other.dayPrimaryColor == dayPrimaryColor) &&
            (identical(other.daySecondaryColor, daySecondaryColor) ||
                other.daySecondaryColor == daySecondaryColor) &&
            (identical(other.dayBackgroundColor, dayBackgroundColor) ||
                other.dayBackgroundColor == dayBackgroundColor) &&
            (identical(other.daySurfaceColor, daySurfaceColor) ||
                other.daySurfaceColor == daySurfaceColor) &&
            (identical(other.nightPrimaryColor, nightPrimaryColor) ||
                other.nightPrimaryColor == nightPrimaryColor) &&
            (identical(other.nightSecondaryColor, nightSecondaryColor) ||
                other.nightSecondaryColor == nightSecondaryColor) &&
            (identical(other.nightBackgroundColor, nightBackgroundColor) ||
                other.nightBackgroundColor == nightBackgroundColor) &&
            (identical(other.nightSurfaceColor, nightSurfaceColor) ||
                other.nightSurfaceColor == nightSurfaceColor) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.owned, owned) || other.owned == owned) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      themeKey,
      name,
      description,
      dayPrimaryColor,
      daySecondaryColor,
      dayBackgroundColor,
      daySurfaceColor,
      nightPrimaryColor,
      nightSecondaryColor,
      nightBackgroundColor,
      nightSurfaceColor,
      rarity,
      price,
      currency,
      isDefault,
      owned,
      active);

  @override
  String toString() {
    return 'AppThemeModel(id: $id, themeKey: $themeKey, name: $name, description: $description, dayPrimaryColor: $dayPrimaryColor, daySecondaryColor: $daySecondaryColor, dayBackgroundColor: $dayBackgroundColor, daySurfaceColor: $daySurfaceColor, nightPrimaryColor: $nightPrimaryColor, nightSecondaryColor: $nightSecondaryColor, nightBackgroundColor: $nightBackgroundColor, nightSurfaceColor: $nightSurfaceColor, rarity: $rarity, price: $price, currency: $currency, isDefault: $isDefault, owned: $owned, active: $active)';
  }
}

/// @nodoc
abstract mixin class _$AppThemeModelCopyWith<$Res>
    implements $AppThemeModelCopyWith<$Res> {
  factory _$AppThemeModelCopyWith(
          _AppThemeModel value, $Res Function(_AppThemeModel) _then) =
      __$AppThemeModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String themeKey,
      String name,
      String? description,
      String dayPrimaryColor,
      String daySecondaryColor,
      String dayBackgroundColor,
      String daySurfaceColor,
      String nightPrimaryColor,
      String nightSecondaryColor,
      String nightBackgroundColor,
      String nightSurfaceColor,
      ThemeRarity rarity,
      int price,
      String? currency,
      bool isDefault,
      bool owned,
      bool active});
}

/// @nodoc
class __$AppThemeModelCopyWithImpl<$Res>
    implements _$AppThemeModelCopyWith<$Res> {
  __$AppThemeModelCopyWithImpl(this._self, this._then);

  final _AppThemeModel _self;
  final $Res Function(_AppThemeModel) _then;

  /// Create a copy of AppThemeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? themeKey = null,
    Object? name = null,
    Object? description = freezed,
    Object? dayPrimaryColor = null,
    Object? daySecondaryColor = null,
    Object? dayBackgroundColor = null,
    Object? daySurfaceColor = null,
    Object? nightPrimaryColor = null,
    Object? nightSecondaryColor = null,
    Object? nightBackgroundColor = null,
    Object? nightSurfaceColor = null,
    Object? rarity = null,
    Object? price = null,
    Object? currency = freezed,
    Object? isDefault = null,
    Object? owned = null,
    Object? active = null,
  }) {
    return _then(_AppThemeModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      themeKey: null == themeKey
          ? _self.themeKey
          : themeKey // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      dayPrimaryColor: null == dayPrimaryColor
          ? _self.dayPrimaryColor
          : dayPrimaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      daySecondaryColor: null == daySecondaryColor
          ? _self.daySecondaryColor
          : daySecondaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      dayBackgroundColor: null == dayBackgroundColor
          ? _self.dayBackgroundColor
          : dayBackgroundColor // ignore: cast_nullable_to_non_nullable
              as String,
      daySurfaceColor: null == daySurfaceColor
          ? _self.daySurfaceColor
          : daySurfaceColor // ignore: cast_nullable_to_non_nullable
              as String,
      nightPrimaryColor: null == nightPrimaryColor
          ? _self.nightPrimaryColor
          : nightPrimaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      nightSecondaryColor: null == nightSecondaryColor
          ? _self.nightSecondaryColor
          : nightSecondaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      nightBackgroundColor: null == nightBackgroundColor
          ? _self.nightBackgroundColor
          : nightBackgroundColor // ignore: cast_nullable_to_non_nullable
              as String,
      nightSurfaceColor: null == nightSurfaceColor
          ? _self.nightSurfaceColor
          : nightSurfaceColor // ignore: cast_nullable_to_non_nullable
              as String,
      rarity: null == rarity
          ? _self.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as ThemeRarity,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      currency: freezed == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _self.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      owned: null == owned
          ? _self.owned
          : owned // ignore: cast_nullable_to_non_nullable
              as bool,
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
