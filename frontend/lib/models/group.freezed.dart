// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuestGroup {
  int get id;
  String get name;
  String? get description;
  String? get bannerEmoji;
  String get inviteCode;
  int get weeklyGoal;
  int get weeklyProgress;
  int get memberCount;
  String? get createdAt;
  List<GroupMember> get members;

  /// Create a copy of QuestGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QuestGroupCopyWith<QuestGroup> get copyWith =>
      _$QuestGroupCopyWithImpl<QuestGroup>(this as QuestGroup, _$identity);

  /// Serializes this QuestGroup to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QuestGroup &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.bannerEmoji, bannerEmoji) ||
                other.bannerEmoji == bannerEmoji) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.weeklyGoal, weeklyGoal) ||
                other.weeklyGoal == weeklyGoal) &&
            (identical(other.weeklyProgress, weeklyProgress) ||
                other.weeklyProgress == weeklyProgress) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.members, members));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      bannerEmoji,
      inviteCode,
      weeklyGoal,
      weeklyProgress,
      memberCount,
      createdAt,
      const DeepCollectionEquality().hash(members));

  @override
  String toString() {
    return 'QuestGroup(id: $id, name: $name, description: $description, bannerEmoji: $bannerEmoji, inviteCode: $inviteCode, weeklyGoal: $weeklyGoal, weeklyProgress: $weeklyProgress, memberCount: $memberCount, createdAt: $createdAt, members: $members)';
  }
}

/// @nodoc
abstract mixin class $QuestGroupCopyWith<$Res> {
  factory $QuestGroupCopyWith(
          QuestGroup value, $Res Function(QuestGroup) _then) =
      _$QuestGroupCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      String? bannerEmoji,
      String inviteCode,
      int weeklyGoal,
      int weeklyProgress,
      int memberCount,
      String? createdAt,
      List<GroupMember> members});
}

/// @nodoc
class _$QuestGroupCopyWithImpl<$Res> implements $QuestGroupCopyWith<$Res> {
  _$QuestGroupCopyWithImpl(this._self, this._then);

  final QuestGroup _self;
  final $Res Function(QuestGroup) _then;

  /// Create a copy of QuestGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? bannerEmoji = freezed,
    Object? inviteCode = null,
    Object? weeklyGoal = null,
    Object? weeklyProgress = null,
    Object? memberCount = null,
    Object? createdAt = freezed,
    Object? members = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      bannerEmoji: freezed == bannerEmoji
          ? _self.bannerEmoji
          : bannerEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
      inviteCode: null == inviteCode
          ? _self.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
      weeklyGoal: null == weeklyGoal
          ? _self.weeklyGoal
          : weeklyGoal // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyProgress: null == weeklyProgress
          ? _self.weeklyProgress
          : weeklyProgress // ignore: cast_nullable_to_non_nullable
              as int,
      memberCount: null == memberCount
          ? _self.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      members: null == members
          ? _self.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<GroupMember>,
    ));
  }
}

