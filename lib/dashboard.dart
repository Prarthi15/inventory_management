import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management/combo_page.dart';
import 'package:inventory_management/location_master.dart';
import 'package:inventory_management/manage-inventory.dart';
import 'package:inventory_management/order-page.dart';
import 'package:inventory_management/product_display.dart';
import 'package:inventory_management/products.dart';
import 'package:inventory_management/category_master.dart';
import 'package:inventory_management/dashboard_cards.dart';
import 'Custom-Files/colors.dart';
import 'package:inventory_management/product_manager.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedDrawerItem = 'Dashboard';

  DateTime? lastUpdatedTime;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    lastUpdatedTime = DateTime.now();
  }

  void _refreshData() {
    setState(() {
      lastUpdatedTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 800;

        return Scaffold(
          key: _scaffoldKey,
          drawer: isSmallScreen
              ? SizedBox(
                  width: 220,
                  child: Drawer(
                    child: Container(
                      color: Colors.grey[200],
                      child: _buildDrawerContent(isSmallScreen),
                    ),
                  ),
                )
              : null,
          body: Row(
            children: <Widget>[
              if (!isSmallScreen)
                Container(
                  width: 200,
                  color: AppColors.lightGrey,
                  child: _buildDrawerContent(isSmallScreen),
                ),
              Expanded(
                child: Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          if (isSmallScreen)
                            IconButton(
                              icon:
                                  const Icon(Icons.menu, color: AppColors.grey),
                              onPressed: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
                            ),
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: AppColors.greyBackground,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            icon: const Icon(Icons.notifications,
                                color: AppColors.grey),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: AppColors.grey,
                                child:
                                    Icon(Icons.person, color: AppColors.white),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Prarthi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              const SizedBox(width: 5),
                              IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: _buildMainContent(
                            selectedDrawerItem, isSmallScreen),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerContent(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Katyayani',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Wrap the drawer items in SingleChildScrollView to make them scrollable
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildDrawerItem(
                  icon: Icons.dashboard,
                  text: 'Dashboard',
                  isSelected: selectedDrawerItem == 'Dashboard',
                  onTap: () => _onDrawerItemTapped('Dashboard', isSmallScreen),
                ),
                _buildDrawerItem(
                  icon: Icons.shopping_cart,
                  text: 'Orders',
                  isSelected: selectedDrawerItem == 'Orders',
                  onTap: () => _onDrawerItemTapped('Orders', isSmallScreen),
                ),
                _buildInventorySection(isSmallScreen),
                _buildMasterSection(isSmallScreen),
                _buildDrawerItem(
                  icon: Icons.analytics,
                  text: 'Accounting',
                  isSelected: selectedDrawerItem == 'Accounting',
                  onTap: () => _onDrawerItemTapped('Accounting', isSmallScreen),
                ),
                _buildDrawerItem(
                  icon: Icons.production_quantity_limits,
                  text: 'View Product',
                  isSelected: selectedDrawerItem == 'View Product',
                  onTap: () =>
                      _onDrawerItemTapped('View Product', isSmallScreen),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: [
              _buildDrawerItem(
                icon: Icons.logout,
                text: 'Logout',
                isSelected: selectedDrawerItem == 'Logout',
                onTap: () => _onDrawerItemTapped('Logout', isSmallScreen),
              ),
              _buildDrawerItem(
                icon: Icons.settings,
                text: 'Settings',
                isSelected: selectedDrawerItem == 'Settings',
                onTap: () => _onDrawerItemTapped('Settings', isSmallScreen),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInventorySection(bool isSmallScreen) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20.0),
        title: Text(
          'Inventory',
          style: TextStyle(
            color: selectedDrawerItem == 'Inventory'
                ? AppColors.white
                : AppColors.primaryBlue,
            fontSize: 16,
          ),
        ),
        leading: Icon(
          Icons.inventory,
          color: selectedDrawerItem == 'Inventory'
              ? AppColors.white
              : AppColors.primaryBlue,
          size: 24,
        ),
        backgroundColor: selectedDrawerItem == 'Inventory'
            ? const Color.fromRGBO(6, 90, 216, 0.1)
            : null,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 10.0), // Ensure consistent padding
            child: _buildDrawerItem(
              icon: Icons.production_quantity_limits,
              text: 'Manage Inventory',
              isSelected: selectedDrawerItem == 'Manage Inventory',
              onTap: () =>
                  _onDrawerItemTapped('Manage Inventory', isSmallScreen),
              isIndented: true, // Pass the indentation flag
              iconSize: 20, // Adjust icon size
              fontSize: 14, // Adjust font size
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterSection(bool isSmallScreen) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20.0),
        title: Text(
          'Master',
          style: TextStyle(
            color: selectedDrawerItem == 'Master'
                ? AppColors.white
                : AppColors.primaryBlue,
            fontSize: 16,
          ),
        ),
        leading: Icon(
          Icons.pages,
          color: selectedDrawerItem == 'Master'
              ? AppColors.white
              : AppColors.primaryBlue,
          size: 24,
        ),
        backgroundColor: selectedDrawerItem == 'Master'
            ? const Color.fromRGBO(6, 90, 216, 0.1)
            : null,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: _buildDrawerItem(
              icon: Icons.production_quantity_limits,
              text: 'Product Master',
              isSelected: selectedDrawerItem == 'Product Master',
              onTap: () => _onDrawerItemTapped('Product Master', isSmallScreen),
              isIndented: true,
              iconSize: 20,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: _buildDrawerItem(
              icon: Icons.category,
              text: 'Category Master',
              isSelected: selectedDrawerItem == 'Category Master',
              onTap: () =>
                  _onDrawerItemTapped('Category Master', isSmallScreen),
              isIndented: true,
              iconSize: 20,
              fontSize: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: _buildDrawerItem(
              icon: Icons.list,
              text: 'Combo Master',
              isSelected: selectedDrawerItem == 'Combo Master',
              onTap: () => _onDrawerItemTapped('Combo Master', isSmallScreen),
              isIndented: true,
              iconSize: 20,
              fontSize: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: _buildDrawerItem(
              icon: Icons.warehouse,
              text: 'Location Master',
              isSelected: selectedDrawerItem == 'Location Master',
              onTap: () =>
                  _onDrawerItemTapped('Location Master', isSmallScreen),
              isIndented: true,
              iconSize: 20,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _onDrawerItemTapped(String item, bool isSmallScreen) {
    setState(() {
      selectedDrawerItem = item;
      if (isSmallScreen) {
        Navigator.pop(context);
      }
    });
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    bool isIndented = false,
    double iconSize = 24,
    double fontSize = 16,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: isIndented ? 32.0 : 8.0),
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primaryBlueLight,
                    AppColors.primaryBlue,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(6),
              )
            : null,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          leading: Icon(
            icon,
            color: isSelected ? AppColors.white : AppColors.primaryBlue,
            size: iconSize,
          ),
          title: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.primaryBlue,
              fontSize: fontSize,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildMainContent(String selectedDrawerItem, bool isSmallScreen) {
    switch (selectedDrawerItem) {
      case 'Dashboard':
        return _buildDashboardContent(isSmallScreen);
      case 'Sales Orders':
        return const Center(child: Text("Sales Orders content goes here"));
      case 'Inventory':
        return const Center(child: Text("Inventory content goes here"));
      case 'Products':
        return const Products();
      case 'Manage Inventory':
        return const ManageInventory();
      case 'Orders':
        return const OrdersPage();
      case 'Product Master':
        return const ProductDashboardPage();
      case 'Category Master':
        return CategoryMasterPage();
      case 'Combo Master':
        return const ComboPage();
      case 'Location Master':
        return const LocationMaster();
      case 'Accounting':
        return const Center(child: Text("Accounting content goes here"));
      case 'View Product':
        return const ProductDataDisplay();
      case 'Settings':
        return const Center(child: Text("Settings content goes here"));
      default:
        return const Center(child: Text("Select a menu item"));
    }
  }

  Widget _buildDashboardContent(bool isSmallScreen) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Hello, Prarthi',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue),
          ),
          const SizedBox(height: 10),
          const Text(
            "Here's what's happening with your store today",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.greyText,
            ),
          ),
          const SizedBox(height: 20),
          const DashboardCards(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Last updated: ${lastUpdatedTime != null ? DateFormat('hh:mm a').format(lastUpdatedTime!) : 'N/A'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.greyText,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _refreshData,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 50),
                  backgroundColor: AppColors.primaryBlue,
                ),
                child: const Text(
                  'Refresh',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
