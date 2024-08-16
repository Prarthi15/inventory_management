import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management/manage-inventory.dart';
import 'package:inventory_management/products.dart';
import 'package:inventory_management/dashboard_cards.dart';
import 'Custom-Files/colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedDrawerItem = 'Products';
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
                      const SizedBox(
                        height: 20,
                      ),
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
                              selectedDrawerItem, isSmallScreen)),
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
        const SizedBox(
          height: 20,
        ),
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
        _buildDrawerItem(
          icon: Icons.analytics,
          text: 'Accounting',
          isSelected: selectedDrawerItem == 'Accounting',
          onTap: () => _onDrawerItemTapped('Accounting', isSmallScreen),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: [
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
        dividerColor: Colors.transparent, // Remove divider color
        splashColor: Colors.transparent, // Remove splash color
        highlightColor: Colors.transparent, // Remove highlight color
      ),
      child: ExpansionTile(
        tilePadding:
            EdgeInsets.symmetric(horizontal: 20.0), // Consistent padding
        title: Text(
          'Inventory',
          style: TextStyle(
            color: selectedDrawerItem == 'Inventory'
                ? AppColors.white
                : AppColors.primaryBlue,
            fontSize: 16, // Ensure font size consistency
          ),
        ),
        leading: Icon(
          Icons.inventory,
          color: selectedDrawerItem == 'Inventory'
              ? AppColors.white
              : AppColors.primaryBlue,
          size: 24, // Ensure icon size consistency
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
              text: 'Products',
              isSelected: selectedDrawerItem == 'Products',
              onTap: () => _onDrawerItemTapped('Products', isSmallScreen),
              isIndented: true, // Pass the indentation flag
              iconSize: 20, // Adjust icon size
              fontSize: 14, // Adjust font size
            ),
          ),
         const  SizedBox(height:4,),
           Padding(
            padding:
                const EdgeInsets.only(left: 10.0), // Ensure consistent padding
            child: _buildDrawerItem(
              icon: Icons.production_quantity_limits,
              text: 'Manage Inventory',
              isSelected: selectedDrawerItem == 'Manage Inventory',
              onTap: () => _onDrawerItemTapped('Manage Inventory', isSmallScreen),
              isIndented: true, // Pass the indentation flag
              iconSize: 20, // Adjust icon size
              fontSize: 14, // Adjust font size
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
        Navigator.pop(context); // Close the drawer on small screens
      }
    });
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    bool isIndented = false,
    double iconSize = 24, // Optional parameter for icon size
    double fontSize = 16, // Optional parameter for font size
  }) {
    return Padding(
      padding: EdgeInsets.only(
          left: isIndented ? 32.0 : 8.0), // Add left padding if indented
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
            size: iconSize, // Adjust icon size
          ),
          title: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.primaryBlue,
              fontSize: fontSize, // Adjust font size
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
      case 'Accounting':
        return const Center(child: Text("Accounting content goes here"));

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
