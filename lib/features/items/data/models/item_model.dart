import '../../domain/entities/item.dart';

class ItemModel extends Item {
  const ItemModel({
    required String name,
    required String url,
  }) : super(name: name, url: url);

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}
