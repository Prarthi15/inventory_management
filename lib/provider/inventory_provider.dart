import 'package:flutter/material.dart';
import 'package:inventory_management/Api/inventory_api.dart'; // Import the API service

class InventoryProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _inventory = [];
  bool _isLoading = true;
  String? _errorMessage;

  // New properties for pagination
  int _currentPage = 0;
  final int _rowsPerPage = 5;

  List<Map<String, dynamic>> get inventory => _inventory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // New getters for pagination
  int get currentPage => _currentPage;
  int get totalPages => (_inventory.length / _rowsPerPage).ceil();

  Future<void> fetchInventory() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await getAllInventory(); // Call the API
      if (response['success']) {
        _inventory = response['data']['inventories'];
      } else {
        print('Error: ${response['message']}');
        // Handle the API error message and show an error snackbar or fallback UI
      }
    } catch (e) {
      print('Failed to fetch data: $e');
      // Handle error, e.g., show a Snackbar with error details
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners when loading finishes
    }
  }

  List<Map<String, dynamic>> getPaginatedData() {
    final int startIndex = _currentPage * _rowsPerPage;
    final int endIndex = startIndex + _rowsPerPage;
    return _inventory.sublist(
      startIndex,
      endIndex > _inventory.length ? _inventory.length : endIndex,
    );
  }

  void goToPage(int page) {
    _currentPage = page;
    notifyListeners(); // Notify listeners when the current page changes
  }

  void _nextPage() {
    final totalPages = (inventory.length / _rowsPerPage).ceil();

    if (_currentPage < totalPages - 1) {
      _currentPage++;
      notifyListeners();
    }
  }
}
