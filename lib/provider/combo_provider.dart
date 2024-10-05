import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:inventory_management/Api/auth_provider.dart';
import 'package:inventory_management/model/combo_model.dart';
import 'package:inventory_management/Api/combo_api.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../Api/inventory_api.dart';

class ComboProvider with ChangeNotifier {
  Combo? _combo;
  bool _isFormVisible = false;
  List<Combo> _comboList = [];
  List<DropdownItem<String>> _items = [];
  List<DropdownItem<String>> get item => _items;
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
  void addItem(String label, String value) {
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


  Future<void> fetchProducts() async {
    _loading = true;
    notifyListeners(); // Notify listeners to show loading state
    try {
      final api = ComboApi();

      // Fetch the full response (which contains the 'products' array)
      final response = await api.getAllProducts();

      // Check if products exist in response
      if (response.containsKey('products') && response['products'] is List) {
        // Extract the 'products' array from the response
        final productList = response['products'];

        // Debugging output
        print("Raw productList in provider: $productList");

        // Map the 'products' array into the Product model list
        _products = productList.map<Product>((json) => Product.fromJson(json)).toList();

        // Print the mapped products for debugging
        print("Mapped products in provider: $_products");
      }

      else {
        print("Error: 'products' key not found or not a list in response.");
      }
    } catch (e, stacktrace) {
      // Log error details
      print('Error fetching products: $e');
      print('Stacktrace: $stacktrace');
    } finally {
      _loading = false; // Stop loading once the process is done
      notifyListeners(); // Notify listeners to hide loading state and update UI
    }
  }

  Future<void> fetchAllProducts() async {
    _loading = true;
    notifyListeners(); // Notify listeners to show loading state

    try {
      final api = ComboApi();
      Map<String, dynamic> response;

      int currentPage = 1;
      int totalPages = 1;
      List<Product> allProducts = [];

      // Fetch products from each page until we've gotten all pages
      do {
        response = await api.getProductsByPage(currentPage);

        // If this is the first page, extract the total pages
        if (currentPage == 1) {
          totalPages = response['totalPages'];
        }

        // Check if products exist in response
        if (response.containsKey('products') && response['products'] is List) {
          final productList = response['products'];
          print('$productList');
          allProducts.addAll(productList.map<Product>((json) => Product.fromJson(json)).toList());
        }

        currentPage++;
      } while (currentPage <= totalPages);

      // Set the final product list
      _products = allProducts;

      // Debugging output
      print("Total products fetched: ${_products.length}");
    } catch (e, stacktrace) {
      print('Error fetching products: $e');
      print('Stacktrace: $stacktrace');
    } finally {
      _loading = false; // Stop loading once the process is done
      notifyListeners(); // Notify listeners to hide loading state and update UI
    }
  }

  // Fetch products by name (used for search)
  Future<List<Product>> searchProductsByName(String query) async {
    final token = await getToken(); // Ensure your token fetching is correct
    final url = Uri.parse(
        'https://inventory-management-backend-s37u.onrender.com/products?displayName=$query');

    print('Searching products with query: $query');
    print('API URL: $url');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    print('API Response Status Code: ${response.statusCode}');
    print('API Response Body: ${response.body}');

    if (response.statusCode == 200) {

      final jsonData = json.decode(response.body);
      log("$jsonData");

      if (jsonData.containsKey('products') && jsonData['products'] is List) {
        print('Products found: ${jsonData['products'].length}');

        // Parse and return the list of products
        return jsonData['products']
            .map<Product>((json) => Product.fromJson(json))
            .toList();
      } else {
        print('No products found in response');
        return [];
      }
    } else {
      print('Failed to load products. Status Code: ${response.statusCode}');
      throw Exception('Failed to load products');
    }
  }






  List<Map<String, dynamic>> _warehouses = [];

  // Loading state
  //bool _loading = false;

  // Getter to access the list of warehouses from outside the provider
  List<Map<String, dynamic>> get warehouses => _warehouses;
  Future<void> fetchWarehouses() async {
    _loading = true; // Set loading to true while fetching data
    notifyListeners(); // Notify listeners to show the loading state

    try {
      final api = AuthProvider(); // Replace with your API provider for Warehouse
      final response = await api.getAllWarehouses();

      // Check if the request was successful
      if (response['success'] == true) {
        final warehouseList = response['data']['warehouses'];

        // Debugging output
        print("Raw warehouseList in provider: $warehouseList");

        _warehouses = warehouseList; // Assuming _warehouses is defined in the provider

        // Print the mapped warehouses for debugging
        print("Mapped warehouses in provider: $_warehouses");
      } else {
        print("Error: ${response['message']}");
      }
    } catch (e, stacktrace) {
      // Log error details
      print('Error fetching warehouses: $e');
      print('Stacktrace: $stacktrace');
    } finally {
      _loading = false; // Stop loading once the process is done
      notifyListeners(); // Notify listeners to hide loading state and update UI
    }
  }



  // Method to select products by IDs
  void selectProductsByIds(List<String?> productIds) {
    _selectedProducts =
        _products.where((product) => productIds.contains(product.id)).toList();
    notifyListeners();
  }
}
