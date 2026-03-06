// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Quest {
  int get id;
  String get title;
  String? get description;
  QuestStatus get status;
  QuestDifficulty get difficulty;
  int get xpReward;
  int get coinReward;
  QuestCategory? get category;
  QuestRecurrence get recurrence;
  String? get rarity;
  String? get dueDate;
  String? get completedAt;
  String? get createdAt;
  String? get calendarEventId;
  LevelUpResult? get levelUpResult;

  /// Create a copy of Quest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QuestCopyWith<Quest> get copyWith =>
      _$QuestCopyWithImpl<Quest>(this as Quest, _$identity);

  /// Serializes this Quest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Quest &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.xpReward, xpReward) ||
                other.xpReward == xpReward) &&
            (identical(other.coinReward, coinReward) ||
                other.coinReward == coinReward) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.recurrence, recurrence) ||
                other.recurrence == recurrence) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.calendarEventId, calendarEventId) ||
                other.calendarEventId == calendarEventId) &&
            (identical(other.levelUpResult, levelUpResult) ||
                other.levelUpResult == levelUpResult));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      status,
      difficulty,
      xpReward,
      coinReward,
      category,
      recurrence,
      rarity,
      dueDate,
      completedAt,
      createdAt,
      calendarEventId,
      levelUpResult);

  @override
  String toString() {
    return 'Quest(id: $id, title: $title, description: $description, status: $status, difficulty: $difficulty, xpReward: $xpReward, coinReward: $coinReward, category: $category, recurrence: $recurrence, rarity: $rarity, dueDate: $dueDate, completedAt: $completedAt, createdAt: $createdAt, calendarEventId: $calendarEventId, levelUpResult: $levelUpResult)';
  }
}

/// @nodoc
abstract mixin class $QuestCopyWith<$Res> {
  factory $QuestCopyWith(Quest value, $Res Function(Quest) _then) =
      _$QuestCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String title,
      String? description,
      QuestStatus status,
      QuestDifficulty difficulty,
      int xpReward,
      int coinReward,
      QuestCategory? category,
      QuestRecurrence recurrence,
      String? rarity,
      String? dueDate,
      String? completedAt,
      String? createdAt,
      String? calendarEventId,
      LevelUpResult? levelUpResult});

  $LevelUpResultCopyWith<$Res>? get levelUpResult;
}

/// @nodoc
class _$QuestCopyWithImpl<$Res> implements $QuestCopyWith<$Res> {
  _$QuestCopyWithImpl(this._self, this._then);

  final Quest _self;
  final $Res Function(Quest) _then;

  /// Create a copy of Quest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? status = null,
    Object? difficulty = null,
    Object? xpReward = null,
    Object? coinReward = null,
    Object? category = freezed,
    Object? recurrence = null,
    Object? rarity = freezed,
    Object? dueDate = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? calendarEventId = freezed,
    Object? levelUpResult = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuestStatus,
      difficulty: null == difficulty
          ? _self.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as QuestDifficulty,
      xpReward: null == xpReward
          ? _self.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      coinReward: null == coinReward
          ? _self.coinReward
          : coinReward // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as QuestCategory?,
      recurrence: null == recurrence
          ? _self.recurrence
          : recurrence // ignore: cast_nullable_to_non_nullable
              as QuestRecurrence,
      rarity: freezed == rarity
          ? _self.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _self.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      calendarEventId: freezed == calendarEventId
          ? _self.calendarEventId
          : calendarEventId // ignore: cast_nullable_to_non_nullable
              as String?,
      levelUpResult: freezed == levelUpResult
          ? _self.levelUpResult
          : levelUpResult // ignore: cast_nullable_to_non_nullable
              as LevelUpResult?,
    ));
  }

  /// Create a copy of Quest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LevelUpResultCopyWith<$Res>? get levelUpResult {
    if (_self.levelUpResult == null) {
      return null;
    }

    return $LevelUpResultCopyWith<$Res>(_self.levelUpResult!, (value) {
      return _then(_self.copyWith(levelUpResult: value));
    });
  }
}

