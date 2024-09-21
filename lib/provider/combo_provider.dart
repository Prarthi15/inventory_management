import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inventory_management/model/combo_model.dart';
import 'package:inventory_management/Api/combo_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComboProvider with ChangeNotifier {
  Combo? _combo;
  bool _isFormVisible = false;
  List<Combo> _comboList = [];
  List<Product> _products = []; //list
  bool isLoading = false;

  Combo? get combo => _combo;
  bool get isFormVisible => _isFormVisible;
  List<Combo> get comboList => _comboList;
  List<Product> get products => _products;
  //bool get isLoading => isLoading;

  ComboProvider() {
    _loadCombos();
  }

  // Toggles the visibility of the combo creation form
  void toggleFormVisibility() {
    _isFormVisible = !_isFormVisible;
    notifyListeners();
  }

  // Sets the current combo and notifies listeners
  void setCombo(Combo combo) {
    _combo = combo;
    notifyListeners();
  }

  void addCombo(Combo combo) {
    print(combo.products);
    _comboList.add(combo);
    // _saveCombos();
    notifyListeners();
  }

  final comboApi = ComboApi();

  Future<void> createCombo(Combo combo) async {
    try {
      final createdCombo = await comboApi.createCombo(combo);
      _combo = createdCombo;
      notifyListeners();
    } catch (e) {
      print('Failed to create combo: $e');
    }
  }

  Future<void> fetchCombos() async {
    isLoading = true;
    notifyListeners();
    try{
      final comboApi = ComboApi();
          final response =
        await comboApi.getCombos(); // getCombos returns a List<Combo>
    _comboList = response;
    }finally {
      isLoading = false;  // Set loading to false when fetching completes
      notifyListeners();
    }
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
    isLoading = true;
    notifyListeners();
    try {
      _products = await ComboApi().getAllProducts();
    } catch (error) {
      print("Error fetching products: $error");
    }

    isLoading = false;
    notifyListeners();
  }
}
