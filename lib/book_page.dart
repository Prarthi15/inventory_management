import 'package:flutter/material.dart';
import 'package:inventory_management/Api/orders_api.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:inventory_management/Custom-Files/loading_indicator.dart';
import 'package:inventory_management/Custom-Files/show-details-order-item.dart';
import 'package:inventory_management/model/orders_model.dart';
import 'package:inventory_management/provider/book_provider.dart';
import 'package:inventory_management/provider/orders_provider.dart';
import 'package:provider/provider.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<Order> _filteredOrders = []; // To store the filtered orders
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Search Orders',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  // Implement filter logic here
                },
                color: Colors.black,
              ),
              DropdownButton<String>(
                value: 'Sort by',
                items: const [
                  DropdownMenuItem(value: 'Sort by', child: Text('Sort by')),
                  DropdownMenuItem(value: 'Date', child: Text('Date')),
                  DropdownMenuItem(value: 'Amount', child: Text('Amount')),
                ],
                onChanged: (value) {
                  // Implement sorting logic here
                },
              ),
              const SizedBox(width: 10),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'B2B'),
                  Tab(text: 'B2C'),
                ],
                indicatorColor: AppColors.primaryBlue,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorWeight: 3,
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // B2B Content
                    Container(
                      color: AppColors.greyBackground,
                      child: _b2b(bookProvider, 2),
                    ),
                    // B2C Content
                    Container(
                      color: AppColors.greyBackground,
                      child: _b2c(bookProvider),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _b2b(BookProvider bookProvider, int statusFilter) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final OrdersApi ordersApi = OrdersApi();

    // Check loading state
    if (ordersProvider.isLoading) {
      return const Center(child: OrdersLoadingAnimation());
    }

    List<Order> orders =
        _searchQuery.isEmpty ? ordersProvider.orders : _filteredOrders;

    orders =
        orders.where((order) => order.orderStatus == statusFilter).toList();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 190, // Adjust width as needed
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50, // Fixed width for the select all checkbox
                        child: Transform.scale(
                          scale: 1,
                          child: Column(
                            children: [
                              Checkbox(
                                value: bookProvider.selectAllB2B,
                                onChanged: (bool? value) {
                                  bookProvider
                                      .toggleSelectAllB2B(value ?? false);
                                },
                                activeColor: Colors.blue,
                                checkColor: Colors.white,
                                side: const BorderSide(color: Colors.blue),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text('Select All (${bookProvider.selectedB2BCount})'),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                const Expanded(
                  flex: 5,
                  child: Text(
                    'PRODUCTS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                const Expanded(
                  flex: 1,
                  child: Text(
                    'DELIVERY',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                const Expanded(
                  flex: 1,
                  child: Text(
                    'SHIPROCKET',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10), // Space after the row header
          const SizedBox(height: 8), // Additional space
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: bookProvider.selectedB2BProducts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50, // Fixed width for checkboxes
                      child: Transform.scale(
                        scale: 1,
                        child: Checkbox(
                          value: bookProvider.selectedB2BProducts[index],
                          onChanged: (bool? value) {
                            bookProvider.toggleProductSelectionB2B(
                                index, value ?? false);
                          },
                          activeColor: Colors.blue,
                          checkColor: Colors.white,
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 170), // Space between checkbox and product info
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ORDER ID: KSK-2599${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(
                              height: 12), // Increased space after checkbox
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nemotude Plus (Bio Pesticides verticillium chalamydosporium 1% WP)',
                                      style: TextStyle(fontSize: 16),
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          'SKU : k-5560 ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          'Quantity : 10 ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.grey),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Motude Plus (Bio Pesticides verticillium chalamydosporium 1% WP)',
                                      style: TextStyle(fontSize: 16),
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          'SKU : k-9560 ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          'Quantity : 04 ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Rs. 2000',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Rs. 2000',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _b2c(BookProvider bookProvider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 190, // Adjust width as needed to match B2B
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50, // Fixed width for the select all checkbox
                        child: Transform.scale(
                          scale: 1,
                          child: Column(
                            children: [
                              Checkbox(
                                value: bookProvider.selectAllB2C,
                                onChanged: (bool? value) {
                                  bookProvider
                                      .toggleSelectAllB2C(value ?? false);
                                },
                                activeColor: Colors.blue,
                                checkColor: Colors.white,
                                side: const BorderSide(color: Colors.blue),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text('Select All (${bookProvider.selectedB2CCount})'),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                const Expanded(
                  flex: 5,
                  child: Text(
                    'PRODUCTS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                const Expanded(
                  flex: 1,
                  child: Text(
                    'DELIVERY',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                const Expanded(
                  flex: 1,
                  child: Text(
                    'SHIPROCKET',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10), // Space after the row header
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: bookProvider.selectedB2CProducts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50, // Fixed width for checkboxes
                      child: Transform.scale(
                        scale: 1,
                        child: Checkbox(
                          value: bookProvider.selectedB2CProducts[index],
                          onChanged: (bool? value) {
                            bookProvider.toggleProductSelectionB2C(
                                index, value ?? false);
                          },
                          activeColor: Colors.blue,
                          checkColor: Colors.white,
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 170), // Space between checkbox and product info
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ORDER ID: KSK-2599${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(
                              height: 12), // Increased space after checkbox
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nemotude Plus (Bio Pesticides verticillium chalamydosporium 1% WP)',
                                      style: TextStyle(fontSize: 16),
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          'SKU : k-5560 ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          'Quantity : 10 ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.grey),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Motude Plus (Bio Pesticides verticillium chalamydosporium 1% WP)',
                                      style: TextStyle(fontSize: 16),
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          'SKU : k-9560 ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          'Quantity : 04 ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Rs. 2000',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Rs. 2000',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
