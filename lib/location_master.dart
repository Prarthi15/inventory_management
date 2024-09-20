import 'package:flutter/material.dart';
import 'package:inventory_management/create_location_form.dart';
import 'package:provider/provider.dart';
import 'provider/location_provider.dart';
import 'Custom-Files/custom-button.dart';
import 'Custom-Files/colors.dart';
import 'Custom-Files/data_table.dart';

class LocationMaster extends StatefulWidget {
  const LocationMaster({super.key});

  @override
  _LocationMasterState createState() => _LocationMasterState();
}

class _LocationMasterState extends State<LocationMaster> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationProvider>(context, listen: false).fetchWarehouses();
    });
  }

  void _refreshData() {
    Provider.of<LocationProvider>(context, listen: false).fetchWarehouses();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Fixed sizes for large screens
    const fixedButtonWidth = 160.0;
    const fixedButtonHeight = 30.0;
    const fixedFontSize = 13.0;

    // Responsive sizes for smaller screens
    final buttonWidth =
        screenWidth < 600 ? screenWidth * 0.3 : fixedButtonWidth;
    final buttonHeight = screenWidth < 600 ? 30.0 : fixedButtonHeight;
    final fontSize = screenWidth < 600 ? 12.0 : fixedFontSize;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!locationProvider.isCreatingNewLocation)
            _buildButtonRow(context, buttonWidth, buttonHeight, fontSize),
          const SizedBox(height: 30),
          locationProvider.isCreatingNewLocation
              ? const NewLocationForm()
              : _buildMainTable(context),
        ],
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context, double buttonWidth,
      double buttonHeight, double fontSize) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Container(
      width: double.infinity,
      height: 60,
      color: AppColors.primaryGreen,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            width: buttonWidth,
            height: buttonHeight,
            onTap: () {
              locationProvider.toggleCreatingNewLocation();
            },
            color: AppColors.white,
            textColor: AppColors.primaryGreen,
            fontSize: fontSize,
            text: 'Create New Location',
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 16),
          CustomButton(
            width: buttonWidth,
            height: buttonHeight,
            onTap: () {},
            color: AppColors.white,
            textColor: AppColors.primaryGreen,
            fontSize: fontSize,
            text: 'Bulk Locations Upload',
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 16),
          CustomButton(
            width: buttonWidth * 0.75,
            height: buttonHeight,
            onTap: _refreshData,
            color: AppColors.white,
            textColor: AppColors.primaryGreen,
            fontSize: fontSize,
            text: 'Refresh',
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }

  Widget _buildMainTable(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    //column names
    final columnNames = [
      'Location Name',
      'Location Key',
      'City',
      'State',
      'Country',
      'Zip',
      'Holds Stock',
      'Copy Master from Primary',
    ];

    //rows data
    final rowsData = locationProvider.warehouses.map((warehouse) {
      return {
        'Location Name': warehouse['locationName'] ?? 'N/A',
        'Location Key': warehouse['locationKey'] ?? 'N/A',
        'City': warehouse['city'] ?? 'N/A',
        'State': warehouse['state'] ?? 'N/A',
        'Country': warehouse['country'] ?? 'N/A',
        'Zip': warehouse['zip'] ?? 'N/A',
        'Holds Stock': (warehouse['holdsStock'] ?? false) ? 'Yes' : 'No',
        'Copy Master from Primary':
            (warehouse['copyMasterSkuFromPrimary'] ?? false) ? 'Yes' : 'No',
      };
    }).toList();

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.primaryGreen,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomDataTable(
              columnNames: columnNames,
              rowsData: rowsData,
            ),
          ],
        ),
      ),
    );
  }
}
