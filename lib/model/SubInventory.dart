class SubInventory {
  final String? warehouseId; // Nullable
  final int quantity;
  final String subName;

  SubInventory({
    required this.warehouseId,
    required this.quantity,
    required this.subName,
  });

  // Factory constructor to create a SubInventory object from JSON
  factory SubInventory.fromJson(Map<String, dynamic> json) {
    return SubInventory(
      warehouseId: json['warehouseId'], // Allow null values for warehouseId
      quantity: json['quantity'] ?? 0, // Provide default value for quantity
      subName: json['subName'] ?? 'NA',
    );
  }

  // Method to convert SubInventory object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'warehouseId': warehouseId,
      'quantity': quantity,
    };
  }
}
