import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/local_item.dart';
import '../repositories/item_repository.dart';

class GetSavedItemsUseCase implements UseCase<List<LocalItem>, NoParams> {
  final ItemRepository repository;

  GetSavedItemsUseCase(this.repository);

  @override
  Future<Either<Failure, List<LocalItem>>> call(NoParams params) async {
    return await repository.getSavedItems();
  }
}
