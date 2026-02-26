import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_cardholder/models/card_model.dart';
import 'package:open_cardholder/providers/database_provider.dart';
import 'package:open_cardholder/widgets/LeadingWidget.dart';
import 'package:barcode_widget/barcode_widget.dart';

class CardDetailHeader extends StatelessWidget {
  const CardDetailHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
      child: Row(
        children: [
          LeadingWidget(title: title, containerSize: 30, fontSize: 18),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardDetailScreen extends ConsumerWidget {
  final int cardId;

  const CardDetailScreen({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref
        .watch(allCardsProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Error loading card: $error')),
          data: (cards) {
            final card = cards.firstWhere(
              (c) => c.id == cardId,
              orElse: () =>
                  CardModel(id: 0, title: '', description: '', code: ''),
            );
            if (card.title.isEmpty) {
              return Center(child: Text('Card not found'));
            }
            print(card.toJson());
            return _buildCardDetails(context, card, ref);
          },
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
                        loading: () => null,
                        error: (_, __) => null,
                        data: (cards) => cards.firstWhere(
                          (c) => c.id == cardId,
                          orElse: () => CardModel(
                            id: 0,
                            title: '',
                            description: '',
                            code: '',
                          ),
                        ),
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

  Widget _buildCardDetails(
    BuildContext context,
    CardModel card,
    WidgetRef ref,
  ) {
    return Card(
      margin: EdgeInsets.all(25),
      child: Column(
        children: [
          CardDetailHeader(title: card.title),
          Divider(
            color: Colors.grey,
            height: 5, // The height of the box containing the divider
            thickness: 1, // The thickness of the line itself
            indent: 10, // Empty space at the start of the line
            endIndent: 10, // Empty space at the end of the line
          ),
          Text(
            card.description,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          BarcodeWidget(
            barcode: Barcode.qrCode(
              errorCorrectLevel: BarcodeQRCorrectionLevel.high,
            ),
            data: 'https://pub.dev/packages/barcode_widget',
            width: 200,
            height: 200,
          ),
          Text(
            card.code.isNotEmpty ? card.code : '7005 0006 5605 8062',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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
                ref.invalidate(allCardsProvider);
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
