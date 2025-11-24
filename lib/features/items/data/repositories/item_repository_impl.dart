import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/local_item.dart';
import '../../domain/repositories/item_repository.dart';
import '../datasources/item_local_datasource.dart';
import '../datasources/item_remote_datasource.dart';
import '../models/local_item_model.dart';

class ItemRepositoryImpl implements ItemRepository {
  final ItemRemoteDataSource remoteDataSource;
  final ItemLocalDataSource localDataSource;

  ItemRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Item>>> getItems() async {
    try {
      final remoteItems = await remoteDataSource.getItems();
      return Right(remoteItems);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<LocalItem>>> getSavedItems() async {
    try {
      final localItems = await localDataSource.getSavedItems();
      return Right(localItems);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveItem(LocalItem item) async {
    try {
      await localDataSource.saveItem(LocalItemModel.fromEntity(item));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(String id) async {
    try {
      await localDataSource.deleteItem(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
