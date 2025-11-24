import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/item_repository.dart';

class DeleteItemUseCase implements UseCase<void, DeleteItemParams> {
  final ItemRepository repository;

  DeleteItemUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteItemParams params) async {
    return await repository.deleteItem(params.id);
  }
}

class DeleteItemParams extends Equatable {
  final String id;

  const DeleteItemParams({required this.id});

  @override
  List<Object> get props => [id];
}
