import 'package:flutter/material.dart';
import 'package:opencardholder/models/card_model.dart';
import 'package:opencardholder/widgets/card_detail/barcode.dart';
import 'package:screen_brightness/screen_brightness.dart';

const gradientColors = <List<Color>>[
  [Color(0xFF8B4513), Color(0xFFDAA520), Color(0xFFFFD700)],
  [Color(0xFF1A3A2F), Color(0xFF4CAF50), Color(0xFF2196F3)],
  [Color(0xFF2D1B4E), Color(0xFF8E24AA), Color(0xFFE91E63)],
];

class CardDetailHeader extends StatelessWidget {
  const CardDetailHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
      child: Row(
        children: [
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

class CardDetail extends StatefulWidget {
  const CardDetail({super.key, required this.card});

  final CardModel card;

  @override
  State<CardDetail> createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  Future<void> _restoreBrightness() async {
    try {
      await ScreenBrightness().resetApplicationScreenBrightness();
    } catch (e) {
      debugPrint('Error restoring brightness: $e');
    }
  }

  void _showFullScreenCard(BuildContext context) {
    // Set brightness immediately before showing bottom sheet
    ScreenBrightness().setApplicationScreenBrightness(1.0).ignore();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PopScope(
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            if (didPop) {
              await _restoreBrightness();
            }
          },
          child: GestureDetector(
            onTap: () {
              _restoreBrightness();
              Navigator.of(context).pop();
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withAlpha(230),
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: _FullScreenCardView(card: widget.card),
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      _restoreBrightness();
    });
  }

  @override
  Widget build(BuildContext context) {
    int colorInt = Colors.grey[100]!.toARGB32();
    if (widget.card.coverColor != null &&
        widget.card.coverColor.runtimeType == int) {
      colorInt = widget.card.coverColor!;
    }
    Color color = Color(colorInt);

    int indexGradientColor = widget.card.id % 3;
    return GestureDetector(
      onTap: () => _showFullScreenCard(context),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors[indexGradientColor],
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
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
            children: [
              CardDetailHeader(title: widget.card.title),
              const Divider(color: Colors.grey, height: 5, thickness: 1),
              Padding(
                padding: EdgeInsetsGeometry.only(top: 20.0),
                child: BarcodeCard(
                  data: widget.card.code,
                  barcodeType: widget.card.getBarcode(),
                ),
              ),
              Text(
                widget.card.code.isNotEmpty ? widget.card.code : 'Unknown code',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FullScreenCardView extends StatelessWidget {
  final CardModel card;

  const _FullScreenCardView({required this.card});

  @override
  Widget build(BuildContext context) {
    int indexGradientColor = card.id % 3;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors[indexGradientColor],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(100),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            card.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: BarcodeCard(data: card.code, barcodeType: card.getBarcode()),
          ),
          const SizedBox(height: 24),
          Text(
            card.code.isNotEmpty ? card.code : 'Unknown code',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tap anywhere to close',
            style: TextStyle(color: Colors.black.withAlpha(150), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
