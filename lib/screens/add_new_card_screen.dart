import 'package:flutter/material.dart';

class CreateNewCard extends StatelessWidget {
  const CreateNewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Open Cardholder'),
      ),
      body: Text('add new card'),
    );
  }
}