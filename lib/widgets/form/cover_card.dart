import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CardCover extends StatefulWidget {
  const CardCover({
    super.key,
    required this.titleField,
    required this.codeField,
    required this.onColorChanged,
    this.currentCoverColor,
    this.onScanCode,
  });

  final TextField titleField;
  final TextField codeField;
  final Color? currentCoverColor;
  final void Function(Color) onColorChanged;
  final void Function()? onScanCode;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      height: 180.0,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: widget.titleField),
              IconButton(
                icon: const Icon(Icons.manage_search, color: Colors.black),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () {
                  // open bottomsheet
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            const Text(
                              'Выберите цвет',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16, width: double.infinity),
                            BlockPicker(
                              pickerColor: coverColor ?? Colors.cyan,
                              useInShowDialog: false,
                              onColorChanged: (Color color) {
                                setState(() {
                                  widget.onColorChanged(color);
                                  coverColor = color;
                                });
                                Navigator.of(context).pop(color);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                tooltip: 'Demo',
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: widget.codeField),
              IconButton(
                icon: const Icon(Icons.linked_camera),
                onPressed: widget.onScanCode,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
