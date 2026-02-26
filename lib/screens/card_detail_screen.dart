import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_cardholder/models/card_model.dart';
import 'package:open_cardholder/providers/database_provider.dart';
import 'package:open_cardholder/widgets/CardDetail.dart';

class CardDetailScreen extends ConsumerWidget {
  final int cardId;

  const CardDetailScreen({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref
        .watch(allCardsProvider)
        .when(
          data: (cards) {
            final card = cards.firstWhere(
              (c) => c.id == cardId,
              orElse: () => cardEmpty,
            );
            if (card.title.isEmpty) {
              return Center(child: Text('Card not found'));
            }
            return CardDetail(card: card);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Error loading card: $error')),
        );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Card Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: const Text('Редактировать'),
                onTap: () {
                  // Navigate to update card screen
                  GoRouter.of(context).push('/update-card/$cardId');
                },
              ),
              PopupMenuItem(
                value: 'delete',
                child: const Text('Удалить'),
                onTap: () {
                  // We need to get the card again for the delete action
                  final cardToDelete = ref
                      .read(allCardsProvider)
                      .when(
                        data: (cards) => cards.firstWhere(
                          (c) => c.id == cardId,
                          orElse: () => cardEmpty,
                        ),
                        loading: () => null,
                        error: (_, __) => null,
                      );
                  print(cardToDelete?.toJson());
                  if (cardToDelete != null) {
                    _showDeleteConfirmationDialog(context, cardToDelete, ref);
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: cardAsync,
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    CardModel card,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: Text(
            'Вы уверены, что хотите удалить карту "${card.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрываем диалог
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                // Выполняем удаление
                ref.read(deleteCardNotifierProvider).deleteCard(card.id);
                Navigator.of(context).pop(); // Закрываем диалог
                Navigator.of(context).pop(); // Возвращаемся на предыдущий экран
              },
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
