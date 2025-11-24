import 'package:equatable/equatable.dart';
import '../../domain/entities/local_item.dart';

abstract class PreferenceState extends Equatable {
  const PreferenceState();

  @override
  List<Object> get props => [];
}

class PreferenceInitial extends PreferenceState {}

class PreferenceLoading extends PreferenceState {}

class PreferenceLoaded extends PreferenceState {
  final List<LocalItem> items;

  const PreferenceLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class PreferenceError extends PreferenceState {
  final String message;

  const PreferenceError(this.message);

  @override
  List<Object> get props => [message];
}

class PreferenceOperationSuccess extends PreferenceState {}
