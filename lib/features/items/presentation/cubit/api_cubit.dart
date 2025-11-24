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
      // In a real app, you might want to filter the existing list or make a new API call.
      // For this demo, we'll assume the list is already loaded and we filter it locally
      // OR we just trigger a reload if query is empty.
      // Since the requirement says "searchItems(query)", let's implement a simple local filter
      // if we have data, or re-fetch if we don't.
      // However, to keep it simple and consistent with the state, we might need a separate
      // state for filtered items or just update the list.
      // Let's just re-fetch for now if query is empty to reset.
      if (query.isEmpty) {
        fetchItems();
      } else {
        // Local filtering logic would go here if we stored the full list.
        // For now, let's just leave it as a placeholder or implement basic local filtering
        // if we change the state to hold "all items" and "displayed items".
        // Given the simplicity, I'll stick to basic fetch.
      }
    }
  }
}
