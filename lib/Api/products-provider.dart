import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  int _countVariationField = 1;
  String _selectedProductCategory='Create Simple Product';
  List<TextEditingController> _colors = [TextEditingController()];
  List<TextEditingController> _sizes = [TextEditingController()];
  List<TextEditingController> _eanUpcs = [TextEditingController()];
  List<TextEditingController> _skus = [TextEditingController()];

  // Getters
  List<TextEditingController> get color => _colors;
  List<TextEditingController> get size => _sizes;
  List<TextEditingController> get eanUpc=> _eanUpcs;
  List<TextEditingController> get sku => _skus;

  String get selectedProductCategory =>_selectedProductCategory;
  int get countVariationFields => _countVariationField;

  // Adding a new set of controllers
  void addNewTextEditingController() {
    _colors.add(TextEditingController());
    _sizes.add(TextEditingController());
    _eanUpcs.add(TextEditingController());
    _skus.add(TextEditingController());
    _countVariationField++;
    print("heelo is ahere${_countVariationField}");
    notifyListeners();
  }

  void updateSelectedProductCategory(String val){
    _selectedProductCategory=val;
    notifyListeners();
  }

  // Deleting the last set of controllers
  void deleteTextEditingController() {
    if (_countVariationField > 1) {
      _colors.last.dispose();
      _sizes.last.dispose();
      _eanUpcs.last.dispose();
      _skus.last.dispose();

      _colors.removeLast();
      _sizes.removeLast();
      _eanUpcs.removeLast();
      _skus.removeLast();

      _countVariationField--;
      print("heelo is ahere${_countVariationField}");
      notifyListeners();
    }
  }

  @override
  void dispose() {
    for (var controller in _colors) {
      controller.dispose();
    }
    for (var controller in _sizes) {
      controller.dispose();
    }
    for (var controller in _eanUpcs) {
      controller.dispose();
    }
    for (var controller in _skus) {
      controller.dispose();
    }
    super.dispose();
  }
}
