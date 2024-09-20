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
  final int _itemsPerPage = 10;
  final int _totalItems = 50;
  final List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  bool _showCreateProduct = false;
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

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await authProvider.getAllProducts();

      if (response['success']) {
        final List<dynamic> productData = response['data'];
        final newProducts = productData.map((data) {
          return Product(
              sku: data['sku'] ?? '-',
              category: data['category'] ?? '-',
              brand: data['brand'] ?? '-',
              mrp: data['mrp']?.toString() ?? '-',
              createdDate: data['createdAt'] ?? '-',
              lastUpdated: data['updatedAt'] ?? '-',
              accSku: data['parentSku'] ?? '-',
              colour: data['colour'] ?? '-',
              upcEan: data['ean'] ?? '-');
        }).toList();

        setState(() {
          _products.addAll(newProducts);
          _isLoading = false;
          _hasMore = _products.length < _totalItems;
          _page++;
        });
      } else {
        // Handle API failure (e.g., show an error message)
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      }
    } catch (error) {
      // Handle exceptions or network errors
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Row(
        children: [
          // Sidebar
          !_showCreateProduct
              ? ConstrainedBox(
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
                )
              : const SizedBox(),
          // Main Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !_showCreateProduct
                      ? ElevatedButton(
                          onPressed: () {
                            _showCreateProduct = !_showCreateProduct;
                            print("here is show product $_showCreateProduct");
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue),
                          child: const Text('Create Products'),
                        )
                      : CustomButton(
                          width: 40,
                          height: 40,
                          onTap: () {
                            _showCreateProduct = !_showCreateProduct;
                            //  print("here is show product $_showCreateProduct");
                            setState(() {});
                          },
                          color: AppColors.lightBlue,
                          textColor: AppColors.black,
                          fontSize: 12,
                          text: 'Back'),
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
                            child: ListView.builder(
                              itemCount:
                                  _products.length + (_isLoading ? 1 : 0),
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
                                  accSku: product.accSku,
                                  colour: product.colour,
                                  upcEan: product.upcEan,
                                );
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
