import 'package:flutter/material.dart';

class OrdersProvider with ChangeNotifier {
  TabController? _tabController;
  bool _selectAll = false;
  List<bool> _selectedOrders = List.generate(5, (index) => false);

  TabController? get tabController => _tabController;
  bool get selectAll => _selectAll; // for checkbox state
  List<bool> get selectedOrders => _selectedOrders;

  void initTabController(TickerProvider vsync, int length) {
    _tabController = TabController(length: length, vsync: vsync);
    notifyListeners();
  }

  void disposeTabController() {
    _tabController?.dispose();
  }

  // toggle all checkboxes
  void toggleSelectAll(bool? value) {
    _selectAll = value ?? false;
    for (int i = 0; i < _selectedOrders.length; i++) {
      _selectedOrders[i] = _selectAll;
    }
    notifyListeners();
  }

  // toggle single checkbox
  void toggleOrderSelection(int index, bool value) {
    _selectedOrders[index] = value;
    _selectAll = _selectedOrders.every((selected) => selected);
    notifyListeners();
  }

  // to format date
  String formatDate(DateTime date) {
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
