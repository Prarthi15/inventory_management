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
  final String displayName;
  final String parentSku;
  final String ean;
  final String description;
  final String technicalName;
  final String weight;
  final String cost;
  final String tax_rule;
  final String grade;
  final String shopifyImage;

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
    required this.displayName,
    required this.parentSku,
    required this.ean,
    required this.description,
    required this.technicalName,
    required this.weight,
    required this.cost,
    required this.tax_rule,
    required this.grade,
    required this.shopifyImage,
  });
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Check if the screen width is less than a certain value (e.g., 800)
            final bool isSmallScreen = constraints.maxWidth < 800;

            return isSmallScreen
                ? _buildSmallScreenContent() // Column layout for small screens
                : _buildWideScreenContent(); // Two-column content on the right for wide screens
          },
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[300],
      ),
      child: product.shopifyImage.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.shopifyImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
              ),
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.image,
        size: 50,
        color: Colors.grey,
      ),
    );
  }

  // For small screens, adjust the content in a vertical column layout
  Widget _buildSmallScreenContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(),
        const SizedBox(height: 12),
        _buildTitle(product.displayName),
        _buildText('SKU', product.sku),
        _buildText('Parent SKU', product.parentSku),
        _buildText('EAN', product.ean),
        _buildText('Description', product.description),
        _buildText('Technical Name', product.technicalName),
        _buildText('Weight', '${product.weight} kg'),
        _buildText('MRP', '\$${product.mrp}'),
        _buildText('Cost', '\$${product.cost}'),
        _buildText('Tax Rule', product.tax_rule),
        _buildText('Grade', product.grade),
      ],
    );
  }

  // For wide screens, keep the image on the left and the content in two columns on the right
  Widget _buildWideScreenContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildLeftColumnContent()),
              const SizedBox(width: 8),
              Expanded(child: _buildRightColumnContent()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeftColumnContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(product.displayName),
        _buildText('SKU', product.sku),
        _buildText('Parent SKU', product.parentSku),
        _buildText('EAN', product.ean),
        _buildText('Description', product.description),
      ],
    );
  }

  Widget _buildRightColumnContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText('Technical Name', product.technicalName),
        _buildText('Weight', '${product.weight} kg'),
        _buildText('MRP', '\$${product.mrp}'),
        _buildText('Cost', '\$${product.cost}'),
        _buildText('Tax Rule', product.tax_rule),
        _buildText('Grade', product.grade),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        '$label: ${value.isNotEmpty ? value : '-'}',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
    );
  }
}