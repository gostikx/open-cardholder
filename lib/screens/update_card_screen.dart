import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_cardholder/models/card_model.dart';
import 'package:open_cardholder/providers/database_provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:open_cardholder/widgets/barcode_type_dropdown.dart';
import 'package:open_cardholder/widgets/color_picker.dart';

class UpdateCardScreen extends ConsumerStatefulWidget {
  final int cardId;

  const UpdateCardScreen({super.key, required this.cardId});

  @override
  ConsumerState<UpdateCardScreen> createState() => _UpdateCardScreenState();
}

class _UpdateCardScreenState extends ConsumerState<UpdateCardScreen> {
  late TextEditingController titleController;
  late TextEditingController codeController;
  late BarcodeType _selectedType;
  late Color _selectedColor;
  CardModel? _currentCard;

  @override
  void initState() {
    super.initState();
    // Initialize controllers and variables
    titleController = TextEditingController();
    codeController = TextEditingController();
    _selectedType = BarcodeType.Code128;
    _selectedColor = Colors.cyan[100]!;
  }

  @override
  void dispose() {
    titleController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(allCardsProvider);

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
      body: cardsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Error loading card: $error')),
        data: (cards) {
          final card = cards.firstWhere(
            (c) => c.id == widget.cardId,
            orElse: () => cardEmpty,
          );

          // Only update state if we have a different card or first load
          if (_currentCard == null || _currentCard!.id != card.id) {
            _currentCard = card;
            titleController.text = card.title;
            codeController.text = card.code;
            _selectedType = card.getBarcodeType();
            _selectedColor = card.getCoverColor();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card cover
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: EdgeInsets.all(16.0),
                height: 120.0,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  // image: DecorationImage(
                  //   image: NetworkImage(card.logo!),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                child: Stack(
                  children: [
                    // Text field
                    TextField(
                      controller: titleController,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        // letterSpacing: 1.5,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Card Name',
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      cursorColor: Colors.black,
                      textAlign: TextAlign.left,
                    ),
                    // Buttons in bottom right corner
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ColorPickerWidget(
                            currentColor: _selectedColor,
                            onColorChanged: (Color color) {
                              print('Color changed to: $color');
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                            onColorPicked: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Color changed')),
                              );
                            },
                          ),
                          // Image picker button
                          IconButton(
                            icon: const Icon(Icons.image, color: Colors.black),
                            onPressed: () {
                              // _pickImage();
                            },
                            tooltip: 'Upload image',
                          ),
                        ],
                      ),
                    ),
                  ],
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
              const SizedBox(height: 16),
              // Dropdown for barcode type
              BarcodeTypeDropdown(
                value: _selectedType,
                onChanged: (BarcodeType? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final updatedCard = CardModel(
                    id: card.id,
                    title: titleController.text,
                    code: codeController.text,
                    type: _selectedType.toString(),
                    coverColor: _selectedColor.toARGB32(),
                  );
                  print(updatedCard.toJson());

                  ref.read(updateCardNotifierProvider).updateCard(updatedCard);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Card updated successfully')),
                  );
                  GoRouter.of(context).pop();
                },
                child: const Text('Update Card'),
              ),
            ],
          );
        },
      ),
    );
  }
}
