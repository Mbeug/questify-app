import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats.freezed.dart';
part 'user_stats.g.dart';

@freezed
abstract class UserStats with _$UserStats {
  const factory UserStats({
    required int xp,
    required int level,
    required int xpToNextLevel,
    required int xpForCurrentLevel,
    required int totalQuestsCompleted,
    required double progressPercent,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}
