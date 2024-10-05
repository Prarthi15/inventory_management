import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_management/Api/orders_api.dart';
import 'package:inventory_management/Custom-Files/custom_pagination.dart';
import 'package:inventory_management/Custom-Files/loading_indicator.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _pageController = TextEditingController();
  final OrdersApi _ordersApi = OrdersApi();
  List<Order> _displayedOrders = [];

  List<Order> _filteredOrders = []; // To store the filtered orders
  String _searchQuery = '';
  Timer? _debounce;

  int currentPage = 1;
  int totalOrders = 0;

  List<Order> selectedOrders = []; // Orders selected by the user
  List<Order> failedOrders = []; // Orders that failed to update
  List<Order> readyToConfirmOrders = []; // Orders ready to confirm

  final ordersProvider = OrdersProvider();

  Future<void> refreshOrders() async {
    try {
      await ordersProvider.fetchOrders(); // Assuming this fetches all orders
      // Optionally, you can also notify the user that the orders have been refreshed
      showSnackbar('Orders refreshed successfully!',
          backgroundColor: Colors.green);
    } catch (error) {
      print('Error refreshing orders: $error');
      showSnackbar('Failed to refresh orders: $error',
          backgroundColor: Colors.red);
    }
  }

  void showSnackbar(String message, {Color backgroundColor = Colors.black}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2), // Adjust duration as needed
      ),
    );
  }

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
    print('current page = $currentPage');
  }

  @override
  Widget build(BuildContext context) {
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
                  onChanged: (value) {
                    _onSearchChanged(); // Trigger search when text changes
                  },
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
              Tab(text: 'Ready To Confirm'),
              Tab(text: 'Failed Orders'),
            ],
            indicatorColor: AppColors.primaryBlue,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 3,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Content for "Ready to Confirm"
          buildReadyToConfirmList(context, false, 1),
          // Content for "Failed Orders"
          buildOrdersList(context, true, 0),
        ],
      ),
    );
  }

  void _onSearchChanged() async {
    String searchTerm = _searchController.text;
    print('Searching for: $searchTerm'); // Debugging line

    // Check which tab is currently active
    if (_tabController.index == 0) {
      List<Order> filteredOrders =
          await _ordersApi.searchReadyToConfirmOrders(searchTerm);
      setState(() {
        _displayedOrders = filteredOrders;
      });
    } else if (_tabController.index == 1) {
      List<Order> filteredOrders =
          await _ordersApi.searchFailedOrders(searchTerm);
      setState(() {
        _displayedOrders = filteredOrders;
      });
    }
  }

  Widget buildOrdersList(
      BuildContext context, bool showApproveButton, int statusFilter) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final OrdersApi ordersApi = OrdersApi();

    // Check loading state
    if (ordersProvider.isLoading) {
      return const Center(child: OrdersLoadingAnimation()); // Loading state
    }

    List<Order> orders =
        _searchQuery.isEmpty ? ordersProvider.orders : _filteredOrders;

    orders =
        orders.where((order) => order.orderStatus == statusFilter).toList();

    return Column(children: [
      // Row showing selected orders and action buttons
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${ordersProvider.orders.where((order) => order.isSelected && order.orderStatus == 0).length} Orders Selected', // Only count failed orders
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            // Button for approving failed orders (from 0 to 1)
            if (showApproveButton) ...[
              ElevatedButton(
                onPressed: () async {
                  List<Order> selectedOrders = ordersProvider.selectedOrders;

                  if (selectedOrders.isEmpty) {
                    showSnackbar(
                        'No items selected. Please select orders to approve.',
                        backgroundColor: Colors.red);
                    return; // Exit the function early
                  }

                  // Separate the selected order IDs for failed orders
                  List<String> failedOrderIds = selectedOrders
                      .where((order) =>
                          order.orderStatus == 0) // Only failed orders
                      .map((order) => order.orderId!)
                      .toList();

                  // Update failed orders
                  if (failedOrderIds.isNotEmpty) {
                    await ordersApi.updateFailedOrders(context, failedOrderIds);
                    // Refresh the orders after successful update
                    await refreshOrders(); // Add this line
                  }

                  print('Failed orders have been processed.');
                  setState() {}
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cardsred),
                child: const Text('Approve Failed Orders',
                    style: TextStyle(color: Colors.white)),
              ),
            ]
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
                  value:
                      ordersProvider.readyToConfirmSelectAll, // Correct binding
                  onChanged: (value) {
                    ordersProvider
                        .toggleReadyToConfirmSelectAll(value); // Correct method
                  },
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
              color: const Color.fromARGB(255, 231, 230, 230),
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
                            onChanged: (value) =>
                                ordersProvider.toggleOrderSelection(
                                    order.orderId!,
                                    value ?? false), // Use orderId
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
                              order.orderId ?? '',
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
                              'Rs. ${order.totalAmount ?? ''}',
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
                              '${order.items.fold(0, (total, item) => total + item.qty!)}',
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
                              '${order.totalWeight ?? ''}',
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            //color: AppColors.primaryBlue,
                            child: const SizedBox(
                              height: 50,
                              width: 200,
                              child: Text(
                                'ORDER DETAILS:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // Container(
                          //   color: Colors.pink,
                          //   child: const SizedBox(height: 10, width: 200.0),
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Payment Mode: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(order.paymentMode ?? ''),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              Row(
                                children: [
                                  const Text(
                                    'COD Amount: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('${order.codAmount ?? ''}'),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              Row(
                                children: [
                                  const Text(
                                    'Prepaid Amount: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('${order.prepaidAmount ?? ''}'),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              Row(
                                children: [
                                  const Text(
                                    'Discount Scheme: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(order.discountScheme ?? ''),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Discount Percent: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('${order.discountPercent ?? ''}'),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              Row(
                                children: [
                                  const Text(
                                    'Discount Amount: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('${order.discountAmount ?? ''}'),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              Row(
                                children: [
                                  const Text(
                                    'Tax Percent: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('${order.taxPercent ?? ''}'),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              Row(
                                children: [
                                  const Text(
                                    'Shipping Address: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(order.shippingAddress?.address1 ??
                                      'No address available'),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row(
                              //   children: [
                              //     const Text(
                              //       'Delivery: ',
                              //       style:
                              //           TextStyle(fontWeight: FontWeight.bold),
                              //     ),
                              //     Text(
                              //         '${order.freightCharge!.delhivery ?? ''}'),
                              //   ],
                              // ),
                              // const SizedBox(width: 8.0),
                              // Row(
                              //   children: [
                              //     const Text(
                              //       'Shiprocket: ',
                              //       style:
                              //           TextStyle(fontWeight: FontWeight.bold),
                              //     ),
                              //     Text(
                              //         '${order.freightCharge!.shiprocket ?? ''}'),
                              //   ],
                              // ),
                              const SizedBox(width: 8.0),
                              Row(
                                children: [
                                  const Text(
                                    'Agent: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(order.agent ?? ''),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              Row(
                                children: [
                                  const Text(
                                    'Notes: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(order.notes ?? ''),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                            ],
                          ),

                          const SizedBox(width: 20.0),
                        ],
                      ),
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
                          color: AppColors.white,
                          elevation: 0.5,
                          margin: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Product ${itemIndex + 1}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 2.0),
                                    if (item.product?.shopifyImage != null &&
                                        item.product!.shopifyImage!.isNotEmpty)
                                      Image.network(
                                        item.product!.shopifyImage!,
                                        key: ValueKey(
                                            item.product!.shopifyImage),
                                        width: 140,
                                        height: 140,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Icon(
                                              Icons.image,
                                              size: 70,
                                              color: AppColors.grey,
                                            ),
                                          );
                                        },
                                      )
                                    else
                                      const SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Icon(
                                          Icons.image,
                                          size: 70,
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    const SizedBox(height: 5.0),
                                    Container(
                                      width: 370, // Set your desired width here
                                      child: Text(
                                        item.product?.displayName ?? 'No Name',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildInfoRow('SKU:', item.product?.sku),
                                      _buildInfoRow(
                                          'Quantity:', item.qty?.toString()),
                                      _buildInfoRow(
                                          'Total Amount:', 'Rs.${item.amount}'),
                                      _buildInfoRow('Description:',
                                          item.product?.description),
                                      _buildInfoRow('Technical Name:',
                                          item.product?.technicalName),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildInfoRow('Dimensions:',
                                                    '${item.product?.dimensions?.length} x ${item.product?.dimensions?.width} x ${item.product?.dimensions?.height}'),
                                                _buildInfoRow('Tax Rule:',
                                                    item.product?.taxRule),
                                                _buildInfoRow('Brand:',
                                                    item.product?.brand),
                                                _buildInfoRow('MRP:',
                                                    'Rs.${item.product?.mrp}'),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildInfoRow('Product Grade:',
                                                    item.product?.grade),
                                                _buildInfoRow('Parent SKU:',
                                                    item.product?.parentSku),
                                                _buildInfoRow(
                                                    'Active:',
                                                    item.product?.active
                                                        ?.toString()),
                                                _buildInfoRow('Courier Name:',
                                                    order.courierName),
                                                _buildInfoRow('Order Status:',
                                                    '${order.orderStatus}'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemCount: order.orderStatusMap!.length,
                    //   itemBuilder: (context, itemIndex) {
                    //     final orderStatusMap = order.orderStatusMap![itemIndex];

                    //     return Row(
                    //       children: [
                    //         Text('Order Status :${orderStatusMap.status}')
                    //       ],
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // Pagination Footer - keep as is, always show even when no orders found
      CustomPaginationFooter(
        currentPage: ordersProvider.failedOrdersPage - 1, // zero-based index
        totalPages:
            ordersProvider.totalFailedOrderPages, // Total number of pages
        buttonSize: 30.0,
        pageController:
            _pageController, // Use a TextEditingController for "Go to Page"
        onFirstPage: () {
          ordersProvider.upDateFailedOrdersPage(1);
          ordersProvider.fetchOrders(
              page: 1, limit: 20, isReadyToConfirm: false);
        },
        onLastPage: () {
          ordersProvider
              .upDateFailedOrdersPage(ordersProvider.totalFailedOrderPages);
          ordersProvider.fetchOrders(
              page: ordersProvider.totalFailedOrderPages,
              limit: 20,
              isReadyToConfirm: false);
        },
        onNextPage: () {
          if (ordersProvider.failedOrdersPage <
              ordersProvider.totalFailedOrderPages) {
            ordersProvider
                .upDateFailedOrdersPage(ordersProvider.failedOrdersPage + 1);
            ordersProvider.fetchOrders(
                page: ordersProvider.failedOrdersPage,
                limit: 20,
                isReadyToConfirm: false);
          }
        },
        onPreviousPage: () {
          if (ordersProvider.failedOrdersPage > 1) {
            ordersProvider
                .upDateFailedOrdersPage(ordersProvider.failedOrdersPage - 1);
            ordersProvider.fetchOrders(
                page: ordersProvider.failedOrdersPage,
                limit: 20,
                isReadyToConfirm: false);
          }
        },
        onGoToPage: (page) {
          ordersProvider.upDateFailedOrdersPage(page + 1);
          ordersProvider.fetchOrders(
              page: page + 1, limit: 20, isReadyToConfirm: false);
        },
        onJumpToPage: () {
          int page = int.tryParse(_pageController.text) ?? 1;
          if (page >= 1 && page <= ordersProvider.totalFailedOrderPages) {
            ordersProvider.upDateFailedOrdersPage(page);
            ordersProvider.fetchOrders(
                page: page, limit: 20, isReadyToConfirm: false);
          }
        },
      )
    ]);
  }

  Widget buildReadyToConfirmList(
      BuildContext context, bool showApproveButton, int statusFilter) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final OrdersApi ordersApi = OrdersApi();

    // Check loading state
    if (ordersProvider.isLoading) {
      return const Center(child: OrdersLoadingAnimation()); // Loading state
    }

    List<Order> orders =
        _searchQuery.isEmpty ? ordersProvider.orders : _filteredOrders;

    orders =
        orders.where((order) => order.orderStatus == statusFilter).toList();

    return Column(
      children: [
        // Row showing selected orders and action buttons
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${ordersProvider.orders.where((order) => order.isSelected && order.orderStatus == 1).length} Orders Selected', // Only count failed orders
                style: const TextStyle(fontSize: 16),
              ),

              // const SizedBox(width: 50),
              // ElevatedButton.icon(
              //   onPressed: () {
              //     // Implement "Print Picklist" functionality here
              //   },
              //   icon: const Icon(Icons.print, color: Colors.white),
              //   label: const Text('Print Picklist',
              //       style: TextStyle(color: Colors.white)),
              //   style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColors.primaryBlue),
              // ),
              // const SizedBox(width: 30),
              // ElevatedButton.icon(
              //   onPressed: () {
              //     // Implement "Print Pickingslip" functionality here
              //   },
              //   icon: const Icon(Icons.print, color: Colors.white),
              //   label: const Text('Print Pickingslip',
              //       style: TextStyle(color: Colors.white)),
              //   style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColors.primaryBlue),
              // ),
              const Spacer(),
              if (showApproveButton = true) ...[
                ElevatedButton(
                  onPressed: () async {
                    List<Order> selectedOrders = ordersProvider.selectedOrders;

                    if (selectedOrders.isEmpty) {
                      showSnackbar(
                          'No items selected. Please select orders to approve.',
                          backgroundColor: Colors.red);
                      return; // Exit the function early
                    }

                    // Separate the selected order IDs for ready to confirm
                    List<String> readyToConfirmOrderIds = selectedOrders
                        .where((order) =>
                            order.orderStatus == 1) // Only ready to confirm
                        .map((order) => order.orderId!)
                        .toList();

                    // Update ready to confirm orders
                    if (readyToConfirmOrderIds.isNotEmpty) {
                      await ordersApi.updateReadyToConfirmOrders(
                          context, readyToConfirmOrderIds);
                      await refreshOrders(); // Add this line
                    }

                    print('Ready to confirm orders have been processed.');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue),
                  child: const Text('Confirm',
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
                    value:
                        ordersProvider.failedOrdersSelectAll, // Correct binding
                    onChanged: (value) {
                      ordersProvider
                          .toggleFailedOrdersSelectAll(value); // Correct method
                    },
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
                color: const Color.fromARGB(255, 231, 230, 230),
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
                              onChanged: (value) =>
                                  ordersProvider.toggleOrderSelection(
                                      order.orderId!,
                                      value ?? false), // Use orderId
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
                                order.orderId ?? '',
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
                                'Rs. ${order.totalAmount ?? ''}',
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
                                '${order.items.fold(0, (total, item) => total + item.qty!)}',
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
                                '${order.totalWeight ?? ''}',
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              //color: AppColors.primaryBlue,
                              child: const SizedBox(
                                height: 50,
                                width: 200,
                                child: Text(
                                  'ORDER DETAILS:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            // Container(
                            //   color: Colors.pink,
                            //   child: const SizedBox(height: 10, width: 200.0),
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Payment Mode: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(order.paymentMode ?? ''),
                                  ],
                                ),
                                const SizedBox(width: 8.0),
                                Row(
                                  children: [
                                    const Text(
                                      'COD Amount: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('${order.codAmount ?? ''}'),
                                  ],
                                ),
                                const SizedBox(width: 8.0),
                                Row(
                                  children: [
                                    const Text(
                                      'Prepaid Amount: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('${order.prepaidAmount ?? ''}'),
                                  ],
                                ),
                                const SizedBox(width: 8.0),
                                Row(
                                  children: [
                                    const Text(
                                      'Discount Scheme: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(order.discountScheme ?? ''),
                                  ],
                                ),
                                const SizedBox(width: 8.0),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Discount Percent: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('${order.discountPercent ?? ''}'),
                                  ],
                                ),
                                const SizedBox(width: 8.0),
                                Row(
                                  children: [
                                    const Text(
                                      'Discount Amount: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('${order.discountAmount ?? ''}'),
                                  ],
                                ),
                                const SizedBox(width: 8.0),
                                Row(
                                  children: [
                                    const Text(
                                      'Tax Percent: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('${order.taxPercent ?? ''}'),
                                  ],
                                ),
                                const SizedBox(width: 8.0),
                                Row(
                                  children: [
                                    const Text(
                                      'Shipping Address: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(order.shippingAddress?.address1 ??
                                        'No address available'),
                                  ],
                                ),
                                const SizedBox(width: 8.0),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row(
                                //   children: [
                                //     const Text(
                                //       'Delivery: ',
                                //       style:
                                //           TextStyle(fontWeight: FontWeight.bold),
                                //     ),
                                //     Text(
                                //         '${order.freightCharge!.delhivery ?? ''}'),
                                //   ],
                                // ),
                                // const SizedBox(width: 8.0),
                                // Row(
                                //   children: [
                                //     const Text(
                                //       'Shiprocket: ',
                                //       style:
                                //           TextStyle(fontWeight: FontWeight.bold),
                                //     ),
                                //     Text(
                                //         '${order.freightCharge!.shiprocket ?? ''}'),
                                //   ],
                                // ),
                                const SizedBox(width: 8.0),
                                Row(
                                  children: [
                                    const Text(
                                      'Agent: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(order.agent ?? ''),
                                  ],
                                ),
                                const SizedBox(width: 8.0),
                                Row(
                                  children: [
                                    const Text(
                                      'Notes: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(order.notes ?? ''),
                                  ],
                                ),
                                const SizedBox(width: 8.0),
                              ],
                            ),

                            const SizedBox(width: 20.0),
                          ],
                        ),
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
                            color: AppColors.white,
                            elevation: 0.5,
                            margin: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Product ${itemIndex + 1}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 2.0),
                                      if (item.product?.shopifyImage != null &&
                                          item.product!.shopifyImage!
                                              .isNotEmpty)
                                        Image.network(
                                          item.product!.shopifyImage!,
                                          key: ValueKey(
                                              item.product!.shopifyImage),
                                          width: 140,
                                          height: 140,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: Icon(
                                                Icons.image,
                                                size: 70,
                                                color: AppColors.grey,
                                              ),
                                            );
                                          },
                                        )
                                      else
                                        const SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Icon(
                                            Icons.image,
                                            size: 70,
                                            color: AppColors.grey,
                                          ),
                                        ),
                                      const SizedBox(height: 5.0),
                                      Container(
                                        width:
                                            370, // Set your desired width here
                                        child: Text(
                                          item.product?.displayName ??
                                              'No Name',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildInfoRow(
                                            'SKU:', item.product?.sku),
                                        _buildInfoRow(
                                            'Quantity:', item.qty?.toString()),
                                        _buildInfoRow('Total Amount:',
                                            'Rs.${item.amount}'),
                                        _buildInfoRow('Description:',
                                            item.product?.description),
                                        _buildInfoRow('Technical Name:',
                                            item.product?.technicalName),
                                        const Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _buildInfoRow('Dimensions:',
                                                      '${item.product?.dimensions?.length} x ${item.product?.dimensions?.width} x ${item.product?.dimensions?.height}'),
                                                  _buildInfoRow('Tax Rule:',
                                                      item.product?.taxRule),
                                                  _buildInfoRow('Brand:',
                                                      item.product?.brand),
                                                  _buildInfoRow('MRP:',
                                                      'Rs.${item.product?.mrp}'),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _buildInfoRow(
                                                      'Product Grade:',
                                                      item.product?.grade),
                                                  _buildInfoRow('Parent SKU:',
                                                      item.product?.parentSku),
                                                  _buildInfoRow(
                                                      'Active:',
                                                      item.product?.active
                                                          ?.toString()),
                                                  _buildInfoRow('Courier Name:',
                                                      order.courierName),
                                                  _buildInfoRow('Order Status:',
                                                      '${order.orderStatus}'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )

                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemCount: order.orderStatusMap!.length,
                      //   itemBuilder: (context, itemIndex) {
                      //     final orderStatusMap = order.orderStatusMap![itemIndex];

                      //     return Row(
                      //       children: [
                      //         Text('Order Status :${orderStatusMap.status}')
                      //       ],
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Pagination Footer - keep as is, always show even when no orders found
        CustomPaginationFooter(
          currentPage: ordersProvider.readyToConfirmPage - 1,
          totalPages: ordersProvider.totalReadyToConfirmPages,
          buttonSize: 30.0,
          pageController: _pageController,
          onFirstPage: () {
            ordersProvider.upDateReadyToConfirmPage(1);
            ordersProvider.fetchOrders(page: 1, limit: 20, isFailed: true);
          },
          onLastPage: () {
            ordersProvider.upDateReadyToConfirmPage(
                ordersProvider.totalReadyToConfirmPages);
            ordersProvider.fetchOrders(
                page: ordersProvider.totalReadyToConfirmPages,
                limit: 20,
                isReadyToConfirm: true);
          },
          onNextPage: () {
            if (ordersProvider.readyToConfirmPage <
                ordersProvider.totalReadyToConfirmPages) {
              ordersProvider.upDateReadyToConfirmPage(
                  ordersProvider.readyToConfirmPage + 1);
              ordersProvider.fetchOrders(
                  page: ordersProvider.readyToConfirmPage,
                  limit: 20,
                  isReadyToConfirm: true);
            }
          },
          onPreviousPage: () {
            if (ordersProvider.readyToConfirmPage > 1) {
              ordersProvider.upDateReadyToConfirmPage(
                  ordersProvider.readyToConfirmPage - 1);
              ordersProvider.fetchOrders(
                  page: ordersProvider.readyToConfirmPage,
                  limit: 20,
                  isReadyToConfirm: true);
            }
          },
          onGoToPage: (page) {
            ordersProvider.upDateReadyToConfirmPage(page + 1);
            ordersProvider.fetchOrders(
                page: page + 1, limit: 20, isReadyToConfirm: true);
          },
          onJumpToPage: () {
            int page = int.tryParse(_pageController.text) ?? 1;
            if (page >= 1 && page <= ordersProvider.totalReadyToConfirmPages) {
              ordersProvider.upDateReadyToConfirmPage(page);
              ordersProvider.fetchOrders(
                  page: page, limit: 20, isReadyToConfirm: true);
            }
          },
        )
      ],
    );
  }
}

// Helper method to build each info row
Widget _buildInfoRow(String label, String? value) {
  return Row(
    children: [
      Text(
        '$label ',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      Flexible(
        child: Text(
          value ?? 'N/A',
          style: const TextStyle(fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}


// void _onSearchChanged() async {
//   String searchTerm = _searchController.text;

//   // Fetch the updated orders based on the active tab
//   List<Order> filteredOrders;
//   if (_tabController.index == 0) {
//     filteredOrders = await _ordersApi.searchReadyToConfirmOrders(searchTerm);
//   } else {
//     filteredOrders = await searchFailedOrders(searchTerm);
//   }

//   // Update the state to rebuild the UI
//   setState(() {
//     _displayedOrders = filteredOrders;
//   });

//   // Optional: Print to verify updates
//   print('Displayed orders: $_displayedOrders');
// }
