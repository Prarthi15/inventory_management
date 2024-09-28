import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inventory_management/model/combo_model.dart';
import 'package:inventory_management/Api/combo_api.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class ComboProvider with ChangeNotifier {
  Combo? _combo;
  bool _isFormVisible = false;
  List<Combo> _comboList = [];
  List<DropdownItem<String>> _items = [];
  List<DropdownItem<String>> get item=>_items;
  List<Product> _products = [];
  List<Product> _selectedProducts = [];
  bool _loading = false;


  // Pagination state variables
  int _currentPage = 1; // Track current page
  int _totalPages = 1; // Track total pages (comes from API)
  int _limit = 10; // Default limit per page (you can change this as needed)

  Combo? get combo => _combo;
  bool get isFormVisible => _isFormVisible;
  List<Combo> get comboList => _comboList;

  List<Product> get products => _products;
  List<Product> get selectedProducts => _selectedProducts;
  bool get loading => _loading;

  List<Map<String, dynamic>> _combosList = [];
  List<Map<String, dynamic>> get combosList => _combosList;

  List<Uint8List>? selectedImages = [];
  List<String> imageNames = [];

  ComboProvider() {
    fetchCombos();
  }

  // Toggles the visibility of the combo creation form
  void toggleFormVisibility() {
    _isFormVisible = !_isFormVisible;
    notifyListeners();
  }

  void setCombo(Combo combo) {
    _combo = combo;
    notifyListeners();
  }


  // Sets the current combo and notifies listeners
  void addItem(String label,String value) {
    // _combo = combo;
    _items.add(DropdownItem<String>(label: label, value: value));

    print("item len  ${_items.length}");
    notifyListeners();
  }

  void addCombo(Combo combo) {
    print(combo.products);
    _comboList.add(combo);
    // _saveCombos();
    notifyListeners();
  }

  final comboApi = ComboApi();

  Future<void> createCombo(
      Combo combo, List<Uint8List>? images, List<String> productIds) async {
    try {
      final createdCombo =
          await comboApi.createCombo(combo, images, productIds);
      _combo = combo;
      notifyListeners();
    } catch (e) {
      print('Failed to create combo: $e');
    }
  }

  // Select images using file picker
  void selectImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image, // Only allow image files
    );

    if (result != null) {
      selectedImages = result.files.map((file) => file.bytes!).toList();
      imageNames = result.files.map((file) => file.name).toList();
      print('Selected images count: ${selectedImages!.length}');
      print('Image names count: ${imageNames.length}');
      notifyListeners();
    }
  }

  Future<void> fetchCombos({int page = 1, int limit = 10}) async {
    _loading = true;
    notifyListeners();
    try {
      _combosList = await comboApi.getCombos(page: page, limit: limit);
      //print("comboProvider.combosList : $_combosList");
    } catch (e) {
      print('Error fetching combos: $e');
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> _loadCombos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('combos') ?? [];
    _comboList =
        jsonList.map((json) => Combo.fromJson(jsonDecode(json))).toList();
    notifyListeners();
  }

  Future<void> _saveCombos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList =
        _comboList.map((combo) => jsonEncode(combo.toJson())).toList();
    await prefs.setStringList('combos', jsonList);
  }

  // Clears the current combo
  void clearCombo() {
    _combo = null;
    notifyListeners();
  }

  void clearCombos() {
    _comboList.clear();
    notifyListeners();
  }

  // fetch products
  Future<void> fetchProducts() async {
    _loading = true;
    notifyListeners(); // Notify listeners to show loading state
    try {
      final api = ComboApi();

      // Fetch the full response (which contains the 'products' array)
      final response = await api.getAllProducts();

      // Extract the 'products' array from the response
      final productList = response['products'];

      // Print raw productList for debugging
      //print("productList in provider: $productList");

      // Map the 'products' array into the Product model list
      _products =
          productList.map<Product>((json) => Product.fromJson(json)).toList();

      // Print the mapped products for debugging
      //print("products in provider: $_products");
    } catch (e, stacktrace) {
      // Log error details
      print('Error fetching products: $e');
      print('Stacktrace: $stacktrace');
    } finally {
      _loading = false; // Stop loading once the process is done
      notifyListeners(); // Notify listeners to hide loading state and update UI
    }
  }

  // void selectProducts(List<Product> products) {
  //   _selectedProducts = products;
  //   notifyListeners();
  // }

  // Method to select products by IDs
  void selectProductsByIds(List<String?> productIds) {
    _selectedProducts =
        _products.where((product) => productIds.contains(product.id)).toList();
    notifyListeners();
  }
}
