import 'package:flutter/material.dart';
import 'package:open_cardholder/fake_data/fake_cards.dart';
import 'package:open_cardholder/widgets/CardPanel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Open Cardholder'),
      ),
      body: ListView.builder(
        itemCount: fakeCards.length,
        itemBuilder: (context, index) {
          return CardPanel(
            cardLogo: fakeCards[index].logo,
            cardTitle: fakeCards[index].title,
            cardDescription: fakeCards[index].description,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
    ;
  }
}