/// Adds pattern-matching-related methods to [QuestGroup].
extension QuestGroupPatterns on QuestGroup {
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
    TResult Function(_QuestGroup value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _QuestGroup() when $default != null:
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
    TResult Function(_QuestGroup value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QuestGroup():
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
    TResult? Function(_QuestGroup value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QuestGroup() when $default != null:
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
            String name,
            String? description,
            String? bannerEmoji,
            String inviteCode,
            int weeklyGoal,
            int weeklyProgress,
            int memberCount,
            String? createdAt,
            List<GroupMember> members)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _QuestGroup() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.description,
            _that.bannerEmoji,
            _that.inviteCode,
            _that.weeklyGoal,
            _that.weeklyProgress,
            _that.memberCount,
            _that.createdAt,
            _that.members);
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
            String name,
            String? description,
            String? bannerEmoji,
            String inviteCode,
            int weeklyGoal,
            int weeklyProgress,
            int memberCount,
            String? createdAt,
            List<GroupMember> members)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QuestGroup():
        return $default(
            _that.id,
            _that.name,
            _that.description,
            _that.bannerEmoji,
            _that.inviteCode,
            _that.weeklyGoal,
            _that.weeklyProgress,
            _that.memberCount,
            _that.createdAt,
            _that.members);
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
            String name,
            String? description,
            String? bannerEmoji,
            String inviteCode,
            int weeklyGoal,
            int weeklyProgress,
            int memberCount,
            String? createdAt,
            List<GroupMember> members)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _QuestGroup() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.description,
            _that.bannerEmoji,
            _that.inviteCode,
            _that.weeklyGoal,
            _that.weeklyProgress,
            _that.memberCount,
            _that.createdAt,
            _that.members);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _QuestGroup implements QuestGroup {
  const _QuestGroup(
      {required this.id,
      required this.name,
      this.description,
      this.bannerEmoji,
      required this.inviteCode,
      this.weeklyGoal = 10,
      this.weeklyProgress = 0,
      this.memberCount = 0,
      this.createdAt,
      final List<GroupMember> members = const []})
      : _members = members;
  factory _QuestGroup.fromJson(Map<String, dynamic> json) =>
      _$QuestGroupFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? bannerEmoji;
  @override
  final String inviteCode;
  @override
  @JsonKey()
  final int weeklyGoal;
  @override
  @JsonKey()
  final int weeklyProgress;
  @override
  @JsonKey()
  final int memberCount;
  @override
  final String? createdAt;
  final List<GroupMember> _members;
  @override
  @JsonKey()
  List<GroupMember> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  /// Create a copy of QuestGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$QuestGroupCopyWith<_QuestGroup> get copyWith =>
      __$QuestGroupCopyWithImpl<_QuestGroup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$QuestGroupToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _QuestGroup &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.bannerEmoji, bannerEmoji) ||
                other.bannerEmoji == bannerEmoji) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.weeklyGoal, weeklyGoal) ||
                other.weeklyGoal == weeklyGoal) &&
            (identical(other.weeklyProgress, weeklyProgress) ||
                other.weeklyProgress == weeklyProgress) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      bannerEmoji,
      inviteCode,
      weeklyGoal,
      weeklyProgress,
      memberCount,
      createdAt,
      const DeepCollectionEquality().hash(_members));

  @override
  String toString() {
    return 'QuestGroup(id: $id, name: $name, description: $description, bannerEmoji: $bannerEmoji, inviteCode: $inviteCode, weeklyGoal: $weeklyGoal, weeklyProgress: $weeklyProgress, memberCount: $memberCount, createdAt: $createdAt, members: $members)';
  }
}

/// @nodoc
abstract mixin class _$QuestGroupCopyWith<$Res>
    implements $QuestGroupCopyWith<$Res> {
  factory _$QuestGroupCopyWith(
          _QuestGroup value, $Res Function(_QuestGroup) _then) =
      __$QuestGroupCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      String? bannerEmoji,
      String inviteCode,
      int weeklyGoal,
      int weeklyProgress,
      int memberCount,
      String? createdAt,
      List<GroupMember> members});
}

/// @nodoc
class __$QuestGroupCopyWithImpl<$Res> implements _$QuestGroupCopyWith<$Res> {
  __$QuestGroupCopyWithImpl(this._self, this._then);

  final _QuestGroup _self;
  final $Res Function(_QuestGroup) _then;

