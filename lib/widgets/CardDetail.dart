import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:open_cardholder/models/card_model.dart';
import 'package:open_cardholder/widgets/LeadingWidget.dart';

class CardDetailHeader extends StatelessWidget {
  const CardDetailHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
      child: Row(
        children: [
          LeadingWidget(title: title, containerSize: 30, fontSize: 18),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardDetail extends StatelessWidget {
  const CardDetail({super.key, required this.card});

  final CardModel card;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(25),
      child: Column(
        children: [
          CardDetailHeader(title: card.title),
          Divider(
            color: Colors.grey,
            height: 5, // The height of the box containing the divider
            thickness: 1, // The thickness of the line itself
            indent: 10, // Empty space at the start of the line
            endIndent: 10, // Empty space at the end of the line
          ),
          BarcodeWidget(
            barcode: card.getBarcode(),
            data: card.code,
            width: 200,
            height: 200,
            drawText: false,
          ),
          Text(
            card.code.isNotEmpty ? card.code : 'Unknown code',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}