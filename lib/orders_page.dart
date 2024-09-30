import 'package:flutter/material.dart';
import 'package:inventory_management/provider/orders_provider.dart';

class OrdersNewPage extends StatefulWidget {
  const OrdersNewPage({super.key});

  @override
  State<OrdersNewPage> createState() => _OrdersNewPageState();
}

class _OrdersNewPageState extends State<OrdersNewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final ordersProvider = OrdersProvider();

  // // For managing the state of the checkboxes
  // bool selectAll = false;
  // List<bool> selectedOrders =
  //     List.generate(5, (index) => false); // Assuming 5 orders for demonstration

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 2 tabs
  }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  // void toggleSelectAll(bool? value) {
  //   setState(() {
  //     selectAll = value ?? false;
  //     for (int i = 0; i < selectedOrders.length; i++) {
  //       selectedOrders[i] = selectAll; // Set all to the same value
  //     }
  //   });
  // }

  // void toggleOrderSelection(int index, bool value) {
  //   setState(() {
  //     selectedOrders[index] = value; // Update individual order selection
  //     selectAll = selectedOrders
  //         .every((selected) => selected); // Check if all are selected
  //   });
  // }

  // // Function to format date manually
  // String formatDate(DateTime date) {
  //   String year = date.year.toString();
  //   String month = date.month.toString().padLeft(2, '0');
  //   String day = date.day.toString().padLeft(2, '0');

  //   return '$year-$month-$day'; // Format: YYYY-MM-DD
  // }

  @override
  Widget build(BuildContext context) {
    DateTime hardcodedDate = DateTime(2024, 9, 25);

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Column(
            children: [
              // A row with Filter, Sort by dropdown, and Search bar
              Container(
                color: Colors.blue,
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
                      child: const TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
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
                indicatorColor: Colors.blue,
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
          buildOrdersList(hardcodedDate, false),
          // Content for "Failed Orders"
          buildOrdersList(hardcodedDate, true),
        ],
      ),
    );
  }
}

Widget buildOrdersList(DateTime hardcodedDate, bool showConfirmedButton) {
  final ordersProvider = OrdersProvider();
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
            const SizedBox(
              width: 50,
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Implement "Print Picklist" functionality here
              },
              icon: const Icon(Icons.print, color: Colors.white),
              label: const Text('Print Picklist',
                  style: TextStyle(color: Colors.white)), // Button text
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Implement "Print Picklist" functionality here
              },
              icon: const Icon(Icons.print, color: Colors.white), // Print icon
              label: const Text('Print Pickingslip',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
            const Spacer(),
            if (showConfirmedButton) ...[
              ElevatedButton(
                onPressed: () {
                  // Implement "Print Picklist" functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
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
                  onChanged: ordersProvider.toggleSelectAll,
                ),
                const Text('Select All'),
              ],
            ),
            const Row(
              children: [
                Text(
                  'Order ID: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('order id 1'),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Date:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                Text(ordersProvider.formatDate(hardcodedDate)),
              ],
            ),
            const Row(
              children: [
                Text(
                  'Total Amount: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('\$1200'),
              ],
            ),
          ],
        ),
      ),

      Expanded(
        child: ListView.builder(
          itemCount: ordersProvider.selectedOrders.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Checkbox(
                      value: ordersProvider.selectedOrders[index],
                      onChanged: (value) => ordersProvider.toggleOrderSelection(
                          index, value ?? false),
                    ),
                    Container(
                      width: 270,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Replace with actual image URL or Asset
                          // Image.network('https://via.placeholder.com/50',
                          //     height: 50, width: 50),

                          Icon(
                            Icons.image,
                            size: 200,
                            color: Colors.blueGrey,
                          ),
                          Text(
                            'Nemotude Plus (Bio Pesticides verticillium chalamydosporium 1% WP)',
                            softWrap: true,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          children: [
                            Text(
                              'SKU: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('123456'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Text(
                              'Quality: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(''),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Text(
                              'Brand: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('BrandName'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text(
                              'Order Item ID: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('item${index + 1}'),
                          ],
                        ),
                      ],
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              'Total MRP: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('\$1500'),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Selling Price: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('\$1200'),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Payment Mode: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Credit Card'),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Shipping Method: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(''),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Shipping Mode: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(''),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Payment Status: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(''),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Order Date: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(ordersProvider.formatDate(hardcodedDate)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text(
                              'Import Date: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(ordersProvider.formatDate(hardcodedDate)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Text(
                              'TAT: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(''),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text(
                              'QC Confirmation Date: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(ordersProvider.formatDate(hardcodedDate)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Text(
                              'Inventory Assigned: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Yes'),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
