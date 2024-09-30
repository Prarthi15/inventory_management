import 'package:flutter/material.dart';
import 'package:inventory_management/Api/orders_api.dart';
import 'package:inventory_management/model/orders_model.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _selectAll = false;
  bool _isLoading = false;

  // Getters for the private fields
  List<Order> get orders => _orders;
  bool get selectAll => _selectAll;
  bool get isLoading => _isLoading;

  // Pagination state variables
  int _currentPage = 1; // Track current page
  int _totalPages = 1; // Track total pages (comes from API)
  int _limit = 10; // Default limit per page (you can change this as needed)

  // Getter for selectedOrders
  List<bool> get selectedOrders {
    return _orders.map((order) => order.isSelected).toList();
  }

  final ordersApi = OrdersApi();

  // Fetch orders from the API
  Future<void> fetchOrders({int page = 1, int limit = 20}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await ordersApi.getOrders(page: page, limit: limit);
      // Initialize selection state for each order
      for (var order in _orders) {
        order.isSelected = false; // Ensure all orders are unselected initially
      }
      _selectAll = false; // Reset selectAll when fetching orders
    } catch (error) {
      print('Error fetching orders: $error');
      _orders = []; // Return an empty list on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Format date
  String formatDate(DateTime date) {
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  // Toggle the selection of an order
  void toggleOrderSelection(int index, bool value) {
    if (index >= 0 && index < _orders.length) {
      _orders[index].isSelected = value; // Update the order's selection state

      // Check if all orders are selected
      _selectAll = _orders.every((order) => order.isSelected);
      print('Order ${_orders[index].orderId} selection changed to $value');
      print('All orders selected: $_selectAll'); // Improved debugging output

      notifyListeners();
    }
  }

  // Toggle all orders' selection
  void toggleSelectAll(bool? value) {
    _selectAll = value ?? false;
    for (var order in _orders) {
      order.isSelected = _selectAll; // Update all orders' selection state
    }
    print('Select All toggled to: $_selectAll');
    notifyListeners();
  }

  // Fetch order by ID using OrdersApi
  Future<List<Order>> fetchOrderById(String orderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final order = await ordersApi.getOrderById(orderId);
      if (order != null) {
        // Return a list with the fetched order
        return [order]; // Return a list containing the order
      } else {
        return []; // Return an empty list if no order is found
      }
    } catch (error) {
      print('Error: $error');
      return []; // Return an empty list on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
