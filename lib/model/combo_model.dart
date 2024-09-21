class Combo {
  String? id;
  String? name;
  double? mrp;
  double? cost;
  String? sku;
  List<Map<String, dynamic>>? products; // List of product maps

  Combo({
    this.id,
    this.name,
    this.mrp,
    this.cost,
    this.sku,
    this.products,
  });

  factory Combo.fromJson(Map<String, dynamic> json) {
    return Combo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      sku: json['comboSku'] ?? '',
      products: (json['products'] as List<dynamic>?)
          ?.map((item) => item as Map<String, dynamic>)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'mrp': mrp,
      'cost': cost,
      'comboSku': sku,
      'products': products,
    };
  }
}

class Dimensions {
  double length;
  double breadth;
  double height;

  Dimensions({
    required this.length,
    required this.breadth,
    required this.height,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      length: json['length']?.toDouble() ?? 0.0,
      breadth: json['breadth']?.toDouble() ?? 0.0,
      height: json['height']?.toDouble() ?? 0.0,
    );
  }
}

class Brand {
  String id;
  String name;

  Brand({
    required this.id,
    required this.name,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Category {
  String id;
  String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Product {
  String? id;
  String? displayName;
  String? sku;
  String? description;
  Brand? brand;
  Category? category; // Optional field
  Dimensions? dimensions;
  double? weight;
  String? productType;

  Product({
    this.id,
    this.displayName,
    this.sku,
    this.description,
    this.brand,
    this.dimensions,
    this.category,
    this.weight,
    this.productType,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      displayName: json['displayName'] ?? '',
      sku: json['sku'] ?? '',
      description: json['description'] ?? '',
      brand: json['brand'] != null ? Brand.fromJson(json['brand']) : null,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      dimensions: (json['dimensions']) != null
          ? Dimensions.fromJson(json['dimensions'])
          : null,
      weight: json['weight']?.toDouble() ?? 0.0,
      productType: json['productType'] ?? '',
    );
  }
}
