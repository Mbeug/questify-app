// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'achievement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Achievement {
  int get id;
  String get achievementKey;
  String get name;
  String? get description;
  String? get icon;
  AchievementCategory get category;
  int get threshold;
  int get coinReward;
  int get gemReward;
  int get progress;
  bool get unlocked;
  String? get unlockedAt;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AchievementCopyWith<Achievement> get copyWith =>
      _$AchievementCopyWithImpl<Achievement>(this as Achievement, _$identity);

  /// Serializes this Achievement to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Achievement &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.achievementKey, achievementKey) ||
                other.achievementKey == achievementKey) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold) &&
            (identical(other.coinReward, coinReward) ||
                other.coinReward == coinReward) &&
            (identical(other.gemReward, gemReward) ||
                other.gemReward == gemReward) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.unlocked, unlocked) ||
                other.unlocked == unlocked) &&
            (identical(other.unlockedAt, unlockedAt) ||
                other.unlockedAt == unlockedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      achievementKey,
      name,
      description,
      icon,
      category,
      threshold,
      coinReward,
      gemReward,
      progress,
      unlocked,
      unlockedAt);

  @override
  String toString() {
    return 'Achievement(id: $id, achievementKey: $achievementKey, name: $name, description: $description, icon: $icon, category: $category, threshold: $threshold, coinReward: $coinReward, gemReward: $gemReward, progress: $progress, unlocked: $unlocked, unlockedAt: $unlockedAt)';
  }
}

/// @nodoc
abstract mixin class $AchievementCopyWith<$Res> {
  factory $AchievementCopyWith(
          Achievement value, $Res Function(Achievement) _then) =
      _$AchievementCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String achievementKey,
      String name,
      String? description,
      String? icon,
      AchievementCategory category,
      int threshold,
      int coinReward,
      int gemReward,
      int progress,
      bool unlocked,
      String? unlockedAt});
}

/// @nodoc
class _$AchievementCopyWithImpl<$Res> implements $AchievementCopyWith<$Res> {
  _$AchievementCopyWithImpl(this._self, this._then);

  final Achievement _self;
  final $Res Function(Achievement) _then;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? achievementKey = null,
    Object? name = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? category = null,
    Object? threshold = null,
    Object? coinReward = null,
    Object? gemReward = null,
    Object? progress = null,
    Object? unlocked = null,
    Object? unlockedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      achievementKey: null == achievementKey
          ? _self.achievementKey
          : achievementKey // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as AchievementCategory,
      threshold: null == threshold
          ? _self.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as int,
      coinReward: null == coinReward
          ? _self.coinReward
          : coinReward // ignore: cast_nullable_to_non_nullable
              as int,
      gemReward: null == gemReward
          ? _self.gemReward
          : gemReward // ignore: cast_nullable_to_non_nullable
              as int,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      unlocked: null == unlocked
          ? _self.unlocked
          : unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      unlockedAt: freezed == unlockedAt
          ? _self.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Achievement].
