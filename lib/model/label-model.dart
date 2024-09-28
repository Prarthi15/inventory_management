class LabelModel {
  String name;
  String labelSku;
  String image;
  String description;
  String productId;
  int quantity;

  LabelModel({
    required this.name,
    required this.labelSku,
    required this.image,
    required this.description,
    required this.productId,
    required this.quantity,
  });

  // Factory method to create a LabelModel instance from JSON
  factory LabelModel.fromJson(Map<String, dynamic> json) {
    return LabelModel(
      name: json['name'],
      labelSku: json['labelSku'],
      image: json['image'],
      description: json['description'],
      productId: json['product_id'],
      quantity: json['quantity'],
    );
  }

  // Method to convert a LabelModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'labelSku': labelSku,
      'image': image,
      'description': description,
      'product_id': productId,
      'quantity': quantity,
    };
  }
}
