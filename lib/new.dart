import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedDrawerItem = 'Dashboard';
  DateTime? lastUpdatedTime;

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
    return Scaffold(
      body: Row(
        children: <Widget>[
          Container(
            width: 200,
            color: const Color.fromRGBO(
                240, 240, 240, 1), // Light gray for drawer background
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Katyayani',
                    style: TextStyle(
                      fontSize: 24,
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
                  onTap: () =>
                      setState(() => selectedDrawerItem = 'Sales Orders'),
                ),
                _buildDrawerItem(
                  icon: Icons.business,
                  text: 'B2B eCommerce',
                  isSelected: selectedDrawerItem == 'B2B eCommerce',
                  onTap: () =>
                      setState(() => selectedDrawerItem = 'B2B eCommerce'),
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
                  onTap: () =>
                      setState(() => selectedDrawerItem = 'Browse Apps'),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: _buildDrawerItem(
                    icon: Icons.settings,
                    text: 'Settings',
                    isSelected: selectedDrawerItem == 'Settings',
                    onTap: () =>
                        setState(() => selectedDrawerItem = 'Settings'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: _buildMainContent(selectedDrawerItem),
            ),
          ),
        ],
      ),
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

  Widget _buildMainContent(String selectedDrawerItem) {
    switch (selectedDrawerItem) {
      case 'Dashboard':
        return _buildDashboardContent();
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

  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(238, 238, 238, 1),
                ),
              ),
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.grey),
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
        const Text(
          'Hello, Prarthi',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(6, 90, 216, 1),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "Here's what's happening with your store today",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),
        // Row for the first set of dashboard cards
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: _buildDashboardCardWithLastUpdated(
                title: "Today's Gross Revenue",
                value: "₹48,768",
                percentage: "92%",
                color: Colors.red,
                subText: "Yesterday: ₹621,313.12",
                icon: Icons.arrow_downward,
                alignContent: false,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: _buildDashboardCardWithLastUpdated(
                title: "Today's Orders",
                value: "34",
                percentage: "87%",
                color: Colors.red,
                subText: "Yesterday: 256",
                icon: Icons.arrow_downward,
                alignContent: false,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: _buildDashboardCardWithLastUpdated(
                title: "Today's Return",
                value: "₹0",
                percentage: "0%",
                color: Colors.green,
                subText: "Yesterday: ₹0",
                icon: Icons.arrow_upward,
                alignContent: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Row for the second set of dashboard cards
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: _buildDashboardCardWithLastUpdated(
                title: "Total Sub-Orders",
                value: "45",
                percentage: "87%",
                color: Colors.red,
                subText: "Yesterday: 354",
                icon: Icons.arrow_downward,
                alignContent: true,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: _buildDashboardCardWithLastUpdated(
                title: "Distinct SKU Sold",
                value: "37",
                percentage: "78%",
                color: Colors.red,
                subText: "Yesterday: 171",
                icon: Icons.arrow_downward,
                alignContent: true,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: _buildDashboardCardWithLastUpdated(
                title: "Pending Orders",
                value: "2",
                percentage: "NA",
                color: Colors.grey,
                subText: "Yesterday: 171",
                icon: Icons.not_interested,
                alignContent: true,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: _buildDashboardCardWithLastUpdated(
                title: "Hold Orders",
                value: "0",
                percentage: "NA",
                color: Colors.grey,
                subText: "Yesterday: 0",
                icon: Icons.not_interested,
                alignContent: true,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: _buildDashboardCardWithLastUpdated(
                title: "Avg. Order Value",
                value: "₹1,453",
                percentage: "40%",
                color: Colors.red,
                subText: "Yesterday: ₹2,431",
                icon: Icons.arrow_downward,
                alignContent: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDashboardCardWithLastUpdated({
    required String title,
    required String value,
    required String percentage,
    required Color color,
    required String subText,
    required IconData icon,
    required bool alignContent, // New parameter to control content alignment
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        // Last updated section for each card
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0), // Reduced space
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Last Updated: ${_formatTime(DateTime.now())}', // Display time only
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh,
                    size: 16, color: Colors.grey), // Reduced icon size
                onPressed: _refreshData,
              ),
            ],
          ),
        ),
        // Dashboard card container
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12), // Decreased padding
          child: Center(
            // Center content if alignContent is true
            child: Column(
              crossAxisAlignment: alignContent
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: alignContent
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 19, // Decreased font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24, // Decreased font size
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(6, 90, 216, 1),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: alignContent
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Icon(
                      icon,
                      color: color,
                      size: 14, // Reduced icon size
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      percentage,
                      style: TextStyle(
                        fontSize: 14, // Decreased font size
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      subText,
                      style: const TextStyle(
                        fontSize: 12, // Decreased font size
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12; // Convert 24-hour time to 12-hour format
    final formattedHour =
        hour == 0 ? 12 : hour; // Handle the case for midnight (00:00)
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM'; // Determine AM or PM

    return '$formattedHour:$minute $period';
  }
}
