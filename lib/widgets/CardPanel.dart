import 'package:flutter/material.dart';

class CardPanel extends StatelessWidget {
  const CardPanel({
    super.key,
    required this.cardLogo,
    required this.cardTitle,
    required this.cardDescription,
  });

  final String cardLogo;
  final String cardTitle;
  final String cardDescription;

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget;

    // Common circular container properties
    const double containerSize = 80.0;
    const Color backgroundColor = Colors.blue;
    const double fontSize = 28.0;

    if (cardLogo.isNotEmpty) {
      leadingWidget = Container(
        height: containerSize,
        width: containerSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(cardLogo),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      // Extract first letters from cardTitle
      String initials = '';
      if (cardTitle.isNotEmpty) {
        final words = cardTitle.split(' ');
        for (final word in words) {
          if (word.isNotEmpty) {
            initials += word[0].toUpperCase();
          }
        }
      }

      leadingWidget = Container(
        height: containerSize,
        width: containerSize,
        decoration: const BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            initials.isNotEmpty ? initials : '?',
            style: const TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 8.0, horizontal: 22.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
          side: const BorderSide(color: Colors.grey, width: 1.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        tileColor: Colors.blue[100],
        leading: leadingWidget,
        title: Text(cardTitle),
        subtitle: Text(cardDescription),
      ),
    );
  }
}
