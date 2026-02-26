import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_cardholder/models/card_model.dart';
import 'package:open_cardholder/providers/database_provider.dart';

class UpdateCardScreen extends ConsumerWidget {
  final int cardId;

  const UpdateCardScreen({super.key, required this.cardId});

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
            return _buildUpdateForm(context, card, ref);
          },
        );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Update Card'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: cardAsync,
    );
  }

  Widget _buildUpdateForm(
    BuildContext context,
    CardModel card,
    WidgetRef ref,
  ) {
    final TextEditingController titleController = TextEditingController(text: card.title);
    final TextEditingController descriptionController = TextEditingController(text: card.description);
    final TextEditingController codeController = TextEditingController(text: card.code);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Card Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Card Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: codeController,
            decoration: const InputDecoration(
              labelText: 'Card Code',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final updatedCard = CardModel(
                id: card.id,
                title: titleController.text,
                description: descriptionController.text,
                code: codeController.text,
                logo: card.logo,
              );
              
              ref.read(updateCardNotifierProvider).updateCard(updatedCard);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Card updated successfully')),
              );
              GoRouter.of(context).pop();
            },
            child: const Text('Update Card'),
          ),
        ],
      ),
    );
  }
}
