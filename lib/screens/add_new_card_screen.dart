import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_cardholder/providers/database_provider.dart';

class CreateNewCard extends ConsumerStatefulWidget {
  const CreateNewCard({super.key});

  @override
  ConsumerState<CreateNewCard> createState() => _CreateNewCardState();
}

class _CreateNewCardState extends ConsumerState<CreateNewCard> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addCardAsync = ref.watch(addCardProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add New Card'),
      ),
      body: Column(
        children: <Widget>[
          // Text field at the top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Card Name',
                hintText: 'Enter card name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Handle text changes if needed
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Card Code',
                hintText: 'Enter card code',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Handle text changes if needed
              },
            ),
          ),

          // Spacer to push button to the bottom
          const Spacer(),

          // Button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: addCardAsync.isLoading
                  ? null
                  : () {
                      final String cardName = _textController.text.trim();
                      final String code = _codeController.text.trim();

                      if (cardName.isNotEmpty) {
                        // Save the card using Riverpod
                        final notifier = ref.read(addCardNotifierProvider);
                        notifier
                            .addCard(
                              title: cardName,
                              description: 'Card description',
                              code: code,
                              logo: null,
                            )
                            .then((_) {
                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Card "$cardName" saved'),
                                ),
                              );

                              // Clear the text field
                              _textController.clear();

                              // Refresh the cards list
                              ref.invalidate(allCardsProvider);

                              // Navigate back
                              Navigator.pop(context);
                            })
                            .catchError((error) {
                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error saving card: $error'),
                                ),
                              );
                            });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a card name'),
                          ),
                        );
                      }
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
              child: addCardAsync.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save Card', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
