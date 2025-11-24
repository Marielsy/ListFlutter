import 'package:hive/hive.dart';
import '../../domain/entities/local_item.dart';

part 'local_item_model.g.dart';

@HiveType(typeId: 0)
class LocalItemModel extends LocalItem {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String apiItemName;
  @HiveField(2)
  final String customName;
  @HiveField(3)
  final String imageUrl;

  const LocalItemModel({
    required this.id,
    required this.apiItemName,
    required this.customName,
    required this.imageUrl,
  }) : super(
          id: id,
          apiItemName: apiItemName,
          customName: customName,
          imageUrl: imageUrl,
        );

  factory LocalItemModel.fromEntity(LocalItem item) {
    return LocalItemModel(
      id: item.id,
      apiItemName: item.apiItemName,
      customName: item.customName,
      imageUrl: item.imageUrl,
    );
  }
}
