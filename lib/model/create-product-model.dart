import 'package:inventory_management/model/box-size.dart';
import 'package:inventory_management/model/brand.dart';
import 'package:inventory_management/model/category.dart';
// import 'package:inventory_management/model/technical_name.dart';
// import 'package:inventory_management/model/label.dart';
// import 'package:inventory_management/model/dimensions.dart';

class CreateProduct {
  final String displayName;
  final String parentSku;
  final String sku;
  final String ean;
  final Brand brand;
  final Category category;
  final String description;
  // final TechnicalName technicalName;
  // final Label label;
  final String taxRule;
  // final Dimensions dimensions;
  final double weight;
  final BoxSize boxSize;
  final double mrp;
  final double cost;
  final List<String> images;

  CreateProduct({
    required this.displayName,
    required this.parentSku,
    required this.sku,
    required this.ean,
    required this.brand,
    required this.category,
    required this.description,
    // required this.technicalName,
    // required this.label,
    required this.taxRule,
    // required this.dimensions,
    required this.weight,
    required this.boxSize,
    required this.mrp,
    required this.cost,
    required this.images,
  });

  // Factory constructor to create a CreateProduct instance from a JSON map
  factory CreateProduct.fromJson(Map<String, dynamic> json) {
    return CreateProduct(
      displayName: json['displayName'],
      parentSku: json['parentSku'],
      sku: json['sku'],
      ean: json['ean'],
      brand: Brand.fromJson(json['brand']),
      category: Category.fromJson(json['category']),
      description: json['description'],
      // technicalName: TechnicalName.fromJson(json['technicalName']),
      // label: Label.fromJson(json['label']),
      taxRule: json['taxRule'],
      // dimensions: Dimensions.fromJson(json['dimensions']),
      weight: json['weight'].toDouble(),
      boxSize: BoxSize.fromJson(json['boxSize']),
      mrp: json['mrp'].toDouble(),
      cost: json['cost'].toDouble(),
      images: List<String>.from(json['images']),
    );
  }

  // Method to convert CreateProduct instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'parentSku': parentSku,
      'sku': sku,
      'ean': ean,
      'brand': brand.toJson(),
      'category': category.toJson(),
      'description': description,
      // 'technicalName': technicalName?.toJson(),
      // 'label': label?.toJson(),
      'taxRule': taxRule,
      // 'dimensions': dimensions?.toJson(),
      'weight': weight,
      'boxSize': boxSize.toJson(),
      'mrp': mrp,
      'cost': cost,
      'images': images,
    };
  }

  @override
  String toString() {
    return 'CreateProduct(displayName: $displayName, parentSku: $parentSku, sku: $sku, ean: $ean, brand: $brand, category: $category, description: $description, taxRule: $taxRule, weight: $weight, boxSize: $boxSize, mrp: $mrp, cost: $cost, images: $images)';
  }
}
