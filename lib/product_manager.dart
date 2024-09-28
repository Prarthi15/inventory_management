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
            //weight: data['weight']?.toString() ?? '-',
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

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Row(
        children: [
          // Sidebar
          if (!_showCreateProduct)
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!_showCreateProduct)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showCreateProduct = !_showCreateProduct;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue),
                          child: const Text('Create Products'),
                        )
                      else
                        CustomButton(
                          width: 40,
                          height: 40,
                          onTap: () {
                            setState(() {
                              _showCreateProduct = !_showCreateProduct;
                            });
                          },
                          color: AppColors.lightBlue,
                          textColor: AppColors.black,
                          fontSize: 12,
                          text: 'Back',
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
                                  product: product,
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
