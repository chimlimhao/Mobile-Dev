import 'package:flutter/material.dart';
import '../data/dummy_items.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dummyGroceryItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.square, color: ),
          title: Text(dummyGroceryItems[index].name),
          subtitle: Text(
              '${dummyGroceryItems[index].quantity} ${dummyGroceryItems[index].category.label}'),
        );
      },
    );
  }
}