import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_items_usecase.dart';
import 'api_state.dart';

class ApiCubit extends Cubit<ApiState> {
  final GetItemsUseCase getItemsUseCase;

  ApiCubit({required this.getItemsUseCase}) : super(ApiInitial());

  Future<void> fetchItems() async {
    emit(ApiLoading());
    final result = await getItemsUseCase(NoParams());
    result.fold(
      (failure) => emit(ApiError(failure.message)),
      (items) => emit(ApiLoaded(items)),
    );
  }

  void searchItems(String query) {
    if (state is ApiLoaded) {
      final currentState = state as ApiLoaded;
      final allItems = currentState.items;
      
      if (query.isEmpty) {
        emit(ApiLoaded(allItems));
      } else {
        final filtered = allItems.where((item) {
          return item.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
        emit(ApiLoaded(allItems, filteredItems: filtered));
      }
    }
  }
}
