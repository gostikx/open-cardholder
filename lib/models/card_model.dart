import 'package:isar/isar.dart';

part 'card_model.g.dart';

@collection
class CardModel {
  int id;
  String title;
  String description;
  String? logo;

  CardModel({
    required this.id,
    required this.title,
    required this.description,
    this.logo,
  });
}
