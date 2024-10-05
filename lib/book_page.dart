import 'package:flutter/material.dart';
import 'package:inventory_management/Api/orders_api.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:inventory_management/Custom-Files/dropdown.dart';
import 'package:inventory_management/Custom-Files/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:inventory_management/provider/book_provider.dart';
import 'package:inventory_management/model/orders_model.dart';
import 'package:inventory_management/Widgets/order_card.dart';
import 'package:inventory_management/Api/orders_api.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _showBackToTopButton = false;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset >= 400) {
        setState(() {
          _showBackToTopButton = true;
        });
      } else {
        setState(() {
          _showBackToTopButton = false;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      bookProvider.fetchOrders('B2B');
      bookProvider.fetchOrders('B2C');
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: _buildAppBarTitle(),
          bottom: _buildTabBar(),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOrderList('B2B'),
              _buildOrderList('B2C'),
            ],
          ),
        ),
        floatingActionButton: _showBackToTopButton
            ? GestureDetector(
                onTap: _scrollToTop,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6A1B9A), // Start color
                        Color(0xFF8E24AA), // End color
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 5), // Shadow positioning
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: _buildSearchBar(),
        ),
        const Spacer(),
        _buildFilterButton(),
        _buildSortDropdown(),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            final bookProvider =
                Provider.of<BookProvider>(context, listen: false);
            bookProvider.fetchOrders('B2B');
            bookProvider.fetchOrders('B2C');
            // Optionally show a message to indicate reloading
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Content refreshed')),
            );
          },
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Consumer<BookProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(183, 6, 90, 216),
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
            controller: provider.searchController,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Search Orders',
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              prefixIcon: Icon(Icons.search, color: Colors.white),
            ),
            onChanged: (value) {
              provider.onSearchChanged();
            },
          ),
        );
      },
    );
  }

  Widget _buildFilterButton() {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () {
        print('Filter button pressed');
      },
      color: Colors.black,
    );
  }

  Widget _buildSortDropdown() {
    return Consumer<BookProvider>(
      builder: (context, provider, child) {
        return CustomDropdown<String>(
          items: const ['Date', 'Amount'],
          selectedItem: provider.sortOption,
          hint: 'Sort by',
          onChanged: (value) {
            provider.setSortOption(value);
          },
          hintStyle: const TextStyle(color: Colors.black54),
          itemStyle: const TextStyle(color: Colors.black),
          borderColor: Colors.grey,
          borderWidth: 1.0,
        );
      },
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'B2B'),
          Tab(text: 'B2C'),
        ],
        indicatorColor: Colors.blue,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorWeight: 3,
      ),
    );
  }

  Widget _buildOrderList(String orderType) {
    final bookProvider = Provider.of<BookProvider>(context);
    List<Order> orders =
        orderType == 'B2B' ? bookProvider.ordersB2B : bookProvider.ordersB2C;

    int selectedCount = orders.where((order) => order.isSelected).length;

    return Column(
      children: [
        // Add the Confirm button here
        _buildConfirmButton(orderType),
        _buildTableHeader(orderType, selectedCount),
        Expanded(
          child: bookProvider.isLoadingB2B || bookProvider.isLoadingB2C
              ? const Center(child: BookLoadingAnimation())
              : orders.isEmpty
                  ? const Center(child: Text('No orders found'))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            _buildOrderCard(orders[index], orderType),
                            const Divider(thickness: 1, color: Colors.grey),
                          ],
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(String orderType) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ElevatedButton(
          onPressed: () async {
            final bookProvider =
                Provider.of<BookProvider>(context, listen: false);
            List<String> selectedOrderIds = [];

            // Collect selected order IDs based on the order type
            if (orderType == 'B2B') {
              for (int i = 0; i < bookProvider.ordersB2B.length; i++) {
                if (bookProvider.ordersB2B[i].isSelected) {
                  selectedOrderIds.add(bookProvider.ordersB2B[i].orderId!);
                }
              }
            } else {
              for (int i = 0; i < bookProvider.ordersB2C.length; i++) {
                if (bookProvider.ordersB2C[i].isSelected) {
                  selectedOrderIds.add(bookProvider.ordersB2C[i].orderId!);
                }
              }
            }

            // If no orders are selected, show a message
            if (selectedOrderIds.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No orders selected')),
              );
              return;
            }

            // Create an instance of OrderApi
            final orderApi = OrdersApi();

            // Update the status of selected orders
            for (String orderId in selectedOrderIds) {
              try {
                await orderApi.updateOrderStatus(
                    context, orderId, 3); // Update status to 3
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Failed to update order $orderId: $e')),
                );
              }
            }

            // Optionally, refresh the orders after updating
            await bookProvider.fetchOrders(orderType);
          },
          child: Text(
            orderType == 'B2B' ? 'Confirm B2B Orders' : 'Confirm B2C Orders',
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(String orderType, int selectedCount) {
    final bookProvider = Provider.of<BookProvider>(context);
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: orderType == 'B2B'
                      ? bookProvider.selectAllB2B
                      : bookProvider.selectAllB2C,
                  onChanged: (value) {
                    bookProvider.toggleSelectAll(orderType == 'B2B', value);
                  },
                ),
                Text("Select All ($selectedCount)"),
              ],
            ),
          ),
          buildHeader('PRODUCTS', flex: 4),
          buildHeader('DELIVERY', flex: 3),
          buildHeader('SHIPROCKET', flex: 3),
        ],
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  Widget buildHeader(String title, {int flex = 1}) {
    return Flexible(
      flex: flex,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order, String orderType) {
    final bookProvider = Provider.of<BookProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Checkbox(
              value: order.isSelected,
              onChanged: (value) {
                bookProvider.handleRowCheckboxChange(
                  order.orderId,
                  value!,
                  orderType == 'B2B',
                );
              },
            ),
          ),
          const SizedBox(width: 150),
          Expanded(
            flex: 4,
            child: OrderCard(
              order: order,
            ),
          ),
          const SizedBox(width: 20),
          buildCell(order.freightCharge!.delhivery.toString(), flex: 3),
          const SizedBox(width: 20),
          buildCell(order.freightCharge!.shiprocket.toString(), flex: 3),
        ],
      ),
    );
  }

  Widget buildCell(String content, {int flex = 1}) {
    return Flexible(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "₹ $content",
              style: const TextStyle(
                color: AppColors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
