import 'package:flutter/material.dart';
import 'package:opencardholder/models/card_model.dart';

class CardPanel extends StatelessWidget {
  const CardPanel({super.key, required this.card});

  final CardModel card;

  @override
  Widget build(BuildContext context) {
    // print(card.toJson());
    int colorInt = Colors.grey[100]!.toARGB32();
    if (card.coverColor != null && card.coverColor.runtimeType == int) {
      colorInt = card.coverColor!;
    }
    Color color = Color(colorInt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.withAlpha(51), width: 1.0),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          // leading: leadingWidget,
          title: Text(
            card.title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
