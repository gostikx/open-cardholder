import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorChanged;
  final VoidCallback? onColorPicked;

  const ColorPickerWidget({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
    this.onColorPicked,
  });

  static Future<Color?> showColorPickerDialog({
    required BuildContext context,
    required Color initialColor,
  }) async {
    Color? selectedColor = initialColor;
    
    return showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: initialColor,
              onColorChanged: (Color color) {
                selectedColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedColor);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.color_lens, color: Colors.black),
      onPressed: () {
        showColorPickerDialog(
          context: context,
          initialColor: currentColor,
        ).then((Color? color) {
          if (color != null && color != currentColor) {
            onColorChanged(color);
            onColorPicked?.call();
          }
        });
      },
      tooltip: 'Choose color',
    );
  }
}
