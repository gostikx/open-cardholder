import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_cardholder/providers/database_provider.dart';
import 'package:open_cardholder/widgets/CardPanel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsAsync = ref.watch(allCardsProvider);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Open Cardholder'),
      ),
      body: cardsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error loading cards: $error'),
        ),
        data: (cards) => cards.isEmpty
          ? const Center(child: Text('No cards yet. Add your first card!'))
          : ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return CardPanel(
                  cardLogo: card.logo ?? '',
                  cardTitle: card.title,
                  cardDescription: card.description,
                );
              },
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).push('/add-new-card');
        },
        tooltip: 'Add new card',
        child: const Icon(Icons.add),
      ),
    );
  }
}
