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
          border: Border.all(
            color: Colors.grey.withAlpha(51),
            width: 1.0,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          leading: leadingWidget,
          title: Text(
            cardTitle,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            cardDescription,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
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
