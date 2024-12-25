import 'package:flutter/material.dart';
import '../data/dummy_items.dart';
import '../models/grocery_item.dart';
// import '../models/grocery_category.dart';
import 'new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  // int function(NewItem) getQuantity;
  final List<GroceryItem> _groceryItems = List.from(dummyGroceryItems);
  final Set<GroceryItem> _selectedItems = {};
  bool _isSelectionMode = false;

  void _addGroceryItem(GroceryItem item) {
    setState(() {
      // if (_groceryItems.contains(item)) {
      //   var qty = item.quantity + ;
      //   _groceryItems.add(item);
      // }
      _groceryItems.add(item);
    });
  }

  void _deleteGroceryItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  void _updateGroceryItem(GroceryItem item) {
    setState(() {
      final index = _groceryItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _groceryItems[index] = item;
      }
    });
  }

  void _onLongPress(GroceryItem item) {
    setState(() {
      // Enter selection mode if not already in it
      _isSelectionMode = true;
      // Add the long-pressed item to selected items
      _selectedItems.add(item);
    });
  }

  bool _isSelected(GroceryItem item) {
    return _selectedItems.contains(item);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _groceryItems.isNotEmpty
        ? ReorderableListView.builder(
            itemCount: _groceryItems.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = _groceryItems.removeAt(oldIndex);
                _groceryItems.insert(newIndex, item);
              });
            },
            itemBuilder: (context, index) {
              final item = _groceryItems[index];
              return ListTile(
                // key: Key('$index'),
                key: Key(item.id),
                title: Text(item.name),
                subtitle: Text('Quantity: ${item.quantity}'),
                leading: _isSelectionMode
                    ? Checkbox(
                        value: _isSelected(item),
                        onChanged: (selected) {
                          setState(() {
                            if (selected!) {
                              _selectedItems.add(item);
                            } else {
                              _selectedItems.remove(item);
                            }
                          });
                        },
                      )
                    : Icon(
                        Icons.square,
                        color: item.category.color,
                      ),
                // Add trailing widget for drag handle
                trailing: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle),
                ),
                onTap: _isSelectionMode
                    ? () {
                        setState(() {
                          if (_isSelected(item)) {
                            _selectedItems.remove(item);
                            // Exit selection mode if no items are selected
                            if (_selectedItems.isEmpty) {
                              _isSelectionMode = false;
                            }
                          } else {
                            _selectedItems.add(item);
                          }
                        });
                      }
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NewItem.edit(
                                onUpdateItem: _updateGroceryItem, item: item),
                          ),
                        );
                      },
                onLongPress: () {
                  _onLongPress(item);
                },
                tileColor: _isSelected(item)
                    ? Theme.of(context).primaryColor.withOpacity(0.2)
                    : null,
              );
            },
          )
        : const Center(child: Text('No items added yet.'));

    return Scaffold(
      appBar: AppBar(
        leading: _isSelectionMode
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isSelectionMode = false;
                    _selectedItems.clear();
                  });
                },
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: _isSelectionMode
            ? Text('${_selectedItems.length} selected')
            : const Text('Your Groceries'),
        actions: _isSelectionMode
            ? [
                IconButton(
                  onPressed: () {
                    setState(() {
                      for (final item in _selectedItems) {
                        _groceryItems.remove(item);
                      }
                      _selectedItems.clear();
                      _isSelectionMode = false;
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              ]
            : [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            NewItem.add(onAddItem: _addGroceryItem),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
      ),
      body: content,
    );
  }
}
