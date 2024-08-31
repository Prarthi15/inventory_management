import 'package:flutter/foundation.dart';

class Combo with ChangeNotifier {
  String id;
  List<Map<String, dynamic>>
      products; // List of product details with product_id
  String name;
  List<Map<String, dynamic>> mrp; // List of MRP values with mktp_id
  List<Map<String, dynamic>> cost; // List of cost values with mktp_id
  String sku;

  Combo({
    required this.id,
    required this.products,
    required this.name,
    required this.mrp,
    required this.cost,
    required this.sku,
  });

  void updateCombo({
    String? name,
    List<Map<String, dynamic>>? products,
    List<Map<String, dynamic>>? mrp,
    List<Map<String, dynamic>>? cost,
    String? sku,
  }) {
    if (name != null) this.name = name;
    if (products != null) this.products = products;
    if (mrp != null) this.mrp = mrp;
    if (cost != null) this.cost = cost;
    if (sku != null) this.sku = sku;
    notifyListeners();
  }
}

class ComboProvider with ChangeNotifier {
  Combo? _combo;

  Combo? get combo => _combo;

  void createCombo(Combo combo) {
    _combo = combo;
    notifyListeners();
  }
}
