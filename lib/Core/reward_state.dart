import 'package:equatable/equatable.dart';
import '../Models/reward_model.dart';

class RewardState extends Equatable {
  final int points;
  final bool isLoading;
  final String? message;
  final Reward? lastRedeemed;

  const RewardState({
    required this.points,
    this.isLoading = false,
    this.message,
    this.lastRedeemed,
  });

  RewardState copyWith({
    int? points,
    bool? isLoading,
    String? message,
    Reward? lastRedeemed,
  }) {
    return RewardState(
      points: points ?? this.points,
      isLoading: isLoading ?? this.isLoading,
      message: message,
      lastRedeemed: lastRedeemed,
    );
  }

  @override
  List<Object?> get props => [points, isLoading, message, lastRedeemed];
}
