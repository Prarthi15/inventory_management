import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inventory_management/create_location_form.dart';
import 'provider/location_provider.dart';
import 'Custom-Files/custom-button.dart';
import 'Custom-Files/colors.dart';
import 'Custom-Files/data_table.dart';
import 'Custom-Files/loading_indicator.dart';

class LocationMaster extends StatefulWidget {
  const LocationMaster({Key? key}) : super(key: key);

  @override
  _LocationMasterState createState() => _LocationMasterState();
}

class _LocationMasterState extends State<LocationMaster> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData(); // Call _refreshData on initial load
    });
  }

  void _refreshData() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.setLoading(true); // Start loading

    try {
      await locationProvider.fetchWarehouses(); // Fetch data
      print("Warehouses fetched successfully."); // Debugging
    } catch (error) {
      // Handle errors during fetch
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to refresh warehouses'),
          backgroundColor: AppColors.cardsred,
        ),
      );
    } finally {
      locationProvider.setLoading(false); // Ensure loading is stopped
    }
  }

  Future<void> _deleteWarehouse(
      BuildContext context, String warehouseId) async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    locationProvider.setLoading(true);
    bool isDeleted =
        await locationProvider.deleteWarehouse(context, warehouseId);

    if (isDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Warehouse deleted successfully'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      _refreshData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete warehouse'),
          backgroundColor: AppColors.cardsred,
        ),
      );
    }
    locationProvider.setLoading(false);
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
          const SizedBox(height: 10),
          locationProvider.isCreatingNewLocation
              ? const NewLocationForm()
              : _buildMainTable(context), // Display the main table or form
        ],
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context, double buttonWidth,
      double buttonHeight, double fontSize) {
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
              Provider.of<LocationProvider>(context, listen: false)
                  .toggleCreatingNewLocation();
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
            onTap: () {
              // Implement bulk locations upload functionality here
            },
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

    // Column names including delete action
    final columnNames = [
      'Warehouse Name',
      'Warehouse Key',
      'Location',
      'Warehouse Pincode',
      'Pincodes',
      'Actions', // New column for delete and update actions
    ];

    // Rows data
    final rowsData = locationProvider.warehouses.map((warehouse) {
      String location;
      if (warehouse['location'] is String) {
        location = warehouse['location'];
      } else if (warehouse['location'] is Map) {
        // Extract from billingAddress
        final billingAddress = warehouse['location']['billingAddress'];
        final country = billingAddress['country'] ?? 'N/A';
        final state = billingAddress['state'] ?? 'N/A';
        final city = billingAddress['city'] ?? 'N/A';
        location = '$city, $state, $country';
      } else {
        location = 'N/A';
      }
      String pincodeList;
      if (warehouse['pincode'] is List) {
        pincodeList = warehouse['pincode'].join(', ');
      } else if (warehouse['pincode'] is String) {
        pincodeList = warehouse['pincode'];
      } else {
        pincodeList = 'N/A';
      }

      return {
        'Warehouse Name': warehouse['name'] ?? 'N/A',
        'Warehouse Key': warehouse['_id'] ?? 'N/A',
        'Location': location,
        'Warehouse Pincode': warehouse['warehousePincode'] ?? 'N/A',
        'Pincodes': pincodeList,
        'Actions': Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.tealcolor),
              onPressed: () {
                print("Update icon is clicked");
                // Implement update functionality here
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.cardsred),
              onPressed: () => _deleteWarehouse(context, warehouse['_id']),
            ),
          ],
        ),
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
                    onChanged: (value) {
                      locationProvider.filterWarehouses(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            locationProvider.isLoading
                ? const Center(
                    child: WarehouseLoadingAnimation(),
                  )
                : CustomDataTable(
                    columnNames: columnNames,
                    rowsData: rowsData,
                  ),
          ],
        ),
      ),
    );
  }
}
