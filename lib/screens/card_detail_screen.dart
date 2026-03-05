import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opencardholder/models/card_model.dart';
import 'package:opencardholder/providers/database_provider.dart';
import 'package:opencardholder/screens/error_screen.dart';
import 'package:opencardholder/widgets/button.dart';
import 'package:opencardholder/widgets/card_detail.dart';
import 'package:opencardholder/widgets/card_detail/confirm_dialog.dart';

class CardDetailScreen extends ConsumerWidget {
  final int cardId;

  const CardDetailScreen({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsProvider = ref.watch(allCardsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => GoRouter.of(context).pop(),
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
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        CardDetail(card: card),

                        const Spacer(),

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

                            if (cardToDelete != null) {
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
                          child: const Text('Удалить карту'),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Button(
                            child: const Text(
                              'Редактировать',
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () {
                              // Navigate to update card screen
                              GoRouter.of(context).push('/update-card/$cardId');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