/// Adds pattern-matching-related methods to [Quest].
extension QuestPatterns on Quest {
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
    TResult Function(_Quest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Quest() when $default != null:
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
    TResult Function(_Quest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Quest():
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
    TResult? Function(_Quest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Quest() when $default != null:
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
            String title,
            String? description,
            QuestStatus status,
            QuestDifficulty difficulty,
            int xpReward,
            int coinReward,
            QuestCategory? category,
            QuestRecurrence recurrence,
            String? rarity,
            String? dueDate,
            String? completedAt,
            String? createdAt,
            String? calendarEventId,
            LevelUpResult? levelUpResult)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Quest() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.description,
            _that.status,
            _that.difficulty,
            _that.xpReward,
            _that.coinReward,
            _that.category,
            _that.recurrence,
            _that.rarity,
            _that.dueDate,
            _that.completedAt,
            _that.createdAt,
            _that.calendarEventId,
            _that.levelUpResult);
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
            String title,
            String? description,
            QuestStatus status,
            QuestDifficulty difficulty,
            int xpReward,
            int coinReward,
            QuestCategory? category,
            QuestRecurrence recurrence,
            String? rarity,
            String? dueDate,
            String? completedAt,
            String? createdAt,
            String? calendarEventId,
            LevelUpResult? levelUpResult)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Quest():
        return $default(
            _that.id,
            _that.title,
            _that.description,
            _that.status,
            _that.difficulty,
            _that.xpReward,
            _that.coinReward,
            _that.category,
            _that.recurrence,
            _that.rarity,
            _that.dueDate,
            _that.completedAt,
            _that.createdAt,
            _that.calendarEventId,
            _that.levelUpResult);
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
            String title,
            String? description,
            QuestStatus status,
            QuestDifficulty difficulty,
            int xpReward,
            int coinReward,
            QuestCategory? category,
            QuestRecurrence recurrence,
            String? rarity,
            String? dueDate,
            String? completedAt,
            String? createdAt,
            String? calendarEventId,
            LevelUpResult? levelUpResult)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Quest() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.description,
            _that.status,
            _that.difficulty,
            _that.xpReward,
            _that.coinReward,
            _that.category,
            _that.recurrence,
            _that.rarity,
            _that.dueDate,
            _that.completedAt,
            _that.createdAt,
            _that.calendarEventId,
            _that.levelUpResult);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Quest implements Quest {
  const _Quest(
      {required this.id,
      required this.title,
      this.description,
      required this.status,
      required this.difficulty,
      required this.xpReward,
      this.coinReward = 0,
      this.category,
      this.recurrence = QuestRecurrence.ONE_TIME,
      this.rarity,
      this.dueDate,
      this.completedAt,
      this.createdAt,
      this.calendarEventId,
      this.levelUpResult});
  factory _Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final QuestStatus status;
  @override
  final QuestDifficulty difficulty;
  @override
  final int xpReward;
  @override
  @JsonKey()
  final int coinReward;
  @override
  final QuestCategory? category;
  @override
  @JsonKey()
  final QuestRecurrence recurrence;
  @override
  final String? rarity;
  @override
  final String? dueDate;
  @override
  final String? completedAt;
  @override
  final String? createdAt;
  @override
  final String? calendarEventId;
  @override
  final LevelUpResult? levelUpResult;

  /// Create a copy of Quest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$QuestCopyWith<_Quest> get copyWith =>
      __$QuestCopyWithImpl<_Quest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$QuestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Quest &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.xpReward, xpReward) ||
                other.xpReward == xpReward) &&
            (identical(other.coinReward, coinReward) ||
                other.coinReward == coinReward) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.recurrence, recurrence) ||
                other.recurrence == recurrence) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.calendarEventId, calendarEventId) ||
                other.calendarEventId == calendarEventId) &&
            (identical(other.levelUpResult, levelUpResult) ||
                other.levelUpResult == levelUpResult));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      status,
      difficulty,
      xpReward,
      coinReward,
      category,
      recurrence,
      rarity,
      dueDate,
      completedAt,
      createdAt,
      calendarEventId,
      levelUpResult);

  @override
  String toString() {
    return 'Quest(id: $id, title: $title, description: $description, status: $status, difficulty: $difficulty, xpReward: $xpReward, coinReward: $coinReward, category: $category, recurrence: $recurrence, rarity: $rarity, dueDate: $dueDate, completedAt: $completedAt, createdAt: $createdAt, calendarEventId: $calendarEventId, levelUpResult: $levelUpResult)';
  }
}

