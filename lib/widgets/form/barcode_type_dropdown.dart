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

  static final _defaultInputDecoration = InputDecoration(
    labelText: 'Barcode Type',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blue),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
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
      ),
    );
  }
}
