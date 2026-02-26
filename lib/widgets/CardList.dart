import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_cardholder/models/card_model.dart';
import 'package:open_cardholder/widgets/CardPanel.dart';

class Cardlist extends StatelessWidget {
  const Cardlist({super.key, required this.cards});

  final List<CardModel> cards;

  @override
  Widget build(BuildContext context) {
    return cards.isEmpty
        ? const Center(child: Text('No cards yet. Add your first card!'))
        : ListView.builder(
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return InkWell(
                onTap: () =>
                    GoRouter.of(context).push('/card-detail/${card.id}'),
                child: CardPanel(card: card),
              );
            },
          );
  }
}
