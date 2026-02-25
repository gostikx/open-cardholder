import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_cardholder/models/card_model.dart';
import 'package:open_cardholder/providers/database_provider.dart';

class CardDetailScreen extends ConsumerWidget {
  final int cardId;

  const CardDetailScreen({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref.watch(allCardsProvider).when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error loading card: $error'),
      ),
      data: (cards) {
        final card = cards.firstWhere((c) => c.id == cardId, orElse: () => CardModel(
          id: 0,
          title: '',
          description: '',
        ));
        if (card.title.isEmpty) {
          return Center(child: Text('Card not found'));
        }
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
      ),
      body: cardAsync,
    );
  }

  Widget _buildCardDetails(BuildContext context, CardModel card, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Logo (если есть)
          if (card.logo != null && card.logo!.isNotEmpty)
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  card.logo!,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          
          // Card Title
          Text(
            card.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Card Description
          Text(
            card.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Additional Info
          const Text(
            'Card Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              const Icon(Icons.info_outline, size: 18),
              const SizedBox(width: 8),
              Text('ID: ${card.id}'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Edit card functionality can be added here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit functionality coming soon')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Delete card functionality
                    final deleteNotifier = ref.read(deleteCardNotifierProvider);
                    
                    // Capture context values before async operation
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final goRouter = GoRouter.of(context);
                    
                    deleteNotifier.deleteCard(card.id).then((_) {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Card deleted')),
                      );
                      goRouter.pop();
                    }).catchError((error) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text('Error deleting card: $error')),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}