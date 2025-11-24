import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'core/constants/constants.dart';
import 'features/items/data/datasources/item_local_datasource.dart';
import 'features/items/data/datasources/item_remote_datasource.dart';
import 'features/items/data/models/local_item_model.dart';
import 'features/items/data/repositories/item_repository_impl.dart';
import 'features/items/domain/repositories/item_repository.dart';
import 'features/items/domain/usecases/delete_item_usecase.dart';
import 'features/items/domain/usecases/get_items_usecase.dart';
import 'features/items/domain/usecases/get_saved_items_usecase.dart';
import 'features/items/domain/usecases/save_item_usecase.dart';
import 'features/items/presentation/cubit/api_cubit.dart';
import 'features/items/presentation/cubit/preference_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Features - Items
  // Cubit
  sl.registerFactory(() => ApiCubit(getItemsUseCase: sl()));
  sl.registerFactory(() => PreferenceCubit(
        getSavedItemsUseCase: sl(),
        saveItemUseCase: sl(),
        deleteItemUseCase: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => GetItemsUseCase(sl()));
  sl.registerLazySingleton(() => GetSavedItemsUseCase(sl()));
  sl.registerLazySingleton(() => SaveItemUseCase(sl()));
  sl.registerLazySingleton(() => DeleteItemUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ItemRepository>(
    () => ItemRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ItemRemoteDataSource>(
    () => ItemRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<ItemLocalDataSource>(
    () => ItemLocalDataSourceImpl(box: sl()),
  );

  // ! Core

  // ! External
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(LocalItemModelAdapter());
  final box = await Hive.openBox<LocalItemModel>(AppConstants.hiveBoxName);
  sl.registerLazySingleton(() => box);

  sl.registerLazySingleton(() => Dio());
}