  /// Create a copy of QuestGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? bannerEmoji = freezed,
    Object? inviteCode = null,
    Object? weeklyGoal = null,
    Object? weeklyProgress = null,
    Object? memberCount = null,
    Object? createdAt = freezed,
    Object? members = null,
  }) {
    return _then(_QuestGroup(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      bannerEmoji: freezed == bannerEmoji
          ? _self.bannerEmoji
          : bannerEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
      inviteCode: null == inviteCode
          ? _self.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
      weeklyGoal: null == weeklyGoal
          ? _self.weeklyGoal
          : weeklyGoal // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyProgress: null == weeklyProgress
          ? _self.weeklyProgress
          : weeklyProgress // ignore: cast_nullable_to_non_nullable
              as int,
      memberCount: null == memberCount
          ? _self.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      members: null == members
          ? _self._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<GroupMember>,
    ));
  }
}

/// @nodoc
mixin _$GroupMember {
  int get userId;
  String get displayName;
  String? get avatarId;
  int get level;
  int get weeklyXp;
  int get weeklyQuestsCompleted;
  GroupRole get role;
  String? get joinedAt;

  /// Create a copy of GroupMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupMemberCopyWith<GroupMember> get copyWith =>
      _$GroupMemberCopyWithImpl<GroupMember>(this as GroupMember, _$identity);

  /// Serializes this GroupMember to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupMember &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarId, avatarId) ||
                other.avatarId == avatarId) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.weeklyXp, weeklyXp) ||
                other.weeklyXp == weeklyXp) &&
            (identical(other.weeklyQuestsCompleted, weeklyQuestsCompleted) ||
                other.weeklyQuestsCompleted == weeklyQuestsCompleted) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, displayName, avatarId,
      level, weeklyXp, weeklyQuestsCompleted, role, joinedAt);

  @override
  String toString() {
    return 'GroupMember(userId: $userId, displayName: $displayName, avatarId: $avatarId, level: $level, weeklyXp: $weeklyXp, weeklyQuestsCompleted: $weeklyQuestsCompleted, role: $role, joinedAt: $joinedAt)';
  }
}

/// @nodoc
abstract mixin class $GroupMemberCopyWith<$Res> {
  factory $GroupMemberCopyWith(
          GroupMember value, $Res Function(GroupMember) _then) =
      _$GroupMemberCopyWithImpl;
  @useResult
  $Res call(
      {int userId,
      String displayName,
      String? avatarId,
      int level,
      int weeklyXp,
      int weeklyQuestsCompleted,
      GroupRole role,
      String? joinedAt});
}

/// @nodoc
class _$GroupMemberCopyWithImpl<$Res> implements $GroupMemberCopyWith<$Res> {
  _$GroupMemberCopyWithImpl(this._self, this._then);

  final GroupMember _self;
  final $Res Function(GroupMember) _then;

