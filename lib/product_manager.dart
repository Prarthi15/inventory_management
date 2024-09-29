import 'package:flutter/material.dart';
import 'package:inventory_management/Api/auth_provider.dart';
import 'package:inventory_management/Custom-Files/custom-button.dart';
import 'package:provider/provider.dart';
import 'Custom-Files/colors.dart';
import 'products.dart';
import 'Custom-Files/product-card.dart';
import 'Custom-Files/filter-section.dart';

class ProductDashboardPage extends StatefulWidget {
  const ProductDashboardPage({super.key});

  @override
  _ProductDashboardPageState createState() => _ProductDashboardPageState();
}

class _ProductDashboardPageState extends State<ProductDashboardPage> {
  final int _itemsPerPage = 30;
  final List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  bool _showCreateProduct = false;
  int _currentPage = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMoreProducts();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await authProvider.getAllProducts(
          page: _currentPage, itemsPerPage: _itemsPerPage);

      if (response['success']) {
        final List<dynamic> productData = response['data'];
        final newProducts = productData.map((data) {
          Product product = Product(
            sku: data['sku'],
            parentSku: data['parentSku'],
            ean: data['ean'],
            description: data['description'],
            categoryName: data['categoryName'] ?? '-',
            colour: data['colour'] ?? '-',
            netWeight: data['netWeight']?.toString() ?? '-',
            grossWeight: data['grossWeight']?.toString() ?? '-',
            labelSku: data['labelSku'] ?? '-',
            box_name: data['box_name'] ?? '-',
            grade: data['grade'] ?? '-',
            technicalName: data['technicalName'] ?? '-',
            length: data['length']?.toString() ?? '-',
            width: data['width']?.toString() ?? '-',
            height: data['height']?.toString() ?? '-',
            mrp: data['mrp']?.toString() ?? '-',
            cost: data['cost']?.toString() ?? '-',
            tax_rule: data['tax_rule']?.toString() ?? '-',
            shopifyImage: data['shopifyImage'] ?? '',
            createdDate: data['createdAt'],
            lastUpdated: data['updatedAt'],
            displayName: data['displayName'] ?? '-',
          );
          return product;
        }).toList();

        setState(() {
          _products.addAll(newProducts);
          _hasMore = newProducts.length == _itemsPerPage;
          if (_hasMore) {
            _currentPage++;
          }
        });
      } else {
        setState(() {
          _hasMore = false;
        });
      }
    } catch (error) {
      setState(() {
        _hasMore = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 800;
    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Row(
        children: [
          if (isWideScreen && !_showCreateProduct)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWideScreen
                    ? 240
                    : MediaQuery.of(context).size.width * 0.5,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Search...',
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.orange),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FilterSection(
                              title: 'Category',
                              items: const [
                                'NPK Fertilizer',
                                'Hydroponic Nutrients',
                                'Chemical product',
                                'Organic Pest Control',
                                'Lure & Traps',
                              ],
                              searchQuery: _searchQuery,
                            ),
                            FilterSection(
                              title: 'Brand',
                              items: const [
                                'Katyayani Organics',
                                'Katyayani',
                                'KATYAYNI',
                                'Samarthaa (Bulk)',
                                'quinalphos 25%ec',
                              ],
                              searchQuery: _searchQuery,
                            ),
                            FilterSection(
                              title: 'Product Type',
                              items: const [
                                'Simple Products',
                                'Products with Variants',
                                'Virtual Combos',
                                'Physical Combos(Kits)',
                              ],
                              searchQuery: _searchQuery,
                            ),
                            FilterSection(
                              title: 'Colour',
                              items: const [
                                'NA',
                                'shown an image',
                                'Multicolour',
                                '0',
                              ],
                              searchQuery: _searchQuery,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSmallScreen)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SizedBox(
                        width: 300,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Search...',
                            prefixIcon: const Icon(Icons.search,
                                color: AppColors.primaryBlue),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: AppColors.primaryBlue,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: AppColors.primaryBlue,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showCreateProduct = !_showCreateProduct;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                            ),
                            child: Text(
                              _showCreateProduct ? 'Back' : 'Create Products',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Total Products: ${_products.length}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: !_showCreateProduct
                        ? NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (!_isLoading &&
                                  scrollInfo.metrics.pixels ==
                                      scrollInfo.metrics.maxScrollExtent) {
                                _loadMoreProducts();
                              }
                              return false;
                            },
                            child: _products.isEmpty
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ListView.builder(
                                    itemCount: _products.length,
                                    itemBuilder: (context, index) {
                                      return ProductCard(
                                          product: _products[index]);
                                    },
                                  ),
                          )
                        : const Products(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
