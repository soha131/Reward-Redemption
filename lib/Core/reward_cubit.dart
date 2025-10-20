import 'package:flutter_bloc/flutter_bloc.dart';
import '../Models/reward_model.dart';
import 'reward_state.dart';

class RewardCubit extends Cubit<RewardState> {
  RewardCubit() : super(const RewardState(points: 500));

  void redeem(Reward reward) async {
    if (state.points >= reward.cost) {
      emit(state.copyWith(isLoading: true));

      await Future.delayed(const Duration(milliseconds: 700));

      emit(
        state.copyWith(
          points: state.points - reward.cost,
          isLoading: false,
          message: "You redeemed ${reward.name}!",
          lastRedeemed: reward,
        ),
      );
    } else {
      emit(state.copyWith(message: "Not enough points!"));
    }
  }

  void clearMessage() {
    emit(state.copyWith(message: null));
  }
}