/// @nodoc
abstract mixin class _$QuestCopyWith<$Res> implements $QuestCopyWith<$Res> {
  factory _$QuestCopyWith(_Quest value, $Res Function(_Quest) _then) =
      __$QuestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String? description,
      QuestStatus status,
      QuestDifficulty difficulty,
      int xpReward,
      int coinReward,
      QuestCategory? category,
      QuestRecurrence recurrence,
      String? rarity,
      String? dueDate,
      String? completedAt,
      String? createdAt,
      String? calendarEventId,
      LevelUpResult? levelUpResult});

  @override
  $LevelUpResultCopyWith<$Res>? get levelUpResult;
}

/// @nodoc
class __$QuestCopyWithImpl<$Res> implements _$QuestCopyWith<$Res> {
  __$QuestCopyWithImpl(this._self, this._then);

  final _Quest _self;
  final $Res Function(_Quest) _then;

  /// Create a copy of Quest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? status = null,
    Object? difficulty = null,
    Object? xpReward = null,
    Object? coinReward = null,
    Object? category = freezed,
    Object? recurrence = null,
    Object? rarity = freezed,
    Object? dueDate = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? calendarEventId = freezed,
    Object? levelUpResult = freezed,
  }) {
    return _then(_Quest(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuestStatus,
      difficulty: null == difficulty
          ? _self.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as QuestDifficulty,
      xpReward: null == xpReward
          ? _self.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      coinReward: null == coinReward
          ? _self.coinReward
          : coinReward // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as QuestCategory?,
      recurrence: null == recurrence
          ? _self.recurrence
          : recurrence // ignore: cast_nullable_to_non_nullable
              as QuestRecurrence,
      rarity: freezed == rarity
          ? _self.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _self.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      calendarEventId: freezed == calendarEventId
          ? _self.calendarEventId
          : calendarEventId // ignore: cast_nullable_to_non_nullable
              as String?,
      levelUpResult: freezed == levelUpResult
          ? _self.levelUpResult
          : levelUpResult // ignore: cast_nullable_to_non_nullable
              as LevelUpResult?,
    ));
  }

  /// Create a copy of Quest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LevelUpResultCopyWith<$Res>? get levelUpResult {
    if (_self.levelUpResult == null) {
      return null;
    }

    return $LevelUpResultCopyWith<$Res>(_self.levelUpResult!, (value) {
      return _then(_self.copyWith(levelUpResult: value));
    });
  }
}

