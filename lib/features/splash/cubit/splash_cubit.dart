import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState());

  Future<void> initialize() async {
    emit(state.copyWith(status: SplashStatus.loading));
    
    // Wait for 5 seconds
    await Future.delayed(const Duration(seconds: 5));
    
    emit(state.copyWith(status: SplashStatus.ready));
  }
}
