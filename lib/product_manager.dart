import 'package:flutter/material.dart';
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
  final int _itemsPerPage = 10;
  final int _totalItems = 50;
  final List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 0;
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

    await Future.delayed(const Duration(seconds: 2));

    final newProducts = List.generate(_itemsPerPage, (index) {
      final skuIndex = _page * _itemsPerPage + index;
      return Product(
        sku: 'K - $skuIndex',
        category: 'Category $skuIndex',
        brand: 'Brand $skuIndex',
        mrp: '${skuIndex * 10}',
        createdDate: '2024-01-13 15:07:57',
        lastUpdated: '2024-08-09 11:12:13',
        listedOn: ['Woo', 'Amazon', 'Catty'],
        accSku: 'ACC-${skuIndex * 2}',
        colour: 'Color $skuIndex',
        accUnit: 'Unit $skuIndex',
        upcEan: 'UPC-$skuIndex',
      );
    }).toList();

    setState(() {
      _products.addAll(newProducts);
      _isLoading = false;
      _hasMore = _products.length < _totalItems;
      _page++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Row(
        children: [
          // Sidebar
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWideScreen ? 240 : 200,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
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
          // Main Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Products(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue),
                    child: const Text('Create Products'),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!_isLoading &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {
                          _loadMoreProducts();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        itemCount: _products.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= _products.length) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final product = _products[index];
                          return ProductCard(
                            sku: product.sku,
                            category: product.category,
                            brand: product.brand,
                            mrp: product.mrp,
                            createdDate: product.createdDate,
                            lastUpdated: product.lastUpdated,
                            listedOn: product.listedOn,
                            accSku: product.accSku,
                            colour: product.colour,
                            accUnit: product.accUnit,
                            upcEan: product.upcEan,
                          );
                        },
                      ),
                    ),
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
