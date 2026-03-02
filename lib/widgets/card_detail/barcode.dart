import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class BarcodeCard extends StatelessWidget {
  final String data;
  final Barcode barcodeType;

  const BarcodeCard({super.key, required this.data, required this.barcodeType});

  @override
  Widget build(BuildContext context) {
    return BarcodeWidget(
      barcode: barcodeType,
      data: data,
      height: 150,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      drawText: false,
    );
  }
}