/// @nodoc
mixin _$LevelUpResult {
  int get totalXp;
  int get level;
  bool get leveledUp;
  int get xpGained;
  int get xpToNextLevel;
  int get coinsEarned;
  int get gemsEarned;

  /// Create a copy of LevelUpResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LevelUpResultCopyWith<LevelUpResult> get copyWith =>
      _$LevelUpResultCopyWithImpl<LevelUpResult>(
          this as LevelUpResult, _$identity);

  /// Serializes this LevelUpResult to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LevelUpResult &&
            (identical(other.totalXp, totalXp) || other.totalXp == totalXp) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.leveledUp, leveledUp) ||
                other.leveledUp == leveledUp) &&
            (identical(other.xpGained, xpGained) ||
                other.xpGained == xpGained) &&
            (identical(other.xpToNextLevel, xpToNextLevel) ||
                other.xpToNextLevel == xpToNextLevel) &&
            (identical(other.coinsEarned, coinsEarned) ||
                other.coinsEarned == coinsEarned) &&
            (identical(other.gemsEarned, gemsEarned) ||
                other.gemsEarned == gemsEarned));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalXp, level, leveledUp,
      xpGained, xpToNextLevel, coinsEarned, gemsEarned);

  @override
  String toString() {
    return 'LevelUpResult(totalXp: $totalXp, level: $level, leveledUp: $leveledUp, xpGained: $xpGained, xpToNextLevel: $xpToNextLevel, coinsEarned: $coinsEarned, gemsEarned: $gemsEarned)';
  }
}

/// @nodoc
abstract mixin class $LevelUpResultCopyWith<$Res> {
  factory $LevelUpResultCopyWith(
          LevelUpResult value, $Res Function(LevelUpResult) _then) =
      _$LevelUpResultCopyWithImpl;
  @useResult
  $Res call(
      {int totalXp,
      int level,
      bool leveledUp,
      int xpGained,
      int xpToNextLevel,
      int coinsEarned,
      int gemsEarned});
}

