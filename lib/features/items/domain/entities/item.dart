import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String name;
  final String url;

  const Item({
    required this.name,
    required this.url,
  });

  @override
  List<Object?> get props => [name, url];
}
