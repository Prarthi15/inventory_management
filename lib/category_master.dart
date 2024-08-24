import 'package:flutter/material.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'Custom-Files/categoryCard.dart';

class CategoryMasterPage extends StatelessWidget {
  final List<String> categories = [
    'NPK Fertilizer',
    'Hydroponic Nutrients',
    'Chemical Product',
    'Organic Pest Control',
    'Lure & Traps',
    'Other Fungicides',
    'Other',
    'Bio Fertilizer',
    'Weedicides and Herbicides',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          final crossAxisCount = isSmallScreen ? 1 : 2;

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text("Create Category"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tealcolor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: AppColors.shadowblack,
                  ),
                ),
                const SizedBox(height: 24.0),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: isSmallScreen ? 4 : 3,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        category: categories[index],
                        isSmallScreen: isSmallScreen,
                        cardColor: AppColors.white,
                        shadowColor: AppColors.shadowblack1,
                        elevation: 3,
                        borderRadius: 12,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
