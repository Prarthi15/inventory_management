import 'package:flutter/material.dart';
import 'package:inventory_management/Api/orders_api.dart';
import 'package:inventory_management/model/orders_model.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _selectAll = false;
  bool _isLoading = false;
  // int _totalPage = 0;

  // pagination state variables
  int _selectedPage = 1;
  int _numberofPages = 2;
  int _firstval = 1;
  int _lastval = 5;
  int _jump = 5;
  get selectedPage => _selectedPage;
  get numberofPages => _numberofPages;
  get firstval => _firstval;
  get lastval => _lastval;
  get jump => _jump;

  // Getters for the private fields
  List<Order> get orders => _orders;
  bool get selectAll => _selectAll;
  bool get isLoading => _isLoading;

  //Pagination Logic
  int _readyToConfirmPage = 1;
  int _failedOrdersPage = 1;
  int _totalReadyToConfirmPages = 1; // Total pages for Ready to Confirm
  int _totalFailedOrderPages = 1; // Total pages for Failed Orders

  int get readyToConfirmPage => _readyToConfirmPage;
  int get failedOrdersPage => _failedOrdersPage;

  int get totalReadyToConfirmPages => _totalReadyToConfirmPages;
  int get totalFailedOrderPages => _totalFailedOrderPages;

  // Function to set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  void upDateReadyToConfirmPage(int page) {
    _readyToConfirmPage = page;
    notifyListeners();
  }

  // Update the page number for failed orders
  void upDateFailedOrdersPage(int page) {
    _failedOrdersPage = page;
    notifyListeners();
  }

// Getter for selectedOrders
  List<Order> get selectedOrders {
    return _orders.where((order) => order.isSelected).toList();
  }

  final ordersApi = OrdersApi();

  // Fetch orders from the API
  Future<void> fetchOrders(
      {int page = 1,
      int limit = 20,
      bool? isReadyToConfirm,
      bool? isFailed}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await ordersApi.getOrders(limit: limit);
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

  // // Toggle the selection of an order
  // void toggleOrderSelection(int index, bool value) {
  //   if (index >= 0 && index < _orders.length) {
  //     _orders[index].isSelected = value; // Update the order's selection state

  //     // Check if all orders are selected
  //     _selectAll = _orders.every((order) => order.isSelected);
  //     print(
  //         'Order : ${_orders[index].id} - ${_orders[index].orderId} selection changed to $value');
  //     print('All orders selected: $_selectAll'); // Improved debugging output

  //     notifyListeners();
  //   }
  // }

  void toggleOrderSelection(String orderId, bool isSelected) {
    for (var order in orders) {
      if (order.orderId == orderId) {
        order.isSelected = isSelected;
        print('Order: ${order.orderId} Selected: $isSelected');
        break;
      }
    }

    // Check if all orders for each category are selected
    bool allReadyToConfirm = orders
        .where((order) => order.orderStatus == 0)
        .every((order) => order.isSelected);
    bool allFailedOrders = orders
        .where((order) => order.orderStatus == 1)
        .every((order) => order.isSelected);

    readyToConfirmSelectAll = allReadyToConfirm;
    failedOrdersSelectAll = allFailedOrders;
    _selectAll = allReadyToConfirm ||
        allFailedOrders; // Optional: if you want a global select all

    notifyListeners();
  }

  // // Toggle all orders' selection
  // void toggleSelectAll(bool? value) {
  //   _selectAll = value ?? false;
  //   for (var order in _orders) {
  //     order.isSelected = _selectAll; // Update all orders' selection state
  //   }
  //   print('Select All toggled to: $_selectAll');
  //   notifyListeners();
  // }

  bool readyToConfirmSelectAll = false;
  bool failedOrdersSelectAll = false;

// Add toggle for ready to confirm
  void toggleReadyToConfirmSelectAll(bool? value) {
    readyToConfirmSelectAll = value ?? false;

    // Update selection state for "Ready to Confirm" orders
    for (var order in orders) {
      if (order.orderStatus == 0) {
        // Status 0 for "Ready to Confirm"
        order.isSelected = readyToConfirmSelectAll;
        print("${order.orderId} Selected: $readyToConfirmSelectAll");
      }
    }

    // Check if all ready to confirm orders are selected
    if (readyToConfirmSelectAll) {
      // If select all is checked, ensure that it reflects in individual selections
      _selectAll = orders
          .where((order) => order.orderStatus == 0)
          .every((order) => order.isSelected);
    }

    notifyListeners();
  }

// Add toggle for failed orders
  void toggleFailedOrdersSelectAll(bool? value) {
    failedOrdersSelectAll = value ?? false;

    // Update selection state for "Failed Orders"
    for (var order in orders) {
      if (order.orderStatus == 1) {
        // Assuming Status 1 is for "Failed Orders"
        order.isSelected = failedOrdersSelectAll;
        print("${order.orderId} Selected: $failedOrdersSelectAll");
      }
    }

    // Check if all failed orders are selected
    if (failedOrdersSelectAll) {
      // If select all is checked, ensure that it reflects in individual selections
      _selectAll = orders
          .where((order) => order.orderStatus == 1)
          .every((order) => order.isSelected);
    }

    notifyListeners();
  }

  // Fetch order by ID using OrdersApi
  Future<List<Order>> fetchOrderById(String orderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final order = await ordersApi.getOrderById(orderId);
      if (order != null) {
        print('Fetched Order ID: ${order.id}, ${order.orderId}');
        // Return a list with the fetched order
        return [order]; // Return a list containing the order
      } else {
        print('No order found for ID: $orderId');
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

  // pagination controls
  void upDateSelectedPage(int val) {
    print("page no. $val");
    _selectedPage = val;
    _firstval = (val - 1) * _jump;
    _lastval = _firstval + _jump;
    notifyListeners();
  }

  void upDateJump(int val) {
    _jump = val;

    notifyListeners();
  }

  void upNumberofPages(int val) {
    _numberofPages = val;
    notifyListeners();
  }

  void upDateFirstAndLastVal(int firstVal, int lastVal) {
    _firstval = firstVal;
    _lastval = lastVal;
    notifyListeners();
  }
}