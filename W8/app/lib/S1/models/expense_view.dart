import 'package:flutter/material.dart';
import 'expense.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  final List<Expense> _registeredExpenses = []; // List to hold expenses

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ronan-The-Best Expenses App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Logic to add a new expense
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(12)),
          child: const Text(
            "",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // ExpensesList(
        //   expenses: _registeredExpenses,
        // ),
      ),
    );
  }
}

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;

  const ExpensesList({required this.expenses, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return ExpenseItem(
            expense: expenses[index]); // Pass each expense to the item
      },
    );
  }
}

class ExpenseItem extends StatelessWidget {
  final Expense expense;

  const ExpenseItem({required this.expense, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(expense.title),
      subtitle: Text('\$${expense.price} - ${expense.date.toLocal()}'),
    );
  }
}
