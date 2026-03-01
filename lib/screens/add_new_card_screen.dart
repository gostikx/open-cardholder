import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_cardholder/providers/database_provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:open_cardholder/widgets/form/barcode_type_dropdown.dart';
import 'package:open_cardholder/widgets/form/cover_card.dart';
import 'package:open_cardholder/widgets/form/text_form_field.dart' as CustomWidgets;

class CreateNewCard extends ConsumerStatefulWidget {
  const CreateNewCard({super.key});

  @override
  ConsumerState<CreateNewCard> createState() => _CreateNewCardState();
}

class _CreateNewCardState extends ConsumerState<CreateNewCard> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  BarcodeType _selectedType = BarcodeType.Code128;
  Color? _selectedColor = Colors.cyan[100];

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
          CardCover(
            titleField: TextField(
              controller: _textController,
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

          CustomWidgets.TextFormField(
            controller: _codeController,
            label: 'Card Code',
            hint: 'Enter card code',
            suffixIcon: InkWell(
              child: Icon(Icons.linked_camera),
              onTap: () async {
                final result = await GoRouter.of(context).push('/scan-card');
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

          BarcodeTypeDropdown(
            value: _selectedType,
            onChanged: (BarcodeType? newValue) {
              setState(() {
                _selectedType = newValue!;
              });
            },
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
                              code: code,
                              type: _selectedType.toString(),
                              coverColor:
                                  _selectedColor?.toARGB32() ??
                                  Colors.grey[100]!.toARGB32(),
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
