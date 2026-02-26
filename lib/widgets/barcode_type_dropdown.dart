import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart';

const allowedBarcodeTypes = <BarcodeType>[
  BarcodeType.Code128,
  BarcodeType.CodeEAN13,
  BarcodeType.QrCode,
  BarcodeType.DataMatrix,
  BarcodeType.PDF417,
];

class BarcodeTypeDropdown extends StatelessWidget {
  final BarcodeType? value;
  final ValueChanged<BarcodeType?>? onChanged;
  final InputDecoration? decoration;

  const BarcodeTypeDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<BarcodeType>(
      initialValue: value,
      decoration: decoration ?? const InputDecoration(
        labelText: 'Barcode Type',
        border: OutlineInputBorder(),
      ),
      items: BarcodeType.values
          .where((type) => allowedBarcodeTypes.contains(type))
          .map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.toString().split('.').last),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}