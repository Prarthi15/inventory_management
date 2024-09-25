import 'SubInventory.dart'; // Import SubInventory model
import 'product_model.dart';

class InventoryModel {
  final String id;
  final int total; // Total inventory count
  final Product? product; // Nullable product object
  late final List<SubInventory> subInventory; // List of sub-inventories

  InventoryModel({
    required this.id,
    required this.total,
    this.product,
    required this.subInventory,
  });

  // Factory constructor to create InventoryModel object from JSON
  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: json['_id'] ?? '', // Handle missing '_id' safely
      total: json['total'] ?? 0, // Default to 0 if 'total' is missing
      // Check for null 'product_id' and parse it if available
      product: json['product_id'] != null
          ? Product.fromJson(json['product_id'])
          : null,
      // Ensure 'subInventory' is parsed correctly and handle an empty list if it's missing
      subInventory:
          (json['subInventory'] != null ? (json['subInventory'] as List) : [])
              .map((subInvJson) => SubInventory.fromJson(subInvJson))
              .toList(),
    );
  }

  // Method to convert InventoryModel object back to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'total': total,
      'product_id': product?.toJson(), // Convert Product to JSON if present
      'subInventory': subInventory.map((subInv) => subInv.toJson()).toList(),
    };
  }
}
