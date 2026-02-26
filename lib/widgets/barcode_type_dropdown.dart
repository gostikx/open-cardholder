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

  static const _defaultInputDecoration = InputDecoration(
    labelText: 'Barcode Type',
    border: OutlineInputBorder(),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
      child: DropdownButtonFormField<BarcodeType>(
        initialValue: value,
        decoration: decoration ?? _defaultInputDecoration,
        items: BarcodeType.values
            .where((type) => allowedBarcodeTypes.contains(type))
            .map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.toString().split('.').last),
              );
            })
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
