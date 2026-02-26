import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_cardholder/providers/database_provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:open_cardholder/widgets/barcode_type_dropdown.dart';
import 'package:open_cardholder/widgets/text_form_field.dart' as CustomWidgets;
import 'package:open_cardholder/widgets/color_picker.dart';
import 'package:image_picker/image_picker.dart';

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

  // Method to pick image from device
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // TODO: Handle the selected image
      // For now, just show a snackbar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Image selected: ${image.name}')));
    }
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
          // Card cover
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: EdgeInsets.all(16.0),
            height: 120.0,
            decoration: BoxDecoration(
              color: _selectedColor, // Colors.cyan[100],
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
                // Buttons in bottom right corner
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Color picker button
                      ColorPickerWidget(
                        currentColor: _selectedColor ?? Colors.cyan[100]!,
                        onColorChanged: (Color color) {
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
                          _pickImage();
                        },
                        tooltip: 'Upload image',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          CustomWidgets.TextFormField(
            controller: _codeController,
            label: 'Card Code',
            hint: 'Enter card code',
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
