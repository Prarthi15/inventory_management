import 'package:flutter/material.dart';
import 'package:inventory_management/Custom-Files/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:inventory_management/Custom-Files/data_table.dart';
import 'package:inventory_management/provider/inventory_provider.dart';
import 'package:inventory_management/Custom-Files/custom_pagination.dart';

class ManageInventoryPage extends StatefulWidget {
  const ManageInventoryPage({super.key});

  @override
  _ManageInventoryPageState createState() => _ManageInventoryPageState();
}

class _ManageInventoryPageState extends State<ManageInventoryPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _pageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InventoryProvider>(context, listen: false).fetchInventory();
    });
  }

  void _goToPage(int page) {
    final provider = Provider.of<InventoryProvider>(context, listen: false);
    provider.goToPage(page);
  }

  void _jumpToPage() {
    final provider = Provider.of<InventoryProvider>(context, listen: false);
    int page = int.tryParse(_pageController.text) ?? 0;
    if (page > 0 && page <= provider.totalPages) {
      _goToPage(page - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InventoryProvider>(context);
    List<String> columnNames = [
      'COMPANY NAME',
      'CATEGORY',
      'IMAGE',
      'BRAND',
      'SKU',
      'PRODUCT NAME',
      'MODEL NO',
      'MRP',
      'QUANTITY',
      'ACTIONS',
      'FLIPKART',
      'SNAPDEAL',
      'AMAZON.IN',
    ];

    final paginatedData = provider.getPaginatedData();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar and scrolling buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left,
                      color: AppColors.primaryGreen),
                  onPressed: () {
                    _scrollController.animateTo(
                      _scrollController.position.pixels - 200,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: AppColors.primaryGreen),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search,
                              color: AppColors.primaryGreen),
                          onPressed: () {
                            print('Search: ${_searchController.text}');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_right,
                      color: AppColors.primaryGreen),
                  onPressed: () {
                    _scrollController.animateTo(
                      _scrollController.position.pixels + 200,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: provider.isLoading
                  ? const Center(child: InventoryLoadingAnimation())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          InventoryDataTable(
                            columnNames: columnNames,
                            rowsData: paginatedData,
                            scrollController: _scrollController,
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            // Custom pagination footer
            CustomPaginationFooter(
              currentPage: provider.currentPage,
              totalPages: provider.totalPages,
              buttonSize: MediaQuery.of(context).size.width > 600 ? 32 : 24,
              pageController: _pageController,
              onFirstPage: () => _goToPage(0),
              onLastPage: () => _goToPage(provider.totalPages - 1),
              onNextPage: () {
                if (provider.currentPage < provider.totalPages - 1) {
                  _goToPage(provider.currentPage + 1);
                }
              },
              onPreviousPage: () {
                if (provider.currentPage > 0) {
                  _goToPage(provider.currentPage - 1);
                }
              },
              onGoToPage: _goToPage,
              onJumpToPage: _jumpToPage,
            ),
          ],
        ),
      ),
    );
  }
}