extension AchievementPatterns on Achievement {
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
    TResult Function(_Achievement value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Achievement() when $default != null:
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
    TResult Function(_Achievement value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Achievement():
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
    TResult? Function(_Achievement value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Achievement() when $default != null:
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
            String achievementKey,
            String name,
            String? description,
            String? icon,
            AchievementCategory category,
            int threshold,
            int coinReward,
            int gemReward,
            int progress,
            bool unlocked,
            String? unlockedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Achievement() when $default != null:
        return $default(
            _that.id,
            _that.achievementKey,
            _that.name,
            _that.description,
            _that.icon,
            _that.category,
            _that.threshold,
            _that.coinReward,
            _that.gemReward,
            _that.progress,
            _that.unlocked,
            _that.unlockedAt);
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
            String achievementKey,
            String name,
            String? description,
            String? icon,
            AchievementCategory category,
            int threshold,
            int coinReward,
            int gemReward,
            int progress,
            bool unlocked,
            String? unlockedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Achievement():
        return $default(
            _that.id,
            _that.achievementKey,
            _that.name,
            _that.description,
            _that.icon,
            _that.category,
            _that.threshold,
            _that.coinReward,
            _that.gemReward,
            _that.progress,
            _that.unlocked,
            _that.unlockedAt);
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
            String achievementKey,
            String name,
            String? description,
            String? icon,
            AchievementCategory category,
            int threshold,
            int coinReward,
            int gemReward,
            int progress,
            bool unlocked,
            String? unlockedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Achievement() when $default != null:
        return $default(
            _that.id,
            _that.achievementKey,
            _that.name,
            _that.description,
            _that.icon,
            _that.category,
            _that.threshold,
            _that.coinReward,
            _that.gemReward,
            _that.progress,
            _that.unlocked,
            _that.unlockedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Achievement implements Achievement {
  const _Achievement(
      {required this.id,
      required this.achievementKey,
      required this.name,
      this.description,
      this.icon,
      required this.category,
      required this.threshold,
      this.coinReward = 0,
      this.gemReward = 0,
      this.progress = 0,
      this.unlocked = false,
      this.unlockedAt});
  factory _Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);

  @override
  final int id;
  @override
  final String achievementKey;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? icon;
  @override
  final AchievementCategory category;
  @override
  final int threshold;
  @override
  @JsonKey()
  final int coinReward;
  @override
  @JsonKey()
  final int gemReward;
  @override
  @JsonKey()
  final int progress;
  @override
  @JsonKey()
  final bool unlocked;
  @override
  final String? unlockedAt;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AchievementCopyWith<_Achievement> get copyWith =>
      __$AchievementCopyWithImpl<_Achievement>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AchievementToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Achievement &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.achievementKey, achievementKey) ||
                other.achievementKey == achievementKey) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold) &&
            (identical(other.coinReward, coinReward) ||
                other.coinReward == coinReward) &&
            (identical(other.gemReward, gemReward) ||
                other.gemReward == gemReward) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.unlocked, unlocked) ||
                other.unlocked == unlocked) &&
            (identical(other.unlockedAt, unlockedAt) ||
                other.unlockedAt == unlockedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      achievementKey,
      name,
      description,
      icon,
      category,
      threshold,
      coinReward,
      gemReward,
      progress,
      unlocked,
      unlockedAt);

  @override
  String toString() {
    return 'Achievement(id: $id, achievementKey: $achievementKey, name: $name, description: $description, icon: $icon, category: $category, threshold: $threshold, coinReward: $coinReward, gemReward: $gemReward, progress: $progress, unlocked: $unlocked, unlockedAt: $unlockedAt)';
  }
}

/// @nodoc
abstract mixin class _$AchievementCopyWith<$Res>
    implements $AchievementCopyWith<$Res> {
  factory _$AchievementCopyWith(
          _Achievement value, $Res Function(_Achievement) _then) =
      __$AchievementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String achievementKey,
      String name,
      String? description,
      String? icon,
      AchievementCategory category,
      int threshold,
      int coinReward,
      int gemReward,
      int progress,
      bool unlocked,
      String? unlockedAt});
}

/// @nodoc
class __$AchievementCopyWithImpl<$Res> implements _$AchievementCopyWith<$Res> {
  __$AchievementCopyWithImpl(this._self, this._then);

  final _Achievement _self;
  final $Res Function(_Achievement) _then;

  /// Create a copy of Achievement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? achievementKey = null,
    Object? name = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? category = null,
    Object? threshold = null,
    Object? coinReward = null,
    Object? gemReward = null,
    Object? progress = null,
    Object? unlocked = null,
    Object? unlockedAt = freezed,
  }) {
    return _then(_Achievement(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      achievementKey: null == achievementKey
          ? _self.achievementKey
          : achievementKey // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as AchievementCategory,
      threshold: null == threshold
          ? _self.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as int,
      coinReward: null == coinReward
          ? _self.coinReward
          : coinReward // ignore: cast_nullable_to_non_nullable
              as int,
      gemReward: null == gemReward
          ? _self.gemReward
          : gemReward // ignore: cast_nullable_to_non_nullable
              as int,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      unlocked: null == unlocked
          ? _self.unlocked
          : unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      unlockedAt: freezed == unlockedAt
          ? _self.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
