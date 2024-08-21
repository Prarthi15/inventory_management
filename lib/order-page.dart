import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:inventory_management/Custom-Files/custom-dropdown.dart';
import 'package:inventory_management/Custom-Files/custom-textfield.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Ready To Confirm'),
            Tab(text: 'Failed Orders'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReadyToConfirmTab(),
          const Center(child: Text("Failed Orders")),
        ],
      ),
    );
  }

  Widget _buildReadyToConfirmTab() {
    return SingleChildScrollView(
      scrollDirection:Axis.vertical,
      child: Row(
        children: [
          Container(
            width: 250,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                CustomTextField(
                  controller: TextEditingController(),
                  label: 'Search',
                  icon: Icons.search,
                ),
      
                const SizedBox(height: 16),
      
                // Total Orders and Upcoming Orders
                Row(
                  children: [
                    const Text('Total Orders', style: TextStyle(fontSize: 16)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      color: AppColors.cardsgreen,
                      child: const Text('4448', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
      
                const SizedBox(height: 8),
      
                Row(
                  children: [
                   const SizedBox(
                      width:130,
                      height:32,
                      child:  CustomDropdown(fontSize:12.5,)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      color: Colors.amber.shade300,
                      child: const Text('2', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
      
                const SizedBox(height: 16),
      
                Divider(
                  height: 1,
                  color: AppColors.black.withOpacity(0.5),
                ),
      
                const SizedBox(height: 16),
      
                // Sort by dropdown
                Container(
                  height: 30,
                  width: double.infinity,
                  color: AppColors.black.withOpacity(0.2),
                  alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Sort By:'),
                  ),
                ),
      
                const SizedBox(height: 8),
      
               const Row(
                  children:  [
                    SizedBox(
                      height: 34,
                      width: 160,
                      child: CustomDropdown(fontSize: 12.5),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_upward, size: 18),
                    Icon(Icons.arrow_downward, size: 18),
                  ],
                ),
      
                const SizedBox(height: 16),
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Filters", style: TextStyle(fontWeight: FontWeight.bold)),
                    InkWell(
                      child: const Text('Clear', style: TextStyle(color: Colors.blue)),
                      onTap: () {},
                    ),
                  ],
                ),
      
                const SizedBox(height: 8),
      
                // Order Date Filter
                Container(
                  height: 30,
                  width: double.infinity,
                  color: AppColors.black.withOpacity(0.2),
                  alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Order Date'),
                  ),
                ),
      
                const SizedBox(height: 8),
      
                const SizedBox(
                  height: 34,
                  width: 160,
                  child: CustomDropdown(fontSize: 12.5),
                ),
      
                const SizedBox(height: 16),
      
                // Marketplace Filter
                Container(
                  height: 30,
                  width: double.infinity,
                  color: AppColors.black.withOpacity(0.2),
                  alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Market Place'),
                  ),
                ),
      
                const SizedBox(height: 8),
      
               const SizedBox(
                  height:120,
                  width:250,
                  child:  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Katyayani'),
                        Text('Shopify'),
                        Text('Woocommerce'),
                        Text('Shopify2'),
                        Text('Offline'),
                        Text('Katyayani'),
                        Text('Shopify'),
                        Text('Woocommerce'),
                        Text('Shopify2'),
                        Text('Offline'),
                        Text('Katyayani'),
                        Text('Shopify'),
                        Text('Woocommerce'),
                        Text('Shopify2'),
                        Text('Offline'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height:50,)
              ],
            ),
          ),
          
          // Expanded(flex: 7, child: Container()), // Placeholder for the right-side content
        ],
      ),
    );
  }
}