  /// Create a copy of GroupMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? avatarId = freezed,
    Object? level = null,
    Object? weeklyXp = null,
    Object? weeklyQuestsCompleted = null,
    Object? role = null,
    Object? joinedAt = freezed,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarId: freezed == avatarId
          ? _self.avatarId
          : avatarId // ignore: cast_nullable_to_non_nullable
              as String?,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyXp: null == weeklyXp
          ? _self.weeklyXp
          : weeklyXp // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyQuestsCompleted: null == weeklyQuestsCompleted
          ? _self.weeklyQuestsCompleted
          : weeklyQuestsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as GroupRole,
      joinedAt: freezed == joinedAt
          ? _self.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [GroupMember].
extension GroupMemberPatterns on GroupMember {
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
    TResult Function(_GroupMember value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GroupMember() when $default != null:
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
    TResult Function(_GroupMember value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupMember():
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
    TResult? Function(_GroupMember value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupMember() when $default != null:
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
            int userId,
            String displayName,
            String? avatarId,
            int level,
            int weeklyXp,
            int weeklyQuestsCompleted,
            GroupRole role,
            String? joinedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GroupMember() when $default != null:
        return $default(
            _that.userId,
            _that.displayName,
            _that.avatarId,
            _that.level,
            _that.weeklyXp,
            _that.weeklyQuestsCompleted,
            _that.role,
            _that.joinedAt);
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
            int userId,
            String displayName,
            String? avatarId,
            int level,
            int weeklyXp,
            int weeklyQuestsCompleted,
            GroupRole role,
            String? joinedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupMember():
        return $default(
            _that.userId,
            _that.displayName,
            _that.avatarId,
            _that.level,
            _that.weeklyXp,
            _that.weeklyQuestsCompleted,
            _that.role,
            _that.joinedAt);
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
            int userId,
            String displayName,
            String? avatarId,
            int level,
            int weeklyXp,
            int weeklyQuestsCompleted,
            GroupRole role,
            String? joinedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupMember() when $default != null:
        return $default(
            _that.userId,
            _that.displayName,
            _that.avatarId,
            _that.level,
            _that.weeklyXp,
            _that.weeklyQuestsCompleted,
            _that.role,
            _that.joinedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GroupMember implements GroupMember {
  const _GroupMember(
      {required this.userId,
      required this.displayName,
      this.avatarId,
      this.level = 1,
      this.weeklyXp = 0,
      this.weeklyQuestsCompleted = 0,
      this.role = GroupRole.MEMBER,
      this.joinedAt});
  factory _GroupMember.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberFromJson(json);

  @override
  final int userId;
  @override
  final String displayName;
  @override
  final String? avatarId;
  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final int weeklyXp;
  @override
  @JsonKey()
  final int weeklyQuestsCompleted;
  @override
  @JsonKey()
  final GroupRole role;
  @override
  final String? joinedAt;

  /// Create a copy of GroupMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GroupMemberCopyWith<_GroupMember> get copyWith =>
      __$GroupMemberCopyWithImpl<_GroupMember>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GroupMemberToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GroupMember &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarId, avatarId) ||
                other.avatarId == avatarId) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.weeklyXp, weeklyXp) ||
                other.weeklyXp == weeklyXp) &&
            (identical(other.weeklyQuestsCompleted, weeklyQuestsCompleted) ||
                other.weeklyQuestsCompleted == weeklyQuestsCompleted) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, displayName, avatarId,
      level, weeklyXp, weeklyQuestsCompleted, role, joinedAt);

  @override
  String toString() {
    return 'GroupMember(userId: $userId, displayName: $displayName, avatarId: $avatarId, level: $level, weeklyXp: $weeklyXp, weeklyQuestsCompleted: $weeklyQuestsCompleted, role: $role, joinedAt: $joinedAt)';
  }
}

/// @nodoc
abstract mixin class _$GroupMemberCopyWith<$Res>
    implements $GroupMemberCopyWith<$Res> {
  factory _$GroupMemberCopyWith(
          _GroupMember value, $Res Function(_GroupMember) _then) =
      __$GroupMemberCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int userId,
      String displayName,
      String? avatarId,
      int level,
      int weeklyXp,
      int weeklyQuestsCompleted,
      GroupRole role,
      String? joinedAt});
}

/// @nodoc
class __$GroupMemberCopyWithImpl<$Res> implements _$GroupMemberCopyWith<$Res> {
  __$GroupMemberCopyWithImpl(this._self, this._then);

  final _GroupMember _self;
  final $Res Function(_GroupMember) _then;

  /// Create a copy of GroupMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? avatarId = freezed,
    Object? level = null,
    Object? weeklyXp = null,
    Object? weeklyQuestsCompleted = null,
    Object? role = null,
    Object? joinedAt = freezed,
  }) {
    return _then(_GroupMember(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarId: freezed == avatarId
          ? _self.avatarId
          : avatarId // ignore: cast_nullable_to_non_nullable
              as String?,
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyXp: null == weeklyXp
          ? _self.weeklyXp
          : weeklyXp // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyQuestsCompleted: null == weeklyQuestsCompleted
          ? _self.weeklyQuestsCompleted
          : weeklyQuestsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as GroupRole,
      joinedAt: freezed == joinedAt
          ? _self.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