/// @nodoc
class _$LevelUpResultCopyWithImpl<$Res>
    implements $LevelUpResultCopyWith<$Res> {
  _$LevelUpResultCopyWithImpl(this._self, this._then);

  final LevelUpResult _self;
  final $Res Function(LevelUpResult) _then;

  /// Create a copy of LevelUpResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalXp = null,
    Object? level = null,
    Object? leveledUp = null,
    Object? xpGained = null,
    Object? xpToNextLevel = null,
    Object? coinsEarned = null,
    Object? gemsEarned = null,
  }) {
    return _then(_self.copyWith(
      totalXp: null == totalXp
          ? _self.totalXp
          : totalXp // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      leveledUp: null == leveledUp
          ? _self.leveledUp
          : leveledUp // ignore: cast_nullable_to_non_nullable
              as bool,
      xpGained: null == xpGained
          ? _self.xpGained
          : xpGained // ignore: cast_nullable_to_non_nullable
              as int,
      xpToNextLevel: null == xpToNextLevel
          ? _self.xpToNextLevel
          : xpToNextLevel // ignore: cast_nullable_to_non_nullable
              as int,
      coinsEarned: null == coinsEarned
          ? _self.coinsEarned
          : coinsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      gemsEarned: null == gemsEarned
          ? _self.gemsEarned
          : gemsEarned // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [LevelUpResult].
extension LevelUpResultPatterns on LevelUpResult {
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
    TResult Function(_LevelUpResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LevelUpResult() when $default != null:
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
    TResult Function(_LevelUpResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LevelUpResult():
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
    TResult? Function(_LevelUpResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LevelUpResult() when $default != null:
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
    TResult Function(int totalXp, int level, bool leveledUp, int xpGained,
            int xpToNextLevel, int coinsEarned, int gemsEarned)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LevelUpResult() when $default != null:
        return $default(
            _that.totalXp,
            _that.level,
            _that.leveledUp,
            _that.xpGained,
            _that.xpToNextLevel,
            _that.coinsEarned,
            _that.gemsEarned);
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
    TResult Function(int totalXp, int level, bool leveledUp, int xpGained,
            int xpToNextLevel, int coinsEarned, int gemsEarned)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LevelUpResult():
        return $default(
            _that.totalXp,
            _that.level,
            _that.leveledUp,
            _that.xpGained,
            _that.xpToNextLevel,
            _that.coinsEarned,
            _that.gemsEarned);
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
    TResult? Function(int totalXp, int level, bool leveledUp, int xpGained,
            int xpToNextLevel, int coinsEarned, int gemsEarned)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LevelUpResult() when $default != null:
        return $default(
            _that.totalXp,
            _that.level,
            _that.leveledUp,
            _that.xpGained,
            _that.xpToNextLevel,
            _that.coinsEarned,
            _that.gemsEarned);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LevelUpResult implements LevelUpResult {
  const _LevelUpResult(
      {required this.totalXp,
      required this.level,
      required this.leveledUp,
      required this.xpGained,
      required this.xpToNextLevel,
      this.coinsEarned = 0,
      this.gemsEarned = 0});
  factory _LevelUpResult.fromJson(Map<String, dynamic> json) =>
      _$LevelUpResultFromJson(json);

  @override
  final int totalXp;
  @override
  final int level;
  @override
  final bool leveledUp;
  @override
  final int xpGained;
  @override
  final int xpToNextLevel;
  @override
  @JsonKey()
  final int coinsEarned;
  @override
  @JsonKey()
  final int gemsEarned;

  /// Create a copy of LevelUpResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LevelUpResultCopyWith<_LevelUpResult> get copyWith =>
      __$LevelUpResultCopyWithImpl<_LevelUpResult>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LevelUpResultToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LevelUpResult &&
            (identical(other.totalXp, totalXp) || other.totalXp == totalXp) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.leveledUp, leveledUp) ||
                other.leveledUp == leveledUp) &&
            (identical(other.xpGained, xpGained) ||
                other.xpGained == xpGained) &&
            (identical(other.xpToNextLevel, xpToNextLevel) ||
                other.xpToNextLevel == xpToNextLevel) &&
            (identical(other.coinsEarned, coinsEarned) ||
                other.coinsEarned == coinsEarned) &&
            (identical(other.gemsEarned, gemsEarned) ||
                other.gemsEarned == gemsEarned));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalXp, level, leveledUp,
      xpGained, xpToNextLevel, coinsEarned, gemsEarned);

  @override
  String toString() {
    return 'LevelUpResult(totalXp: $totalXp, level: $level, leveledUp: $leveledUp, xpGained: $xpGained, xpToNextLevel: $xpToNextLevel, coinsEarned: $coinsEarned, gemsEarned: $gemsEarned)';
  }
}

/// @nodoc
abstract mixin class _$LevelUpResultCopyWith<$Res>
    implements $LevelUpResultCopyWith<$Res> {
  factory _$LevelUpResultCopyWith(
          _LevelUpResult value, $Res Function(_LevelUpResult) _then) =
      __$LevelUpResultCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int totalXp,
      int level,
      bool leveledUp,
      int xpGained,
      int xpToNextLevel,
      int coinsEarned,
      int gemsEarned});
}

/// @nodoc
class __$LevelUpResultCopyWithImpl<$Res>
    implements _$LevelUpResultCopyWith<$Res> {
  __$LevelUpResultCopyWithImpl(this._self, this._then);

  final _LevelUpResult _self;
  final $Res Function(_LevelUpResult) _then;

  /// Create a copy of LevelUpResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalXp = null,
    Object? level = null,
    Object? leveledUp = null,
    Object? xpGained = null,
    Object? xpToNextLevel = null,
    Object? coinsEarned = null,
    Object? gemsEarned = null,
  }) {
    return _then(_LevelUpResult(
      totalXp: null == totalXp
          ? _self.totalXp
          : totalXp // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      leveledUp: null == leveledUp
          ? _self.leveledUp
          : leveledUp // ignore: cast_nullable_to_non_nullable
              as bool,
      xpGained: null == xpGained
          ? _self.xpGained
          : xpGained // ignore: cast_nullable_to_non_nullable
              as int,
      xpToNextLevel: null == xpToNextLevel
          ? _self.xpToNextLevel
          : xpToNextLevel // ignore: cast_nullable_to_non_nullable
              as int,
      coinsEarned: null == coinsEarned
          ? _self.coinsEarned
          : coinsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      gemsEarned: null == gemsEarned
          ? _self.gemsEarned
          : gemsEarned // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
