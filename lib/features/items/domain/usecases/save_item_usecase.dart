import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/local_item.dart';
import '../repositories/item_repository.dart';

class SaveItemUseCase implements UseCase<void, SaveItemParams> {
  final ItemRepository repository;

  SaveItemUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveItemParams params) async {
    return await repository.saveItem(params.item);
  }
}

class SaveItemParams extends Equatable {
  final LocalItem item;

  const SaveItemParams({required this.item});

  @override
  List<Object> get props => [item];
}
