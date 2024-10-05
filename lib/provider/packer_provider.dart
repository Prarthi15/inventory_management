import 'package:flutter/material.dart';

class PackerProvider with ChangeNotifier {
  bool _selectAll = false;
  List<bool> _selectedProducts = List<bool>.generate(10, (index) => false);

  bool get selectAll => _selectAll;
  List<bool> get selectedProducts => _selectedProducts;

  int get selectedCount =>
      _selectedProducts.where((isSelected) => isSelected).length;

  void toggleSelectAll(bool value) {
    _selectAll = value;
    _selectedProducts =
        List<bool>.generate(_selectedProducts.length, (index) => _selectAll);
    notifyListeners();
  }

  void toggleProductSelection(int index, bool value) {
    _selectedProducts[index] = value;
    // If any product is deselected, uncheck the "Select All" box
    if (!_selectedProducts.contains(true)) {
      _selectAll = false;
    }
    notifyListeners();
  }
}
