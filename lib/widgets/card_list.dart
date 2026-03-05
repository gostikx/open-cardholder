import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opencardholder/models/card_model.dart';
import 'package:opencardholder/widgets/card_panel.dart';

class Cardlist extends StatelessWidget {
  const Cardlist({
    super.key,
    required this.cards,
    this.scrollController,
  });

  final List<CardModel> cards;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return cards.isEmpty
        ? const Center(child: Text('No cards yet. Add your first card!'))
        : ListView.builder(
            controller: scrollController,
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
