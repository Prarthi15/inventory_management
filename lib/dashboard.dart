import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ensure this import is present

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
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
                  width: 220, // Adjust this width to make the drawer narrower
                  child: Drawer(
                    child: Container(
                      color:
                          Colors.grey[200], // Grey background for small screens
                      child: _buildDrawerContent(),
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
                  child: _buildDrawerContent(),
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

  Widget _buildDrawerContent() {
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
          onTap: () => setState(() => selectedDrawerItem = 'Dashboard'),
        ),
        _buildDrawerItem(
          icon: Icons.inventory,
          text: 'Inventory',
          isSelected: selectedDrawerItem == 'Inventory',
          onTap: () => setState(() => selectedDrawerItem = 'Inventory'),
        ),
        _buildDrawerItem(
          icon: Icons.analytics,
          text: 'Analytics',
          isSelected: selectedDrawerItem == 'Analytics',
          onTap: () => setState(() => selectedDrawerItem = 'Analytics'),
        ),
        _buildDrawerItem(
          icon: Icons.shopping_cart,
          text: 'Sales Orders',
          isSelected: selectedDrawerItem == 'Sales Orders',
          onTap: () => setState(() => selectedDrawerItem = 'Sales Orders'),
        ),
        _buildDrawerItem(
          icon: Icons.business,
          text: 'B2B eCommerce',
          isSelected: selectedDrawerItem == 'B2B eCommerce',
          onTap: () => setState(() => selectedDrawerItem = 'B2B eCommerce'),
        ),
        _buildDrawerItem(
          icon: Icons.production_quantity_limits,
          text: 'Products',
          isSelected: selectedDrawerItem == 'Products',
          onTap: () => setState(() => selectedDrawerItem = 'Products'),
        ),
        _buildDrawerItem(
          icon: Icons.people,
          text: 'Customers',
          isSelected: selectedDrawerItem == 'Customers',
          onTap: () => setState(() => selectedDrawerItem = 'Customers'),
        ),
        _buildDrawerItem(
          icon: Icons.apps,
          text: 'Browse Apps',
          isSelected: selectedDrawerItem == 'Browse Apps',
          onTap: () => setState(() => selectedDrawerItem = 'Browse Apps'),
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
                onTap: () => setState(() => selectedDrawerItem = 'Settings'),
              ),
            ],
          ),
        ),
      ],
    );
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
      case 'Inventory':
        return const Center(child: Text("Inventory content goes here"));
      case 'Analytics':
        return const Center(child: Text("Analytics content goes here"));
      case 'Sales Orders':
        return const Center(child: Text("Sales Orders content goes here"));
      case 'B2B eCommerce':
        return const Center(child: Text("B2B eCommerce content goes here"));
      case 'Products':
        return const Center(child: Text("Products content goes here"));
      case 'Customers':
        return const Center(child: Text("Customers content goes here"));
      case 'Browse Apps':
        return const Center(child: Text("Browse Apps content goes here"));
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
                minimumSize: const Size(40, 40), // Adjusted width
                backgroundColor: const Color.fromRGBO(6, 90, 216, 1),
              ),
              child: const Text(
                'Refresh Data',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DashboardCards extends StatelessWidget {
  const DashboardCards({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: DashboardCard(label: 'Sales', value: '\$4000')),
            SizedBox(width: 10),
            Expanded(
                child: DashboardCard(label: 'Orders', value: '200 Orders')),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(child: DashboardCard(label: 'Visitors', value: '3000')),
            SizedBox(width: 10),
            Expanded(child: DashboardCard(label: 'Customers', value: '1500')),
          ],
        ),
      ],
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String label;
  final String value;

  const DashboardCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(135, 135, 135, 1),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(6, 90, 216, 1),
            ),
          ),
        ],
      ),
    );
  }
}
