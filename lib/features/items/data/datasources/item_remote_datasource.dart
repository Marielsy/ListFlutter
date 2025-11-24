import 'package:dio/dio.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/item_model.dart';

abstract class ItemRemoteDataSource {
  Future<List<ItemModel>> getItems();
}

class ItemRemoteDataSourceImpl implements ItemRemoteDataSource {
  final Dio dio;

  ItemRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ItemModel>> getItems() async {
    try {
      final response = await dio.get(AppConstants.baseUrl + AppConstants.itemsEndpoint);
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((e) => ItemModel.fromJson(e)).toList();
      } else {
        throw ServerException('Failed to load items');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
