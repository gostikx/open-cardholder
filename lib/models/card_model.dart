import 'package:isar/isar.dart';

part 'card_model.g.dart';

@collection
class CardModel {
  int id;
  String? logo;
  String title;
  String description;
  String code;

  CardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    this.logo,
  });
}
