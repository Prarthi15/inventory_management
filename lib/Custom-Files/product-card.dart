import 'package:flutter/material.dart';
import 'package:inventory_management/model/product_model.dart';

class Product {
  final String sku;
  final String category;
  final String brand;
  final String mrp;
  final String createdDate;
  final String lastUpdated;
  final List<String> listedOn;
  final String accSku;
  final String colour;
  final String accUnit;
  final String upcEan;

  Product({
    required this.sku,
    required this.category,
    required this.brand,
    required this.mrp,
    required this.createdDate,
    required this.lastUpdated,
    required this.listedOn,
    required this.accSku,
    required this.colour,
    required this.accUnit,
    required this.upcEan,
  });

  // Add this method to handle JSON to Dart conversion
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      sku: json['sku'] ?? 'NA',
      category: json['category'] ?? 'NA',
      brand: json['brand'] ?? 'NA',
      mrp: json['mrp'] ?? 'NA',
      createdDate: json['createdDate'] ?? 'NA',
      lastUpdated: json['lastUpdated'] ?? 'NA',
      listedOn: (json['listedOn'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      accSku: json['accSku'] ?? 'NA',
      colour: json['colour'] ?? 'NA',
      accUnit: json['accUnit'] ?? 'NA',
      upcEan: json['upcEan'] ?? 'NA',
    );
  }
}

class ProductCard extends StatelessWidget {
  final String sku;
  final String category;
  final String brand;
  final String mrp;
  final String createdDate;
  final String lastUpdated;
  final List<String> listedOn;
  final String accSku;
  final String colour;
  final String accUnit;
  final String upcEan;

  const ProductCard({
    super.key,
    required this.sku,
    required this.category,
    required this.brand,
    required this.mrp,
    required this.createdDate,
    required this.lastUpdated,
    required this.listedOn,
    required this.accSku,
    required this.colour,
    required this.accUnit,
    required this.upcEan,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWideScreen = constraints.maxWidth > 600;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: isWideScreen
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImage(),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildProductDetailsWideScreen(),
                      ),
                      _buildListedOn(),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImage(),
                      const SizedBox(height: 16),
                      _buildProductDetails(),
                      _buildListedOn(),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildImage() {
    return Image.asset(
      'assets/forgotPass.png',
      width: 50,
      height: 50,
    );
  }

  Widget _buildProductDetailsWideScreen() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SKU: ${sku.isNotEmpty ? sku : 'NA'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('CATEGORY: ${category.isNotEmpty ? category : 'NA'}'),
              Text('BRAND: ${brand.isNotEmpty ? brand : 'NA'}'),
              Text('MRP: ${mrp.isNotEmpty ? mrp : 'NA'}'),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ACC SKU: ${accSku.isNotEmpty ? accSku : 'NA'}'),
              Text('COLOUR: ${colour.isNotEmpty ? colour : 'NA'}'),
              Text('ACC UNIT: ${accUnit.isNotEmpty ? accUnit : 'NA'}'),
              Text('UPC/EAN: ${upcEan.isNotEmpty ? upcEan : 'NA'}'),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'CREATED DATE: ${createdDate.isNotEmpty ? createdDate : 'NA'}'),
              Text(
                  'LAST UPDATED: ${lastUpdated.isNotEmpty ? lastUpdated : 'NA'}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SKU: ${sku.isNotEmpty ? sku : 'NA'}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('CATEGORY: ${category.isNotEmpty ? category : 'NA'}'),
        Text('BRAND: ${brand.isNotEmpty ? brand : 'NA'}'),
        Text('MRP: ${mrp.isNotEmpty ? mrp : 'NA'}'),
        Text('ACC SKU: ${accSku.isNotEmpty ? accSku : 'NA'}'),
        Text('COLOUR: ${colour.isNotEmpty ? colour : 'NA'}'),
        Text('ACC UNIT: ${accUnit.isNotEmpty ? accUnit : 'NA'}'),
        Text('UPC/EAN: ${upcEan.isNotEmpty ? upcEan : 'NA'}'),
        Text('CREATED DATE: ${createdDate.isNotEmpty ? createdDate : 'NA'}'),
        Text('LAST UPDATED: ${lastUpdated.isNotEmpty ? lastUpdated : 'NA'}'),
      ],
    );
  }

  Widget _buildListedOn() {
    return listedOn.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Listed On:'),
              Wrap(
                spacing: 4.0,
                children: listedOn
                    .map((platform) => Chip(
                          label: Text(platform),
                          backgroundColor: Colors.blueAccent.withOpacity(0.1),
                          labelStyle: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                    .toList(),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
