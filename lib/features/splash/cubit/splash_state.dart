part of 'splash_cubit.dart';

enum SplashStatus { initial, loading, ready }

class SplashState {
  final SplashStatus status;

  const SplashState({
    this.status = SplashStatus.initial,
  });

  SplashState copyWith({
    SplashStatus? status,
  }) {
    return SplashState(
      status: status ?? this.status,
    );
  }
}
