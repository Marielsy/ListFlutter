import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/local_item.dart';
import '../../domain/usecases/delete_item_usecase.dart';
import '../../domain/usecases/get_saved_items_usecase.dart';
import '../../domain/usecases/save_item_usecase.dart';
import 'preference_state.dart';

class PreferenceCubit extends Cubit<PreferenceState> {
  final GetSavedItemsUseCase getSavedItemsUseCase;
  final SaveItemUseCase saveItemUseCase;
  final DeleteItemUseCase deleteItemUseCase;

  PreferenceCubit({
    required this.getSavedItemsUseCase,
    required this.saveItemUseCase,
    required this.deleteItemUseCase,
  }) : super(PreferenceInitial());

  Future<void> loadSavedItems() async {
    emit(PreferenceLoading());
    final result = await getSavedItemsUseCase(NoParams());
    result.fold(
      (failure) => emit(PreferenceError(failure.message)),
      (items) => emit(PreferenceLoaded(items)),
    );
  }

  Future<void> saveItem(LocalItem item) async {
    emit(PreferenceLoading());
    final result = await saveItemUseCase(SaveItemParams(item: item));
    result.fold(
      (failure) => emit(PreferenceError(failure.message)),
      (_) {
        emit(PreferenceOperationSuccess());
        loadSavedItems();
      },
    );
  }

  Future<void> deleteItem(String id) async {
    emit(PreferenceLoading());
    final result = await deleteItemUseCase(DeleteItemParams(id: id));
    result.fold(
      (failure) => emit(PreferenceError(failure.message)),
      (_) {
        emit(PreferenceOperationSuccess());
        loadSavedItems();
      },
    );
  }
}
