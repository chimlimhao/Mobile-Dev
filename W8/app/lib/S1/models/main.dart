import 'package:flutter/material.dart';
import 'expense.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  final List<Expense> _registeredExpense = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ronan-Best-Teacher'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseList({required this.expenses, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return;
      },
    );
  }
}

class ExpenseItem extends StatelessWidget {
  final List<Expense> expense;
  const ExpenseItem({required this.expense, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile();
  }
}
