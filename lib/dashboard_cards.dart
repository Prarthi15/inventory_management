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

        double threeCardWidth = isSmallScreen
            ? constraints.maxWidth * 0.9
            : (constraints.maxWidth - 32) / 3;
        double fiveCardWidth = isSmallScreen
            ? constraints.maxWidth * 0.8 / 5
            : (constraints.maxWidth - 32) / 5;
        double cardHeight = isSmallScreen ? 140 : 150;

        return Column(
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: [
                DashboardCard(
                  title: "Today's Gross Revenue",
                  value: '₹45,000',
                  subtitle: 'Yesterday: ₹60,000',
                  percentageChange: '-25%',
                  changeColor: Colors.redAccent,
                  chartData: const [1.0, 0.9, 0.8, 0.7],
                  width: threeCardWidth,
                  height: cardHeight,
                ),
                DashboardCard(
                  title: "Today's Orders",
                  value: '120',
                  subtitle: 'Yesterday: 140',
                  percentageChange: '-14%',
                  changeColor: Colors.redAccent,
                  chartData: [1.0, 0.95, 0.85, 0.7],
                  width: threeCardWidth,
                  height: cardHeight,
                ),
                DashboardCard(
                  title: "Today's Return",
                  value: '₹0',
                  subtitle: 'Yesterday: ₹0',
                  percentageChange: '0%',
                  changeColor: Colors.greenAccent,
                  chartData: [1.0, 0.9, 0.85, 0.8],
                  width: threeCardWidth,
                  height: cardHeight,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
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
                            title: 'Total Sub-Orders',
                            value: '30',
                            subtitle: 'Yesterday: 35',
                            percentageChange: '-14%',
                            changeColor: Colors.redAccent,
                            chartData: const [1.0, 0.8, 0.7, 0.5],
                            width: fiveCardWidth,
                            height: cardHeight,
                          ),
                          DashboardCard(
                            title: 'Distinct SKU Sold',
                            value: '1,200',
                            subtitle: 'Yesterday: 1,500',
                            percentageChange: '-20%',
                            changeColor: Colors.redAccent,
                            chartData: [1.0, 0.85, 0.75, 0.6],
                            width: fiveCardWidth,
                            height: cardHeight,
                          ),
                          DashboardCard(
                            title: 'Pending Orders',
                            value: '850',
                            subtitle: 'Yesterday: 950',
                            percentageChange: 'NA',
                            changeColor: Colors.grey,
                            chartData: [1.0, 0.92, 0.85, 0.7],
                            width: fiveCardWidth,
                            height: cardHeight,
                          ),
                          DashboardCard(
                            title: 'Hold Orders',
                            value: '25%',
                            subtitle: 'Yesterday: 30%',
                            percentageChange: '-16%',
                            changeColor: Colors.redAccent,
                            chartData: [1.0, 0.95, 0.85, 0.7],
                            width: fiveCardWidth,
                            height: cardHeight,
                          ),
                          DashboardCard(
                            title: 'Avg. Order Value',
                            value: '5',
                            subtitle: 'Yesterday: 5',
                            percentageChange: '0%',
                            changeColor: Colors.grey,
                            chartData: [1.0, 1.0, 1.0, 1.0],
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
                    title: 'Customers',
                    value: '30',
                    subtitle: 'Yesterday: 35',
                    percentageChange: '-14%',
                    changeColor: Colors.redAccent,
                    chartData: [1.0, 0.8, 0.7, 0.5],
                    width: fiveCardWidth,
                    height: cardHeight,
                  ),
                  DashboardCard(
                    title: 'Likes',
                    value: '1,200',
                    subtitle: 'Yesterday: 1,500',
                    percentageChange: '-20%',
                    changeColor: Colors.redAccent,
                    chartData: [1.0, 0.85, 0.75, 0.6],
                    width: fiveCardWidth,
                    height: cardHeight,
                  ),
                  DashboardCard(
                    title: 'Reviews',
                    value: '850',
                    subtitle: 'Yesterday: 950',
                    percentageChange: '-11%',
                    changeColor: Colors.redAccent,
                    chartData: [1.0, 0.92, 0.85, 0.7],
                    width: fiveCardWidth,
                    height: cardHeight,
                  ),
                  DashboardCard(
                    title: 'Growth',
                    value: '25%',
                    subtitle: 'Yesterday: 30%',
                    percentageChange: '-16%',
                    changeColor: Colors.redAccent,
                    chartData: [1.0, 0.95, 0.85, 0.7],
                    width: fiveCardWidth,
                    height: cardHeight,
                  ),
                  DashboardCard(
                    title: 'Settings',
                    value: '5',
                    subtitle: 'Yesterday: 5',
                    percentageChange: '0%',
                    changeColor: Colors.grey,
                    chartData: [1.0, 1.0, 1.0, 1.0],
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
  final String title;
  final String value;
  final String subtitle;
  final String percentageChange;
  final Color changeColor;
  final List<double> chartData;
  final double width;
  final double height;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.percentageChange,
    required this.changeColor,
    required this.chartData,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(6, 90, 216, 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                percentageChange,
                style: TextStyle(
                  fontSize: 12,
                  color: changeColor,
                ),
              ),
            ],
          ),
          // Optionally, you can add a graph or a progress bar here using chartData.
        ],
      ),
    );
  }
}
