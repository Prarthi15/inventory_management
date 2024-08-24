import 'package:flutter/material.dart';
import 'package:inventory_management/Custom-Files/colors.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final bool isSmallScreen;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSmallScreen,
    required int borderRadius,
    required int elevation,
    required Color cardColor,
    required Color shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final double cardHeight = isSmallScreen ? 60.0 : 100.0;
    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryBlue.withOpacity(0.8), AppColors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                      ),
                      child: Text(
                        'Action',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
