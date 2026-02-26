import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:barcode_widget/barcode_widget.dart';

part 'card_model.g.dart';

final CardModel cardEmpty = CardModel(id: -1, title: '', code: '', type: '');

@collection
class CardModel {
  int id;
  String? coverImage;
  int? coverColor;
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
    this.coverImage,
    this.coverColor,
  });

  // Метод возвращает Map со всеми полями
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'cover_image': coverImage,
    'cover_color': coverColor,
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

  Color getCoverColor() {
    int colorInt = Colors.grey[100]!.toARGB32();
    if (coverColor != null && coverColor.runtimeType == int) {
      colorInt = coverColor!;
    }
    return Color(colorInt);
  }
}
