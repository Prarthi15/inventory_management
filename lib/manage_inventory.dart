// //
// //
import 'dart:convert'; // For JSON encoding/decoding
import 'package:flutter/material.dart';
import 'package:inventory_management/provider/combo_provider.dart';
import 'package:inventory_management/provider/inventory_provider.dart';
import 'package:provider/provider.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart'; // Import dropdown_search package
import 'Api/inventory_api.dart';
import 'Custom-Files/custom_pagination.dart';
import 'Custom-Files/data_table.dart';
import 'Custom-Files/loading_indicator.dart';
import 'model/combo_model.dart';

class ManageInventoryPage extends StatefulWidget {
  const ManageInventoryPage({super.key});

  @override
  _ManageInventoryPageState createState() => _ManageInventoryPageState();
}

class _ManageInventoryPageState extends State<ManageInventoryPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _pageController = TextEditingController();
  String? selectedProductId;
  String? selectedProductName;
  List<Map<String, dynamic>> subInventories =
  []; // List of SubInventory entries
  List<DropdownMenuItem<String>> dropdownItemsForWarehouses = [];
  bool _loading = true;

  // Fetch and set product dropdown values for searching
  void getDropValueForProduct() async {
    await Provider.of<ComboProvider>(context, listen: false).fetchProducts();
    //await Provider.of<ComboProvider>(context, listen: false).searchProductsByName(query);
    setState(() {});
  }

  // Fetch and set warehouse dropdown values
  void getDropValueForWarehouse() async {
    await Provider.of<ComboProvider>(context, listen: false).fetchWarehouses();
    List<DropdownMenuItem<String>> newItems = [];
    ComboProvider comboProvider =
    Provider.of<ComboProvider>(context, listen: false);

    for (var warehouse in comboProvider.warehouses) {
      newItems.add(DropdownMenuItem<String>(
        value: warehouse['_id'],
        child: Text(warehouse['name'] ?? 'Unknown'),
      ));
    }

    setState(() {
      dropdownItemsForWarehouses = newItems;
      subInventories.add({'warehouseId': null, 'quantity': null});
    });
  }

  // Add SubInventory entry
  void addSubInventory() {
    setState(() {
      subInventories.add({'warehouseId': null, 'quantity': null});
    });
  }

  // Remove SubInventory entry
  void removeSubInventory(int index) {
    setState(() {
      subInventories.removeAt(index);
    });
  }
  void cancelForm() {
    final comboProvider = Provider.of<ComboProvider>(context, listen: false);
    comboProvider.toggleFormVisibility(); // Hide the form
  }

  Future<void> saveInventoryToApi(BuildContext context) async {
    if (selectedProductId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select a product"),
      ));
      return;
    }

    final Map<String, dynamic> requestData = {
      "product_id": selectedProductId,
      "subInventory": subInventories.map((subInventory) {
        return {
          "warehouseId": subInventory['warehouseId'],
          "quantity": subInventory['quantity'],
        };
      }).toList(),
    };

    print("Data to send: $requestData");

    try {
      final token = await getToken();
      final response = await http.post(
        Uri.parse(
            'https://inventory-management-backend-s37u.onrender.com/inventory'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Inventory created successfully!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Inventory created successfully!")),
          );
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text("Failed to create inventory: ${responseData['message'] ?? 'Unknown error'}"),
          // ));
        }
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("Failed to save inventory: ${response.body}"),
        // ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving inventory: $e")),
      );
    }
  }

  void _goToPage(int page) {
    final provider = Provider.of<InventoryProvider>(context, listen: false);
    provider.goToPage(page);
  }

  void _jumpToPage() {
    final provider = Provider.of<InventoryProvider>(context, listen: false);
    int page = int.tryParse(_pageController.text) ?? 0;
    if (page > 0 && page <= provider.totalPages) {
      _goToPage(page - 1);
    }
  }

  // Initialize data
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<ComboProvider>(context, listen: false).fetchAllProducts();
      Provider.of<InventoryProvider>(context, listen: false).fetchInventory();
      Provider.of<ComboProvider>(context, listen: false).fetchProducts();
      getDropValueForProduct();
      // Fetch product dropdown values
      getDropValueForWarehouse(); // Fetch warehouse dropdown values
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InventoryProvider>(context);
    final comboProvider = Provider.of<ComboProvider>(context);
    List<String> columnNames = [
      'COMPANY NAME',
      'CATEGORY',
      'IMAGE',
      'BRAND',
      'SKU',
      'PRODUCT NAME',
      'MRP',
      'BOXSIZE',
      'QUANTITY',
      'ACTIONS',
      'FLIPKART',
      'SNAPDEAL',
      'AMAZON.IN',
    ];

    final paginatedData = provider.getPaginatedData();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar and scrolling buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                        Icons.arrow_left, color: AppColors.primaryGreen),
                    onPressed: () {
                      _scrollController.animateTo(
                        _scrollController.position.pixels - 200,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                                color: AppColors.primaryGreen),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          suffixIcon: IconButton(
                            icon: const Icon(
                                Icons.search, color: AppColors.primaryGreen),
                            onPressed: () {
                              print('Search: ${_searchController.text}');
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                        Icons.arrow_right, color: AppColors.primaryGreen),
                    onPressed: () {
                      _scrollController.animateTo(
                        _scrollController.position.pixels + 200,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      comboProvider.toggleFormVisibility();
                    },
                    child: const Text('Create Inventory'),
                  ),
                ],
              ),
              if (comboProvider.isFormVisible) ...[
                const SizedBox(height: 16),
                const Text("Manage Inventory", style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
          
                // Product Searchable Dropdown
                const Text("Product", style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                DropdownSearch<String>(
                  items: comboProvider.products.map((product) =>
                  product.displayName ?? 'Unknown').toList(),
                  onChanged: (String? newValue) {
                    final selectedProduct = comboProvider.products.firstWhere((
                        product) => product.displayName == newValue);
                    setState(() {
                      selectedProductId = selectedProduct.id;
                      selectedProductName = selectedProduct.displayName;
                    });
                  },
                  selectedItem: selectedProductName,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: 'Search and Select Product',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  popupProps: const PopupProps.dialog(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        labelText: 'Search Product',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
          
                const SizedBox(height: 16),
          
                // SubInventory List
                ...List.generate(subInventories.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SubInventory ${index + 1}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 16),
          
                          // Warehouse Dropdown
                          DropdownButtonFormField<String>(
                            hint: const Text('Select Warehouse'),
                            isExpanded: true,
                            value: subInventories[index]['warehouseId'],
                            items: dropdownItemsForWarehouses,
                            onChanged: (String? newValue) {
                              setState(() {
                                subInventories[index]['warehouseId'] = newValue;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Warehouse',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
          
                          // Quantity Input
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Quantity',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                subInventories[index]['quantity'] =
                                    int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                removeSubInventory(index);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: const Text("Remove",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: addSubInventory,
                  icon: const Icon(Icons.add),
                  label: const Text("Add SubInventory"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Save button
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedProductId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Please select a product"),
                          ));
                        } else {
                          await saveInventoryToApi(context);
                        }
                      },
                      child: const Text('Save Inventory'),
                    ),
                    const SizedBox(width: 16),
          
                    // Cancel button
                    ElevatedButton(
                      onPressed: cancelForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
          
              const SizedBox(height: 30),
          
              // Table and pagination
              if (!comboProvider.isFormVisible) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: InventoryDataTable(
                    columnNames: columnNames,
                    rowsData: paginatedData,
                    scrollController: _scrollController,
                  ),
                ),
                const SizedBox(height: 20),
                CustomPaginationFooter(
                  currentPage: provider.currentPage,
                  totalPages: provider.totalPages,
                  buttonSize: MediaQuery.of(context).size.width > 600 ? 32 : 24,
                  pageController: _pageController,
                  onFirstPage: () => _goToPage(0),
                  onLastPage: () => _goToPage(provider.totalPages - 1),
                  onNextPage: () {
                    if (provider.currentPage < provider.totalPages - 1) {
                      _goToPage(provider.currentPage + 1);
                    }
                  },
                  onPreviousPage: () {
                    if (provider.currentPage > 0) {
                      _goToPage(provider.currentPage - 1);
                    }
                  },
                  onGoToPage: _goToPage,
                  onJumpToPage: _jumpToPage,
                ),
          
              ],
          
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:inventory_management/Custom-Files/loading_indicator.dart';
// import 'package:provider/provider.dart';
// import 'package:inventory_management/Custom-Files/colors.dart';
// import 'package:inventory_management/Custom-Files/data_table.dart';
// import 'package:inventory_management/provider/inventory_provider.dart';
// import 'package:inventory_management/Custom-Files/custom_pagination.dart';
//
// class ManageInventoryPage extends StatefulWidget {
//   const ManageInventoryPage({super.key});
//
//   @override
//   _ManageInventoryPageState createState() => _ManageInventoryPageState();
// }
//
// class _ManageInventoryPageState extends State<ManageInventoryPage> {
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _searchController = TextEditingController();
//   final TextEditingController _pageController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<InventoryProvider>(context, listen: false).fetchInventory();
//     });
//   }
//
//   void _goToPage(int page) {
//     final provider = Provider.of<InventoryProvider>(context, listen: false);
//     provider.goToPage(page);
//   }
//
//   void _jumpToPage() {
//     final provider = Provider.of<InventoryProvider>(context, listen: false);
//     int page = int.tryParse(_pageController.text) ?? 0;
//     if (page > 0 && page <= provider.totalPages) {
//       _goToPage(page - 1);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<InventoryProvider>(context);
//     List<String> columnNames = [
//       'COMPANY NAME',
//       'CATEGORY',
//       'IMAGE',
//       'BRAND',
//       'SKU',
//       'PRODUCT NAME',
//       'MRP',
//       'BOXSIZE',
//       'QUANTITY',
//       'ACTIONS',
//       'FLIPKART',
//       'SNAPDEAL',
//       'AMAZON.IN',
//     ];
//
//     final paginatedData = provider.getPaginatedData();
//
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Search bar and scrolling buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_left,
//                       color: AppColors.primaryGreen),
//                   onPressed: () {
//                     _scrollController.animateTo(
//                       _scrollController.position.pixels - 200,
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                     );
//                   },
//                 ),
//                 Expanded(
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: TextField(
//                       controller: _searchController,
//                       decoration: InputDecoration(
//                         hintText: 'Search...',
//                         hintStyle: TextStyle(color: Colors.grey[600]),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide:
//                           const BorderSide(color: AppColors.primaryGreen),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: 10, horizontal: 20),
//                         suffixIcon: IconButton(
//                           icon: const Icon(Icons.search,
//                               color: AppColors.primaryGreen),
//                           onPressed: () {
//                             print('Search: ${_searchController.text}');
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.arrow_right,
//                       color: AppColors.primaryGreen),
//                   onPressed: () {
//                     _scrollController.animateTo(
//                       _scrollController.position.pixels + 200,
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                     );
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             Expanded(
//               child: provider.isLoading
//                   ? const Center(child: InventoryLoadingAnimation())
//                   : SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     InventoryDataTable(
//                       columnNames: columnNames,
//                       rowsData: paginatedData,
//                       scrollController: _scrollController,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Custom pagination footer
//             CustomPaginationFooter(
//               currentPage: provider.currentPage,
//               totalPages: provider.totalPages,
//               buttonSize: MediaQuery.of(context).size.width > 600 ? 32 : 24,
//               pageController: _pageController,
//               onFirstPage: () => _goToPage(0),
//               onLastPage: () => _goToPage(provider.totalPages - 1),
//               onNextPage: () {
//                 if (provider.currentPage < provider.totalPages - 1) {
//                   _goToPage(provider.currentPage + 1);
//                 }
//               },
//               onPreviousPage: () {
//                 if (provider.currentPage > 0) {
//                   _goToPage(provider.currentPage - 1);
//                 }
//               },
//               onGoToPage: _goToPage,
//               onJumpToPage: _jumpToPage,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }