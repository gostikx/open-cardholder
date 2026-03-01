import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_cardholder/models/card_model.dart';
import 'package:open_cardholder/providers/database_provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:open_cardholder/widgets/form/barcode_type_dropdown.dart';
import 'package:open_cardholder/widgets/form/cover_card.dart';
import 'package:open_cardholder/widgets/form/text_form_field.dart' as CustomWidgets;

class UpdateCardScreen extends ConsumerStatefulWidget {
  final int cardId;

  const UpdateCardScreen({super.key, required this.cardId});

  @override
  ConsumerState<UpdateCardScreen> createState() => _UpdateCardScreenState();
}

class _UpdateCardScreenState extends ConsumerState<UpdateCardScreen> {
  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _codeController = TextEditingController();

  late BarcodeType _selectedType;
  late Color _selectedColor;
  CardModel? _currentCard;

  @override
  void initState() {
    super.initState();
    // Initialize controllers and variables
    _titleController = TextEditingController();
    _codeController = TextEditingController();
    _selectedType = BarcodeType.Code128;
    _selectedColor = Colors.cyan[100]!;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
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
            _titleController.text = card.title;
            _codeController.text = card.code;
            _selectedType = card.getBarcodeType();
            _selectedColor = card.getCoverColor();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardCover(
                currentCoverColor: card.getCoverColor(),
                titleField: TextField(
                  controller: _titleController,
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
              ),

              const SizedBox(height: 16),
              CustomWidgets.TextFormField(
                controller: _codeController,
                label: 'Card Code',
                hint: 'Enter card code',
                suffixIcon: InkWell(
                  child: Icon(Icons.linked_camera),
                  onTap: () async {
                    final result = await GoRouter.of(
                      context,
                    ).push('/scan-card');
                    if (result != null && result is Map) {
                      final String code = result['code'] as String;
                      final BarcodeType type = result['type'] as BarcodeType;

                      setState(() {
                        _codeController.text = code;
                        _selectedType = type;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Code imported: $code')),
                      );
                    }
                  },
                ),
                change: (value) {},
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
                    title: _titleController.text,
                    code: _codeController.text,
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
