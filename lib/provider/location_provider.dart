// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:inventory_management/Api/auth_provider.dart';

class LocationProvider with ChangeNotifier {
  final AuthProvider authProvider;

  LocationProvider({required this.authProvider});

  List<Map<String, dynamic>> _warehouses = [];
  List<Map<String, dynamic>> _filteredWarehouses = [];

  List<Map<String, dynamic>> get warehouses =>
      _filteredWarehouses.isNotEmpty ? _filteredWarehouses : _warehouses;

  bool _isCreatingNewLocation = false;
  int _selectedCountryIndex = 0;
  int _selectedStateIndex = 0;
  int _selectedLocationTypeIndex = 0;
  bool? _holdsStock;
  bool? _copysku;
  bool _copyAddress = false;

  bool get isCreatingNewLocation => _isCreatingNewLocation;
  int get selectedCountryIndex => _selectedCountryIndex;
  int get selectedStateIndex => _selectedStateIndex;
  int get selectedLocationTypeIndex => _selectedLocationTypeIndex;
  bool? get holdsStock => _holdsStock;
  bool? get copysku => _copysku;
  bool get copyAddress => _copyAddress;

  final List<Map<String, dynamic>> _locations = [];
  List<Map<String, dynamic>> get locations => _locations;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? _successMessage;

  List<String> pincodes = [];
  String? validationMessage;

  bool _isEmailValid = false;

