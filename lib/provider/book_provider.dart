import 'package:flutter/material.dart';

class BookProvider with ChangeNotifier {
  bool _isB2BSelected = true;
  bool _selectAll = false;
  List<bool> _selectedProducts = List<bool>.generate(10, (index) => false);

  bool get isB2BSelected => _isB2BSelected;
  bool get selectAll => _selectAll;
  List<bool> get selectedProducts => _selectedProducts;

  int get selectedCount =>
      _selectedProducts.where((isSelected) => isSelected).length;

  void toggleSelection(bool isB2B) {
    _isB2BSelected = isB2B;
    notifyListeners();
  }

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

  // For B2B products
  List<bool> selectedB2BProducts = List.generate(10, (_) => false);
  bool selectAllB2B = false;
  int get selectedB2BCount => selectedB2BProducts.where((p) => p).length;

  // For B2C products
  List<bool> selectedB2CProducts = List.generate(10, (_) => false);
  bool selectAllB2C = false;
  int get selectedB2CCount => selectedB2CProducts.where((p) => p).length;

  // B2B Selection logic
  void toggleSelectAllB2B(bool selectAll) {
    selectAllB2B = selectAll;
    for (int i = 0; i < selectedB2BProducts.length; i++) {
      selectedB2BProducts[i] = selectAll;
    }
    notifyListeners();
  }

  void toggleProductSelectionB2B(int index, bool selected) {
    selectedB2BProducts[index] = selected;
    // If any product is deselected, uncheck "Select All"
    if (!selected) {
      selectAllB2B = false;
    } else if (selectedB2BProducts.every((product) => product)) {
      // If all products are selected, check the "Select All"
      selectAllB2B = true;
    }
    notifyListeners();
  }

  // B2C Selection logic
  void toggleSelectAllB2C(bool selectAll) {
    selectAllB2C = selectAll;
    for (int i = 0; i < selectedB2CProducts.length; i++) {
      selectedB2CProducts[i] = selectAll;
    }
    notifyListeners();
  }

  void toggleProductSelectionB2C(int index, bool selected) {
    selectedB2CProducts[index] = selected;
    // If any product is deselected, uncheck "Select All"
    if (!selected) {
      selectAllB2C = false;
    } else if (selectedB2CProducts.every((product) => product)) {
      // If all products are selected, check the "Select All"
      selectAllB2C = true;
    }
    notifyListeners();
  }
}
