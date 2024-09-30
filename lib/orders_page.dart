import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_management/model/orders_model.dart';
import 'package:inventory_management/provider/orders_provider.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class OrdersNewPage extends StatefulWidget {
  const OrdersNewPage({super.key});

  @override
  State<OrdersNewPage> createState() => _OrdersNewPageState();
}

class _OrdersNewPageState extends State<OrdersNewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Order> _filteredOrders = []; // To store the filtered orders
  String _searchQuery = '';
  Timer? _debounce;

  int currentPage = 1;
  int totalOrders = 0;

  final ordersProvider = OrdersProvider();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 2 tabs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);
      ordersProvider.fetchOrders(page: currentPage, limit: 20).then((_) {
        setState(() {
          _filteredOrders = ordersProvider.orders; // Initialize with all orders
        });
      });
    });
  }

  // Function to load more combos
  void loadMoreOrders() async {
    currentPage++;
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    await ordersProvider.fetchOrders(page: currentPage, limit: 20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Column(
            children: [
              // A row with Filter, Sort by dropdown, and Search bar
              Container(
                color: AppColors.primaryBlue,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Implement filter logic here
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      child: const Text('Filter',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: 'Sort by',
                      items: const [
                        DropdownMenuItem(
                            value: 'Sort by', child: Text('Sort by')),
                        DropdownMenuItem(value: 'Date', child: Text('Date')),
                        DropdownMenuItem(
                            value: 'Amount', child: Text('Amount')),
                      ],
                      onChanged: (value) {
                        // Implement sorting logic here
                      },
                    ),
                    const Spacer(),
                    Container(
                      width: 500,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        onChanged: _searchOrderById,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          hintText: 'Search Orders',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                controller: _tabController,
                tabs: const [
                  Tab(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Ready To Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Failed Orders',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
                indicatorColor: AppColors.primaryBlue,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Content for "Ready to Confirm"
          buildOrdersList(context, false),
          // Content for "Failed Orders"
          buildOrdersList(context, true),
        ],
      ),
    );
  }

  void _searchOrderById(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 1000), () {
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);

      setState(() {
        _searchQuery = query; // Update the search query
      });

      if (query.isEmpty) {
        setState(() {
          _filteredOrders = ordersProvider.orders; // Reset to all orders
        });
      } else {
        // Fetch the order by ID after debouncing
        ordersProvider.fetchOrderById(query).then((fetchedOrders) {
          setState(() {
            _filteredOrders = fetchedOrders; // Update with fetched orders
          });
        }).catchError((error) {
          print('Error fetching order by ID: $error');
          setState(() {
            _filteredOrders = []; // Optionally clear the filtered orders
          });
        });
      }
    });
  }

  Widget buildOrdersList(BuildContext context, bool showConfirmedButton) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    // Check loading state
    if (ordersProvider.isLoading) {
      return const Center(child: CircularProgressIndicator()); // Loading state
    } else if (ordersProvider.orders.isEmpty) {
      return const Center(child: Text('No orders found.')); // No orders state
    }

    List<Order> orders =
        _searchQuery.isEmpty ? ordersProvider.orders : _filteredOrders;

    return Column(
      children: [
        // Row showing selected orders and action buttons
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${ordersProvider.selectedOrders.where((selected) => selected).length} orders selected',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 50),
              ElevatedButton.icon(
                onPressed: () {
                  // Implement "Print Picklist" functionality here
                },
                icon: const Icon(Icons.print, color: Colors.white),
                label: const Text('Print Picklist',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue),
              ),
              const SizedBox(width: 30),
              ElevatedButton.icon(
                onPressed: () {
                  // Implement "Print Pickingslip" functionality here
                },
                icon: const Icon(Icons.print, color: Colors.white),
                label: const Text('Print Pickingslip',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue),
              ),
              const Spacer(),
              if (showConfirmedButton) ...[
                ElevatedButton(
                  onPressed: () {
                    // Implement "Confirmed" functionality here
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue),
                  child: const Text('Confirmed',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ],
          ),
        ),

        // Header for "Ready to Confirm" or "Failed Orders"
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: ordersProvider.selectAll,
                    onChanged: (value) => ordersProvider.toggleSelectAll(value),
                  ),
                  const Text('Select All'),
                ],
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                surfaceTintColor: Colors.white,
                elevation: 0.5,
                //color: Colors.white,
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Checkbox(
                              value: order.isSelected,
                              onChanged: (value) => ordersProvider
                                  .toggleOrderSelection(index, value ?? false),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Order ID: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                order.orderId,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ordersProvider.formatDate(order.date!),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Amount: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Rs. ${order.totalAmount}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Items: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${order.items.fold(0, (total, item) => total + item.qty)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Weight: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${order.totalWeight}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: AppColors.grey,
                      ),

                      // Nested cards for each item in the order
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.items.length,
                        itemBuilder: (context, itemIndex) {
                          final item = order.items[itemIndex];

                          return Card(
                            surfaceTintColor: Colors.white,
                            elevation: 0.5,
                            //color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Product ${itemIndex + 1}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // Display the Shopify image
                                      if (item.product?.shopifyImage != null &&
                                          item.product!.shopifyImage.isNotEmpty)
                                        Image.network(
                                          item.product!.shopifyImage,
                                          key: ValueKey(
                                              item.product!.shopifyImage),
                                          width: 50, // Set desired width
                                          height: 50, // Set desired height
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            // Handle image load error gracefully
                                            return const SizedBox(
                                              width: 200,
                                              height: 200,
                                              child: Icon(
                                                Icons.image,
                                                size: 100,
                                                color: AppColors.grey,
                                              ), // Placeholder for missing image
                                            ); // Display an error icon
                                          },
                                        )
                                      else
                                        const SizedBox(
                                          width: 200,
                                          height: 200,
                                          child: Icon(
                                            Icons.image,
                                            size: 100,
                                            color: AppColors.grey,
                                          ), // Placeholder for missing image
                                        ),
                                      if (item.product != null) ...[
                                        const SizedBox(height: 4.0),
                                        Text(
                                            'Product Name: ${item.product?.displayName}'),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //Text('Item ID: ${item.id}'),
                                        Row(
                                          children: [
                                            const Text(
                                              'SKU: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text('${item.product?.sku}')
                                          ],
                                        ),

                                        const SizedBox(width: 20.0),
                                        Row(
                                          children: [
                                            const Text(
                                              'Quantity:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${item.qty}',
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            'Total Item Amount: Rs.${item.amount}'),

                                        const SizedBox(height: 4.0),
                                        Text(
                                            'Description: ${item.product?.description}'),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            'Technical Name: ${item.product?.technicalName}'),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            'Product Weight: ${item.product?.weight}'),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            'Product MRP: Rs.${item.product?.mrp}'),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            'Product Cost: Rs.${item.product?.cost}'),
                                        const SizedBox(width: 8.0),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //Text('Item ID: ${item.id}'),

                                        Text(
                                            'Payment Mode: ${order.paymentMode}'),
                                        const SizedBox(width: 8.0),
                                        Text('COD Amount: ${order.codAmount}'),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            'Prepaid Amount: ${order.prepaidAmount}'),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            'Discount Scheme: ${order.discountScheme}'),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            'Discount Percent: ${order.discountPercent}'),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            'Dicount Amount: ${order.discountAmount}'),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            'Tax Percent: ${order.taxPercent}'),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            'Shipping Address: ${order.shippingAddress}'),
                                        const SizedBox(width: 8.0),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //Text('Item ID: ${item.id}'),
                                        Text(
                                            'Product Grade: ${item.product?.grade}'),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            'Parent SKU: ${item.product?.parentSku}'),
                                        const SizedBox(width: 8.0),
                                        Text('Active: ${item.product?.active}'),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            'Courier Name: ${order.courierName}'),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            'Replacement: ${order.replacement}'),
                                        const SizedBox(width: 8.0),
                                        Text('Order Agent: ${order.agent}'),
                                        const SizedBox(width: 8.0),
                                        Text(
                                            'Order Status: ${order.orderStatus}'),
                                        const SizedBox(width: 8.0),
                                        Text('Note: ${order.notes}'),
                                        const SizedBox(width: 8.0),
                                        // if (item.product != null) ...[
                                        //   const SizedBox(height: 4.0),
                                        //   Text(
                                        //       'Category: ${item.product?.category}'),
                                        //   Text('Label: ${item.product?.label}'),
                                        // ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.orderStatusMap.length,
                        itemBuilder: (context, itemIndex) {
                          final orderStatusMap =
                              order.orderStatusMap[itemIndex];

                          // return Row(
                          //   children: [
                          //     Text('Order Status :${orderStatusMap.status}')
                          //   ],
                          // );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Pagination Controls
        if (!ordersProvider.isLoading && ordersProvider.orders.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: currentPage > 1
                      ? () {
                          setState(() {
                            currentPage--;
                          });
                          loadMoreOrders();
                        }
                      : null,
                  child: const Text('Previous'),
                ),
              ),
              Text('Page $currentPage'),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    loadMoreOrders();
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          )
        ],
      ],
    );
  }
}
