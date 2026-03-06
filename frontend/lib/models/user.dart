import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String email,
    required String displayName,
    required int xp,
    required int level,
    @Default(0) int coins,
    @Default(0) int gems,
    String? avatarId,
    @Default(0) int currentStreak,
    @Default(0) int bestStreak,
    String? createdAt,
    @Default(true) bool notificationsEnabled,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
