import 'package:flutter/material.dart';

class GenericDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final String Function(T) nameSelector; // Function to get the display name
  final ValueChanged<T?> onChanged;

  const GenericDropdown({
    Key? key,
    required this.items, // List of generic items
    required this.nameSelector, // Function to get the display name for each item
    this.selectedItem, // The selected item
    required this.onChanged, // Callback when item is selected
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      hint: const Text('Select Item'),
      isExpanded: true,
      value: selectedItem,
      items: items.map<DropdownMenuItem<T>>((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(nameSelector(item)), // Use nameSelector to display the item name
        );
      }).toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Select Item',
        border: OutlineInputBorder(),
      ),
    );
  }
}
