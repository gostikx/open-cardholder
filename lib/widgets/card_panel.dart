import 'package:flutter/material.dart';
import 'package:opencardholder/models/card_model.dart';

const gradientColors = <List<Color>>[
  [Color(0xFF8B4513), Color(0xFFDAA520), Color(0xFFFFD700)],
  [Color(0xFF1A3A2F), Color(0xFF4CAF50), Color(0xFF2196F3)],
  [Color(0xFF2D1B4E), Color(0xFF8E24AA), Color(0xFFE91E63)],
];

class CardPanel extends StatelessWidget {
  const CardPanel({super.key, required this.card});

  final CardModel card;

  @override
  Widget build(BuildContext context) {
    int colorInt = Colors.grey[100]!.toARGB32();
    if (card.coverColor != null && card.coverColor.runtimeType == int) {
      colorInt = card.coverColor!;
    }
    Color color = Color(colorInt);

    int indexGradientColor = card.id % 3;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          // color: color,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                gradientColors[indexGradientColor],
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(13),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: color.withAlpha(51), width: 1.0),
        ),
        child: Stack(
          children: [
            // Background blur effect
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row with balance info and currency icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Currency icon
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Center(
                          child: Text(
                            '\u00A3',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Card number
                  Text(
                    card.code,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
