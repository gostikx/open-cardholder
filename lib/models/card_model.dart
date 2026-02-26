import 'package:isar/isar.dart';
import 'package:barcode_widget/barcode_widget.dart';

part 'card_model.g.dart';

final CardModel cardEmpty = CardModel(
  id: -1,
  title: '',
  code: '',
  type: '',
);

@collection
class CardModel {
  int id;
  String? logo;
  String title;
  String code;
  String type;

  CardModel({
    required this.id,
    required this.title,
    required this.code,
    required this.type,
    this.logo,
  });

  // Метод возвращает Map со всеми полями
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'code': code,
    'type': type,
    'logo': logo,
  };

  BarcodeType getBarcodeType() {
    try {
      return BarcodeType.values.firstWhere(
        (barcodeType) => barcodeType.toString() == type,
        orElse: () => BarcodeType.Code128,
      );
    } catch (e) {
      return BarcodeType.Code128;
    }
  }

  Barcode getBarcode() {
    final barcodeType = getBarcodeType();
    return Barcode.fromType(barcodeType);
  }
}
