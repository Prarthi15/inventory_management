import 'package:flutter/material.dart';
import 'package:inventory_management/Api/combo_api.dart';
import 'package:inventory_management/model/combo_model.dart'; // for product model
import 'package:inventory_management/model/marketplace_model.dart';
import 'package:inventory_management/Api/marketplace_api.dart';

class MarketplaceProvider with ChangeNotifier {
  bool _isFormVisible = false;
  TextEditingController nameController = TextEditingController();
  final List<SkuMap> _skuMaps = [];
  List<Marketplace> _marketplaces = [];

  List<Product> _products = [];
  Product? _selectedProduct;
  bool _loading = false;

  bool isSaving = false;

  bool get isFormVisible => _isFormVisible;
  List<Marketplace> get marketplaces => _marketplaces;
  List<SkuMap> get skuMaps => _skuMaps;

  List<Product> get products => _products;
  Product? get selectedProduct => _selectedProduct;
  bool get loading => _loading;

  final marketplaceApi = MarketplaceApi();
  final comboApi = ComboApi();

  // Fetch marketplaces
  Future<void> fetchMarketplaces() async {
    _loading = true;
    notifyListeners();

    try {
      // Fetch the list of marketplaces
      _marketplaces = await marketplaceApi.getMarketplaces();
      //print(_marketplaces);

      // Iterate over each marketplace to fetch product details
      for (var marketplace in _marketplaces) {
        for (var skuMap in marketplace.skuMap) {
          try {
            skuMap.product = await comboApi.getProductById(skuMap.productId);
          } catch (e) {
            // Handle individual product fetch errors
            //print(skuMap.mktpSku);
            //print('Error fetching product with ID ${skuMap.productId}: $e');
            skuMap.product = null; // Or handle as appropriate
          }
        }
      }

      _loading = false;
    } catch (e) {
      // Handle general errors
      print('Error fetching marketplaces: $e');
      _marketplaces = []; // Clear the list on error
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

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
      print("productList in provider: $productList");

      // Map the 'products' array into the Product model list
      _products =
          productList.map<Product>((json) => Product.fromJson(json)).toList();

      // Print the mapped products for debugging
      print("products in provider: $_products");
    } catch (e, stacktrace) {
      // Log error details
      print('Error fetching products: $e');
      print('Stacktrace: $stacktrace');
    } finally {
      _loading = false; // Stop loading once the process is done
      notifyListeners(); // Notify listeners to hide loading state and update UI
    }
  }

  void selectProduct(Product product) {
    _selectedProduct = product;
    notifyListeners();
  }

  // Create a new marketplace
  Future<void> createMarketplace(Marketplace marketplace) async {
    try {
      await marketplaceApi.createMarketplace(marketplace);
      fetchMarketplaces(); // Refresh marketplaces after creating one
    } catch (e) {
      print('Error creating marketplace: $e');
    }
  }

  // Update an existing marketplace
  Future<void> updateMarketplace(String id, Marketplace marketplace) async {
    try {
      await marketplaceApi.updateMarketplace(id, marketplace);
      fetchMarketplaces(); // Refresh marketplaces after updating
    } catch (e) {
      print('Error updating marketplace: $e');
    }
  }

  // Delete a marketplace
  Future<void> deleteMarketplace(String id) async {
    try {
      await marketplaceApi.deleteMarketplace(id);
      fetchMarketplaces(); // Refresh marketplaces after deletion
    } catch (e) {
      print('Error deleting marketplace: $e');
    }
  }

  // Update SKU map with the selected product
  void updateSkuMap(int index, String sku, Product? selectedProduct) {
    final productId = selectedProduct?.id;
    if (productId == null || productId.isEmpty) {
      return; // Handle the error if productId is not available
    }
    _skuMaps[index] = SkuMap(
      mktpSku: sku,
      productId: productId,
      product: selectedProduct,
    );
    notifyListeners();
  }

  // Add a new SKU map row
  void addSkuMapRow() {
    _skuMaps.add(SkuMap(
      mktpSku: '',
      productId: '',
      product: null,
    ));
    notifyListeners();
  }

  // Remove a SKU map row
  void removeSkuMapRow(int index) {
    _skuMaps.removeAt(index);
    notifyListeners();
  }

  void toggleForm() {
    _isFormVisible = !_isFormVisible;
    notifyListeners();
  }

  // Save the marketplace
  Future<void> saveMarketplace() async {
    isSaving = true; // Start saving
    notifyListeners(); // Notify UI to show progress indicator

    // Validate SKU maps
    final invalidSkuMaps =
        skuMaps.where((skuMap) => skuMap.mktpSku.isEmpty).toList();

    if (invalidSkuMaps.isNotEmpty) {
      // Show an error message or handle invalid data
      print('Error: Some SKU maps are missing the mktp_sku.');

      // Stop saving if there are invalid SKU maps
      isSaving = false;
      notifyListeners();
      return; // Exit early if invalid data
    }

    // Prepare the new marketplace data
    final newMarketplace = Marketplace(
      name: nameController.text,
      skuMap: List.from(skuMaps), // Create a copy of SKU maps
    );

    try {
      // API call to save the marketplace
      await marketplaceApi.createMarketplace(newMarketplace);

      // Fetch the updated list of marketplaces
      await fetchMarketplaces();

      // Reset form and clear inputs after successful save
      toggleForm(); // Hide the form after saving
      skuMaps.clear();
      nameController.clear();
    } catch (e) {
      // Handle any errors
      print('Error creating marketplace: $e');
    } finally {
      isSaving = false; // Stop saving
      notifyListeners(); // Notify UI to hide progress indicator
    }
  }
}
