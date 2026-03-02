import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String cardTitle;
  final void Function()? onPressed;

  const ConfirmDialog({
    super.key,
    required this.cardTitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Подтверждение удаления'),
      content: Text('Вы уверены, что хотите удалить карту "$cardTitle"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text('Удалить', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