  bool get isEmailValid => _isEmailValid;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners(); // Notify listeners when the state changes
  }

  // Helper methods for handling success and error
  void _setError(String message) {
    _errorMessage = message;
    _successMessage = null;
    notifyListeners();
  }

  void _setSuccess(String message) {
    _successMessage = message;
    _errorMessage = null;
    notifyListeners();
  }

  void validateEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    _isEmailValid = regex.hasMatch(email);
    notifyListeners();
  }

  void addPincode(String pincode) {
    if (pincode.isEmpty) {
      validationMessage = 'Please enter a pincode';
      notifyListeners();
    } else {
      pincodes.add(pincode);
      validationMessage = null; // Clear validation message
      notifyListeners();
    }
  }

  void removePincode(int index) {
    pincodes.removeAt(index);
    notifyListeners();
  }

  List<Map<String, dynamic>> countries = [
    {'name': 'India'},
    {'name': 'USA'},
    {'name': 'UK'},
    {'name': 'Canada'},
  ];

  List<Map<String, dynamic>> states = [
    {'name': 'Madhya Pradesh'},
    {'name': 'Maharashtra'},
    {'name': 'California'},
    {'name': 'Ontario'},
  ];

  List<Map<String, dynamic>> locationTypes = [
    {'name': 'Warehouse'},
    {'name': 'Retail Store'},
    {'name': 'Distribution Center'},
  ];

  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void toggleCreatingNewLocation() {
    _isCreatingNewLocation = !_isCreatingNewLocation;
    notifyListeners();
  }

  void selectCountry(int index) {
    _selectedCountryIndex = index;
    notifyListeners();
  }

  void selectState(int index) {
    _selectedStateIndex = index;
    notifyListeners();
  }

  void selectLocationType(int index) {
    _selectedLocationTypeIndex = index;
    notifyListeners();
  }

  void updateHoldsStock(String? value) {
    print("Hold Stock Value: $value");
    if (value == "Yes") {
      _holdsStock = true;
    } else if (value == "No") {
      _holdsStock = false;
    } else {
      _holdsStock = null;
    }
    notifyListeners();
  }

  void updateCopysku(String? value) {
    print("Copy SKU Value: $value");
    if (value == "Yes") {
      _copysku = true;
    } else if (value == "No") {
      _copysku = false;
    } else {
      _copysku = null;
    }
    notifyListeners();
  }

  void updateCopyAddress(bool value) {
    _copyAddress = value;
    notifyListeners();
  }

  void addLocation(Map<String, dynamic> newLocation) {
    _locations.add(newLocation);
    notifyListeners();
  }

  Future<void> fetchWarehouses() async {
    _isLoading = true;
    notifyListeners();

    final result = await getAllWarehouses();

    if (result['success']) {
      final warehousesData = result['data']['warehouses'];

      if (warehousesData is List) {
        _warehouses = List<Map<String, dynamic>>.from(warehousesData);
      } else {
        _setError('Unexpected data format');
      }
    } else {
      _setError('Error fetching warehouses');
    }

    _isLoading = false;
    notifyListeners();
  }

  void refreshContent() async {
    await fetchWarehouses();
    notifyListeners();
  }

  // Shipping address fields
  String? _shippingAddress1;
  String? _shippingAddress2;
  String? _shippingCity;
  String? _shippingZipCode;
  String? _shippingPhoneNumber;

  String? get shippingAddress1 => _shippingAddress1;
  String? get shippingAddress2 => _shippingAddress2;
  String? get shippingCity => _shippingCity;
  String? get shippingZipCode => _shippingZipCode;
  String? get shippingPhoneNumber => _shippingPhoneNumber;

  void updateShippingAddress({
    String? address1,
    String? address2,
    String? city,
    String? zipCode,
    String? phoneNumber,
  }) {
    _shippingAddress1 = address1;
    _shippingAddress2 = address2;
    _shippingCity = city;
    _shippingZipCode = zipCode;
    _shippingPhoneNumber = phoneNumber;
    print(
        "Shipping Address Updated: $_shippingAddress1, $_shippingCity, $_shippingZipCode, $_shippingPhoneNumber");
    notifyListeners();
  }

  Future<Map<String, dynamic>> getAllWarehouses() async {
    return await authProvider.getAllWarehouses();
  }

  Future<bool> createWarehouse(Map<String, dynamic> location) async {
    try {
      final taxIdentificationNumber = location['taxIdentificationNumber'] is int
          ? location['taxIdentificationNumber'] as int
          : int.tryParse(location['taxIdentificationNumber'].toString()) ?? 0;

      final holdStocks = location['holdStocks'] is bool
          ? location['holdStocks'] as bool
          : location['holdStocks'] == 'true';

      final copyMasterSkuFromPrimary =
          location['copyMasterSkuFromPrimary'] is bool
              ? location['copyMasterSkuFromPrimary'] as bool
              : location['copyMasterSkuFromPrimary'] == 'true';

      // Extract pincodes from location if available
      final List<String> pincodes = location['pincode'] is List<String>
          ? List<String>.from(location['pincode'])
          : [];

      final response = await authProvider.createWarehouse(
        name: location['name'] as String,
        email: location['email'] as String,
        taxIdentificationNumber: taxIdentificationNumber,
        billingAddressLine1:
            location['billingAddress']['addressLine1'] as String,
        billingAddressLine2:
            location['billingAddress']['addressLine2'] as String,
        billingCountry: countries[_selectedCountryIndex]['name'],
        billingState: states[_selectedStateIndex]['name'],
        billingCity: location['billingAddress']['city'] as String,
        billingZipCode: location['billingAddress']['zipCode'] as int,
        billingPhoneNumber: location['billingAddress']['phoneNumber'] as int,
        shippingAddressLine1:
            location['shippingAddress']['addressLine1'] as String,
        shippingAddressLine2:
            location['shippingAddress']['addressLine2'] as String,
        shippingCountry: countries[_selectedCountryIndex]['name'],
        shippingState: states[_selectedStateIndex]['name'],
        shippingCity: location['shippingAddress']['city'] as String,
        shippingZipCode: location['shippingAddress']['zipCode'] as int,
        shippingPhoneNumber: location['shippingAddress']['phoneNumber'] as int,
        locationType: locationTypes[_selectedLocationTypeIndex]['name'],
        holdStocks: holdStocks,
        copyMasterSkuFromPrimary: copyMasterSkuFromPrimary,
        pincodes: pincodes,
        warehousePincode: location['warehousePincode'] as int,
      );

      if (response['success']) {
        _setSuccess('Warehouse created successfully!');
        return true;
      } else {
        _setError(response['message'] ?? 'Failed to create warehouse.');
        print('Error while creating warehouse: $_errorMessage');
        return false;
      }
    } catch (e) {
      _setError('An error occurred: $e');
      print('Error while creating warehouse: $e');
      return false;
    }
  }

  // Filtered warehouses
  void filterWarehouses(String query) {
    if (query.isEmpty) {
      _filteredWarehouses.clear();
    } else {
      _filteredWarehouses = _warehouses.where((warehouse) {
        final name = warehouse['name']?.toLowerCase() ?? '';
        final email = warehouse['email']?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase()) ||
            email.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<bool> deleteWarehouse(BuildContext context, String warehouseId) async {
    bool isDeleted = await authProvider.deleteWarehouse(warehouseId);

    if (isDeleted) {
      warehouses.removeWhere((warehouse) => warehouse['_id'] == warehouseId);
      notifyListeners();
    }

    return isDeleted;
  }

  void resetForm() {
    pincodes.clear();
    _selectedCountryIndex =
        _selectedStateIndex = _selectedLocationTypeIndex = 0;
    _holdsStock = _copysku = null;
    _copyAddress = false;
    validationMessage = _errorMessage = _successMessage = null;

    notifyListeners();
  }
}
