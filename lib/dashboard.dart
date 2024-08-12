import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management/products.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
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
                  width: 220, // Adjust this width to make the drawer narrower
                  child: Drawer(
                    child: Container(
                      color:
                          Colors.grey[200], // Grey background for small screens
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
                  color: const Color.fromRGBO(240, 240, 240, 1),
                  child: _buildDrawerContent(isSmallScreen),
                ),
              Expanded(
                child: Container(
                  color: Colors.white,
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
                              icon: const Icon(Icons.menu, color: Colors.grey),
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
                                fillColor: Color.fromRGBO(238, 238, 238, 1),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            icon: const Icon(Icons.notifications,
                                color: Colors.grey),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Prarthi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(6, 90, 216, 1),
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
              color: Color.fromRGBO(6, 90, 216, 1),
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
        _buildDrawerItem(
          icon: Icons.inventory,
          text: 'Inventory',
          isSelected: selectedDrawerItem == 'Inventory',
          onTap: () => _onDrawerItemTapped('Inventory', isSmallScreen),
        ),
        _buildDrawerItem(
          icon: Icons.production_quantity_limits,
          text: 'Products',
          isSelected: selectedDrawerItem == 'Products',
          onTap: () => _onDrawerItemTapped('Products', isSmallScreen),
        ),
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(6, 90, 216, 0.7),
                    Color.fromRGBO(6, 90, 216, 1)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(6),
              )
            : null,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          leading: Icon(icon,
              color: isSelected
                  ? Colors.white
                  : const Color.fromRGBO(6, 90, 216, 1)),
          title: Text(
            text,
            style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : const Color.fromRGBO(6, 90, 216, 1)),
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
      case 'Accounting':
        return const Center(child: Text("Accounting content goes here"));

      case 'Settings':
        return const Center(child: Text("Settings content goes here"));
      default:
        return const Center(child: Text("Select a menu item"));
    }
  }

  Widget _buildDashboardContent(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Hello, Prarthi',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(6, 90, 216, 1)),
        ),
        const SizedBox(height: 10),
        const Text(
          "Here's what's happening with your store today",
          style: TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(135, 135, 135, 1),
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
                color: Color.fromRGBO(135, 135, 135, 1),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _refreshData,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(40, 40),
                backgroundColor: const Color.fromRGBO(6, 90, 216, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text(
                'Refresh',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DashboardCards extends StatelessWidget {
  const DashboardCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        DashboardCard(
          color: Colors.red,
          icon: Icons.shopping_cart,
          title: 'Orders',
          value: '20',
        ),
        DashboardCard(
          color: Colors.blue,
          icon: Icons.attach_money,
          title: 'Revenue',
          value: '\$2000',
        ),
        DashboardCard(
          color: Colors.green,
          icon: Icons.inventory,
          title: 'Inventory',
          value: '50',
        ),
      ],
    );
  }
}

class DashboardCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;

  const DashboardCard({
    Key? key,
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
