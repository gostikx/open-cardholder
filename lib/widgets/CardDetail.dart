import 'package:flutter/material.dart';
import 'package:open_cardholder/models/card_model.dart';
import 'package:open_cardholder/widgets/card_detail/barcode.dart';

class CardDetailHeader extends StatelessWidget {
  const CardDetailHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
      child: Row(
        children: [
          // LeadingWidget(title: title, containerSize: 30, fontSize: 18),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
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
      child: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Column(
          children: [
            CardDetailHeader(title: card.title),
            Divider(color: Colors.grey[300], height: 5, thickness: 1),
            Padding(
              padding: EdgeInsetsGeometry.only(top: 20.0),
              child: BarcodeCard(
                data: card.code,
                barcodeType: card.getBarcode(),
              ),
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
      ),
    );
  }
}
