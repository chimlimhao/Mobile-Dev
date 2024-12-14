import 'package:flutter/material.dart';
import '../models/grocery_category.dart';
import '../models/grocery_item.dart';
// import 'package:uuid/uuid.dart';
import '../data/dummy_items.dart';

enum GroceryFormType {
  add,
  edit,
}

class NewItem extends StatefulWidget {
  final Function(GroceryItem)? onAddItem; // Callback to add item
  final Function(GroceryItem)? onUpdateItem; // Callback to update item
  final GroceryItem? item;
  const NewItem.add({required this.onAddItem, super.key})
      : onUpdateItem = null,
        item = null;
  const NewItem.edit(
      {required this.onUpdateItem, required this.item, super.key})
      : onAddItem = null;

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _name = '';
  var _quantity = 1;
  var _category = GroceryCategory.vegetables;

  @override
  void initState() {
    super.initState();
    // Initialize fields if in edit mode
    if (widget.item != null) {
      _name = widget.item!.name;
      _quantity = widget.item!.quantity;
      _category = widget.item!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add a new item' : 'Edit item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                initialValue: _name, // Set initial value
                onSaved: (value) {
                  _name = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      // initialValue: '',
                      onSaved: (value) {
                        _quantity = int.tryParse(value ?? '1') ?? 1;
                      },
                      initialValue: _quantity.toString(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<GroceryCategory>(
                      value: _category,
                      items: [
                        for (final category in GroceryCategory.values)
                          DropdownMenuItem<GroceryCategory>(
                            value: category,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.label),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _category = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final groceryItem = GroceryItem(
                          id: widget.item?.id ??
                              uuid.v4(), // Use existing ID if editing
                          name: _name,
                          quantity: _quantity,
                          category: _category,
                        );

                        if (widget.item == null) {
                          widget.onAddItem!(groceryItem);
                        } else {
                          widget.onUpdateItem!(groceryItem);
                        }
                        Navigator.pop(context);
                      }
                    },
                    child:
                        Text(widget.item == null ? 'Add Item' : 'Update Item'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
