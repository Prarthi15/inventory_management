import 'package:flutter/material.dart';

class DashboardCards extends StatefulWidget {
  const DashboardCards({super.key});

  @override
  _DashboardCardsState createState() => _DashboardCardsState();
}

class _DashboardCardsState extends State<DashboardCards> {
  final PageController _pageController = PageController();
  final int _numberOfPages = 5;

  void _scrollLeft() {
    if (_pageController.page! > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollRight() {
    if (_pageController.page! < _numberOfPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 800;

        // Calculate card widths
        double threeCardWidth = isSmallScreen
            ? constraints.maxWidth * 0.9
            : (constraints.maxWidth - 32) / 3; // Wider for large screens
        double fiveCardWidth = isSmallScreen
            ? constraints.maxWidth * 0.8 / 5
            : (constraints.maxWidth - 32) / 5;
        double cardHeight = isSmallScreen ? 140 : 150;

        return Column(
          children: [
            // Top Three Cards
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: [
                DashboardCard(
                  icon: Icons.analytics,
                  title: 'Total Sales',
                  value: '₹45,000',
                  color: Colors.blueAccent,
                  width: threeCardWidth,
                  height: cardHeight,
                  backgroundColor:
                      Colors.white, // Set background color to white
                ),
                DashboardCard(
                  icon: Icons.shopping_cart,
                  title: 'Orders',
                  value: '120',
                  color: Colors.greenAccent,
                  width: threeCardWidth,
                  height: cardHeight,
                  backgroundColor:
                      Colors.white, // Set background color to white
                ),
                DashboardCard(
                  icon: Icons.account_balance_wallet,
                  title: 'Revenue',
                  value: '₹90,000',
                  color: Colors.deepOrangeAccent,
                  width: threeCardWidth,
                  height: cardHeight,
                  backgroundColor:
                      Colors.white, // Set background color to white
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Bottom Five Cards
            if (isSmallScreen)
              SizedBox(
                height: cardHeight + 50,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_left),
                      onPressed: _scrollLeft,
                    ),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        children: [
                          DashboardCard(
                            icon: Icons.people,
                            title: 'Customers',
                            value: '30',
                            color: Colors.purpleAccent,
                            width: fiveCardWidth,
                            height: cardHeight,
                          ),
                          DashboardCard(
                            icon: Icons.thumb_up,
                            title: 'Likes',
                            value: '1,200',
                            color: Colors.redAccent,
                            width: fiveCardWidth,
                            height: cardHeight,
                          ),
                          DashboardCard(
                            icon: Icons.star,
                            title: 'Reviews',
                            value: '850',
                            color: Colors.amberAccent,
                            width: fiveCardWidth,
                            height: cardHeight,
                          ),
                          DashboardCard(
                            icon: Icons.trending_up,
                            title: 'Growth',
                            value: '25%',
                            color: Colors.tealAccent,
                            width: fiveCardWidth,
                            height: cardHeight,
                          ),
                          DashboardCard(
                            icon: Icons.settings,
                            title: 'Settings',
                            value: '5',
                            color: Colors.grey,
                            width: fiveCardWidth,
                            height: cardHeight,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_right),
                      onPressed: _scrollRight,
                    ),
                  ],
                ),
              )
            else
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.start,
                children: [
                  DashboardCard(
                    icon: Icons.people,
                    title: 'Customers',
                    value: '30',
                    color: Colors.purpleAccent,
                    width: fiveCardWidth,
                    height: cardHeight,
                  ),
                  DashboardCard(
                    icon: Icons.thumb_up,
                    title: 'Likes',
                    value: '1,200',
                    color: Colors.redAccent,
                    width: fiveCardWidth,
                    height: cardHeight,
                  ),
                  DashboardCard(
                    icon: Icons.star,
                    title: 'Reviews',
                    value: '850',
                    color: Colors.amberAccent,
                    width: fiveCardWidth,
                    height: cardHeight,
                  ),
                  DashboardCard(
                    icon: Icons.trending_up,
                    title: 'Growth',
                    value: '25%',
                    color: Colors.tealAccent,
                    width: fiveCardWidth,
                    height: cardHeight,
                  ),
                  DashboardCard(
                    icon: Icons.settings,
                    title: 'Settings',
                    value: '5',
                    color: Colors.grey,
                    width: fiveCardWidth,
                    height: cardHeight,
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final Color backgroundColor; // Add backgroundColor parameter
  final double width;
  final double height;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.width,
    required this.height,
    this.backgroundColor = Colors.white, // Default to white
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor, // Use backgroundColor
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30.0),
          const SizedBox(height: 12.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              color: color.withOpacity(0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.0,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
