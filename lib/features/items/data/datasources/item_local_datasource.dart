import 'package:hive/hive.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/local_item_model.dart';

abstract class ItemLocalDataSource {
  Future<List<LocalItemModel>> getSavedItems();
  Future<void> saveItem(LocalItemModel item);
  Future<void> deleteItem(String id);
}

class ItemLocalDataSourceImpl implements ItemLocalDataSource {
  final Box<LocalItemModel> box;

  ItemLocalDataSourceImpl({required this.box});

  @override
  Future<List<LocalItemModel>> getSavedItems() async {
    try {
      return box.values.toList();
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> saveItem(LocalItemModel item) async {
    try {
      await box.put(item.id, item);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    try {
      await box.delete(id);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
