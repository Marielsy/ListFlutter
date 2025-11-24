import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/item.dart';
import '../entities/local_item.dart';

abstract class ItemRepository {
  Future<Either<Failure, List<Item>>> getItems();
  Future<Either<Failure, List<LocalItem>>> getSavedItems();
  Future<Either<Failure, void>> saveItem(LocalItem item);
  Future<Either<Failure, void>> deleteItem(String id);
}
