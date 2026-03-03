import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opencardholder/models/card_model.dart';
import 'package:opencardholder/providers/database_provider.dart';
import 'package:opencardholder/screens/error_screen.dart';
import 'package:opencardholder/widgets/CardDetail.dart';
import 'package:opencardholder/widgets/card_detail/confirm_dialog.dart';

class CardDetailScreen extends ConsumerWidget {
  final int cardId;

  const CardDetailScreen({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsProvider = ref.watch(allCardsProvider);

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
      ),
      body: cardsProvider.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, trace) => ErrorScreen(error: err, stackTrace: trace),
        data: (cards) {
          final card = cards.firstWhere(
            (c) => c.id == cardId,
            orElse: () => cardEmpty,
          );
          return Column(
            children: [
              CardDetail(card: card),

              Spacer(),

              TextButton(
                onPressed: () {
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
                  print('deleted card: ${cardToDelete?.toJson()}');
                  if (cardToDelete != null) {
                    // _showDeleteConfirmationDialog(context, cardToDelete, ref);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDialog(
                          cardTitle: cardToDelete.title,
                          onPressed: () {
                            // Выполняем удаление
                            ref
                                .read(deleteCardNotifierProvider)
                                .deleteCard(cardToDelete.id);
                            Navigator.of(context).pop(); // Закрываем диалог
                            Navigator.of(
                              context,
                            ).pop(); // Возвращаемся на предыдущий экран
                          },
                        );
                      },
                    );
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue, // Цвет ссылки
                ),
                child: const Text(
                  'Delete card',
                  style: TextStyle(
                    decoration: TextDecoration.underline, // Подчеркивание
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsetsGeometry.only(
                  top: 0,
                  right: 16,
                  left: 16,
                  bottom: 16,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to update card screen
                    GoRouter.of(context).push('/update-card/$cardId');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Редактировать',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
