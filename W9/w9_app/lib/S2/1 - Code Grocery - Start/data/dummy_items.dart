import '../models/grocery_category.dart';
import '../models/grocery_item.dart';
import 'package:uuid/uuid.dart';

final uuid = const Uuid();

final dummyGroceryItems = [
  GroceryItem(
      id: uuid.v4(),
      name: 'Milk',
      quantity: 1,
      category: GroceryCategory.dairy),
  GroceryItem(
      id: uuid.v4(),
      name: 'Bananas',
      quantity: 5,
      category: GroceryCategory.fruit),
  GroceryItem(
      id: uuid.v4(),
      name: 'Beef Steak',
      quantity: 1,
      category: GroceryCategory.meat),
];
