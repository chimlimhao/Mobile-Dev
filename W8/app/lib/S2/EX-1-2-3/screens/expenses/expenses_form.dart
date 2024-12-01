import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/expense.dart';
import 'package:intl/intl.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key, required this.onCreated});

  final Function(Expense) onCreated;

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();

  Category? _selectedCategory = Category.food;

  DateTime? _selectedDate;

  String get title => _titleController.text;

  @override
  void dispose() {
    _titleController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void onCancel() {
    // Close modal
    Navigator.pop(context);
  }

  void onAdd() {
    // 1- Get the values from inputs
    String title = _titleController.text;
    double amount = double.parse(_valueController.text);

    // 2- Create the expense
    Expense expense = Expense(
        title: title,
        amount: amount,
        date: _selectedDate ?? DateTime.now(),
        category: _selectedCategory!);

    // 3- Ask the parent to add the expense
    widget.onCreated(expense);

    // 4- Close modal
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            controller: _valueController,
            maxLength: 50,
            decoration: const InputDecoration(
              prefix: Text('\$ '),
              label: Text('Amount'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 200,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton<Category>(
                  isExpanded: true,
                  value: _selectedCategory,
                  items: Category.values.map((Category category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category
                          .toString()
                          .split('.')
                          .last
                          .toUpperCase()), // Display in uppercase
                    );
                  }).toList(),
                  onChanged: (Category? newValue) {
                    setState(() {
                      _selectedCategory =
                          newValue; // Update the selected category
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                // alignment: Alignment.center,
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : DateFormat.yMd().format(_selectedDate!),
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: onCancel, child: const Text('Cancel')),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(onPressed: onAdd, child: const Text('Create')),
            ],
          )
        ],
      ),
    );
  }
}
