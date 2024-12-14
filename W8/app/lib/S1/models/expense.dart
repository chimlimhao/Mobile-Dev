import 'package:uuid/uuid.dart';

enum ExpenseType { food, travel, lesure, work }

const Uuid uuid = Uuid();

class Expense {
  final String id;
  final String title;
  final double price;
  final DateTime date;

  Expense({required this.title, required this.price, required this.date})
      : id = uuid.v4();
}
