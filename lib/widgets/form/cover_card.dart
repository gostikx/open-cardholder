import 'package:flutter/material.dart';
import 'package:open_cardholder/widgets/color_picker.dart';
// import 'package:image_picker/image_picker.dart';

class CardCover extends StatefulWidget {
  const CardCover({
    super.key,
    required this.titleField,
    this.currentCoverColor,
  });

  final TextField titleField;
  final Color? currentCoverColor;

  @override
  State<CardCover> createState() => _CardCoverState();
}

class _CardCoverState extends State<CardCover> {
  Color? coverColor = Colors.cyan[100];

  @override
  void initState() {
    super.initState();
    if (widget.currentCoverColor != null) {
      coverColor = widget.currentCoverColor;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Method to pick image from device
  // Future<void> _pickImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  //   if (image != null) {
  //     // TODO: Handle the selected image
  //     // For now, just show a snackbar
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Image selected: ${image.name}')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      height: 120.0,
      decoration: BoxDecoration(
        color: coverColor,
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
          widget.titleField,

          // Buttons in bottom right corner
          Positioned(
            bottom: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ColorPickerWidget(
                  currentColor: coverColor ?? Colors.cyan[100]!,
                  onColorChanged: (Color color) {
                    setState(() {
                      coverColor = color;
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
    );
  }
}
