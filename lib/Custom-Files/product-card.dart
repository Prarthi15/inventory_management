import 'package:flutter/material.dart';

class Product {
  final String sku;
  final String category;
  final String brand;
  final String mrp;
  final String createdDate;
  final String lastUpdated;
  final String accSku;
  final String colour;
  final String upcEan;

  Product({
    required this.sku,
    required this.category,
    required this.brand,
    required this.mrp,
    required this.createdDate,
    required this.lastUpdated,
    required this.accSku,
    required this.colour,
    required this.upcEan,
  });
}

class ProductCard extends StatelessWidget {
  final String sku;
  final String category;
  final String brand;
  final String mrp;
  final String createdDate;
  final String lastUpdated;
  final String accSku;
  final String colour;
  final String upcEan;

  const ProductCard({
    super.key,
    required this.sku,
    required this.category,
    required this.brand,
    required this.mrp,
    required this.createdDate,
    required this.lastUpdated,
    required this.accSku,
    required this.colour,
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
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImage(),
                      const SizedBox(height: 16),
                      _buildProductDetails(),
                    ],
                  ),
          ),
        );
      },
    );
  }

  // Displays a placeholder image
  Widget _buildImage() {
    return Image.asset(
      'assets/forgotPass.png',
      width: 50,
      height: 50,
    );
  }

  // Product details layout for wide screen
  Widget _buildProductDetailsWideScreen() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText('SKU', sku),
              _buildText('CATEGORY', category),
              _buildText('BRAND', brand),
              _buildText('MRP', mrp),
            ],
          ),
        ),
      ],
    );
  }

  // Product details layout for smaller screens
  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText('SKU', sku),
        _buildText('CATEGORY', category),
        _buildText('BRAND', brand),
        _buildText('MRP', mrp),
      ],
    );
  }

  // Helper method to display text with dashes for missing fields
  Widget _buildText(String label, String value) {
    return Text(
      '$label: ${value.isNotEmpty ? value : '-'}',
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
