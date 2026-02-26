import 'package:flutter/material.dart';
import 'package:open_cardholder/models/card_model.dart';
import 'package:open_cardholder/widgets/LeadingWidget.dart';

class CardPanel extends StatelessWidget {
  const CardPanel({super.key, required this.card});

  final CardModel card;

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget;

    if (card.logo != null && card.logo!.isNotEmpty) {
      leadingWidget = Container(
        height: 80.0,
        width: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(card.logo!),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      leadingWidget = LeadingWidget(title: card.title);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
          leading: leadingWidget,
          title: Text(
            card.title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.black38,
            size: 24.0,
          ),
        ),
      ),
    );
  }
}
