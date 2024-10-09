import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final String hint;
  final ValueChanged<T?> onChanged;
  final TextStyle? hintStyle;
  final TextStyle? itemStyle;
  final Color dropdownColor; // Ensure this is set
  final Color borderColor;
  final double borderWidth;
  final double elevation;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.hint,
    required this.onChanged,
    this.hintStyle,
    this.itemStyle,
    this.dropdownColor = Colors.white,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.elevation = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dropdownColor, // Ensure solid color
      child: DropdownButton<T>(
        value: selectedItem,
        hint: Text(hint, style: hintStyle),
        items: items.map((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(
              value.toString(),
              style: itemStyle,
            ),
          );
        }).toList(),
        onChanged: onChanged,
        dropdownColor: dropdownColor, // Set dropdown color
        elevation: elevation.toInt(), // Adjust elevation if needed
        underline: Container(
          height: borderWidth,
          color: borderColor,
        ),
        style: itemStyle,
      ),
    );
  }
}
