// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:inventory_management/Api/auth_provider.dart';
import 'package:inventory_management/Api/product-page-api.dart';

class ProductProvider with ChangeNotifier {
  int _countVariationField = 1;
  int _alertBoxFieldCount = 1;
  bool _isloading=false;
  String _selectedProductCategory='Create Simple Product';
  List<TextEditingController> _colors = [TextEditingController()];
  List<TextEditingController> _sizes = [TextEditingController()];
  List<TextEditingController> _eanUpcs = [TextEditingController()];
  List<TextEditingController> _skus = [TextEditingController()];
  List<TextEditingController> _alertBoxKeyEditingController = [TextEditingController()];
  List<TextEditingController> _alertBoxPairEditingController = [TextEditingController()];
  //list of values for all custom field
  List<Map<String, dynamic>> _cat=[];
  List<Map<String, dynamic>> _brand=[];
  List<Map<String, dynamic>> _technicalName=[];
  List<Map<String, dynamic>> _boxSize=[];

  // Getters
  List<TextEditingController> get color => _colors;
  List<TextEditingController> get size => _sizes;
  List<TextEditingController> get eanUpc=> _eanUpcs;
  List<TextEditingController> get sku => _skus;
  List<TextEditingController> get alertBoxKeyEditingController => _alertBoxKeyEditingController;
  List<TextEditingController> get alertBoxPairEditingController =>_alertBoxPairEditingController;
  bool get isloading=>_isloading;

  String get selectedProductCategory =>_selectedProductCategory;
  int get countVariationFields => _countVariationField;
  int get alertBoxFieldCount => _alertBoxFieldCount;

  //get values for all cutom field
  List<Map<String, dynamic>> get cat=>_cat;
  List<Map<String, dynamic>> get boxSize=>_boxSize;
  List<Map<String, dynamic>> get brand=>_brand;
  List<Map<String, dynamic>> get technicalName=>_technicalName;

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
    //get all custom dropvalue
   void getCategories() async {
    // print('bearrshjsjjn ${await AuthProvider().getToken()}');
    _cat = (await AuthProvider().getAllCategories())['data']
        .cast<Map<String, dynamic>>();
    _technicalName = (await ProductPageApi().getTechnicalName())['data'];

    _brand = (await ProductPageApi().getAllBrandName())['data']
        .cast<Map<String, dynamic>>();
    _boxSize = (await ProductPageApi().getBoxSize())['data'];
    _isloading=true;
     notifyListeners();
    
  }

  

  void addNewTextEditingControllerInAlertBox() {
    _alertBoxKeyEditingController.add(TextEditingController());
    _alertBoxPairEditingController.add(TextEditingController());
    // _eanUpcs.add(TextEditingController());
    // _skus.add(TextEditingController());
      _alertBoxFieldCount++;
    // print("heelo is ahere${_countVariationField}");
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
