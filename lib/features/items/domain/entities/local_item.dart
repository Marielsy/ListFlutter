import 'package:equatable/equatable.dart';

class LocalItem extends Equatable {
  final String id;
  final String apiItemName;
  final String customName;
  final String imageUrl;

  const LocalItem({
    required this.id,
    required this.apiItemName,
    required this.customName,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, apiItemName, customName, imageUrl];
}
