import 'package:equatable/equatable.dart';
import '../../domain/entities/item.dart';

abstract class ApiState extends Equatable {
  const ApiState();

  @override
  List<Object> get props => [];
}

class ApiInitial extends ApiState {}

class ApiLoading extends ApiState {}

class ApiLoaded extends ApiState {
  final List<Item> items;
  final List<Item> filteredItems;

  const ApiLoaded(this.items, {List<Item>? filteredItems})
      : filteredItems = filteredItems ?? items;

  @override
  List<Object> get props => [items, filteredItems];
}

class ApiError extends ApiState {
  final String message;

  const ApiError(this.message);

  @override
  List<Object> get props => [message];
}
