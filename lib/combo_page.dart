// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_management/Api/combo_api.dart';
import 'package:inventory_management/model/combo_model.dart';
import 'package:inventory_management/provider/combo_provider.dart';
import 'package:provider/provider.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class ComboPage extends StatefulWidget {
  const ComboPage({super.key});

  @override
  _ComboPageState createState() => _ComboPageState();
}

class _ComboPageState extends State<ComboPage> {
  Product? product;
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _mrpController = TextEditingController();
  final _costController = TextEditingController();

  final productController = MultiSelectController<String>();

  void _clearFormFields() {
    _idController.clear();
    _nameController.clear();
    _mrpController.clear();
    _costController.clear();
    _skuController.clear();
    productController.selectedItems.clear();
  }

  void saveCombo(ComboProvider comboProvider) async {
    final combo = Combo(
      id: _idController.text,
      products: productController.selectedItems
          .map((product) => {'product_id': product.value})
          .toList(),
      name: _nameController.text,
      mrp: double.tryParse(_mrpController.text) ?? 0.0,
      cost: double.tryParse(_costController.text) ?? 0.0,
      sku: _skuController.text,
    );

    final comboApi = ComboApi();

    try {
      await comboApi.createCombo(combo);
      comboProvider.setCombo(combo);
      comboProvider.addCombo(combo);
      _clearFormFields();
      comboProvider.toggleFormVisibility();
    } catch (e) {
      print('Failed to save combo: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final comboProvider = Provider.of<ComboProvider>(context, listen: false);
      comboProvider.fetchCombos();
      comboProvider.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ComboProvider>(
          builder: (context, comboProvider, child) {
            final comboProvider = Provider.of<ComboProvider>(context);

            List<DropdownItem<String>> productItems = comboProvider.products
                .map((product) => DropdownItem<String>(
                      label:
                          product.displayName!, // Use 'displayName' of product
                      value: product.id!, // Use the 'id' of product
                    ))
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    comboProvider.toggleFormVisibility();
                  },
                  child: const Text('Create Combo'),
                ),
                if (comboProvider.isFormVisible) ...[
                  const SizedBox(height: 16),
                  // TextField(
                  //   controller: _idController,
                  //   decoration: const InputDecoration(labelText: 'ID'),
                  // ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  MultiDropdown<String>(
                    items: productItems,
                    controller: productController,
                    enabled: true,
                    searchEnabled: true,
                    chipDecoration: const ChipDecoration(
                      backgroundColor: Colors.yellow,
                    ),
                    fieldDecoration: FieldDecoration(
                      hintText: 'Select Products',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    dropdownDecoration: const DropdownDecoration(
                      maxHeight: 300,
                    ),
                    dropdownItemDecoration: const DropdownItemDecoration(
                      selectedIcon: Icon(Icons.check_box, color: Colors.green),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _mrpController,
                    decoration: const InputDecoration(labelText: 'MRP'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _costController,
                    decoration: const InputDecoration(labelText: 'Cost'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _skuController,
                    decoration: const InputDecoration(labelText: 'SKU'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => saveCombo(
                          Provider.of<ComboProvider>(context, listen: false),
                        ),
                        child: const Text('Save Combo'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          _clearFormFields();
                          comboProvider.toggleFormVisibility();
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  )
                ],

                // Do not touch this code - Begin - This is for getCombos
                if (!comboProvider.isFormVisible) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Existing Combos:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (comboProvider.isLoading)
                  const Center(child: CircularProgressIndicator()),

                  if (!comboProvider.isLoading && comboProvider.comboList.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: comboProvider.comboList.length,
                        itemBuilder: (context, index) {
                          final combo = comboProvider.comboList[index];
                          final products = combo.products!;
                          //print(combo.products);

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Row(
                                  //   children: [
                                  //     const Text(
                                  //       'ID:',
                                  //       style: TextStyle(
                                  //         fontSize: 16,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //     const SizedBox(width: 8),
                                  //     Text(
                                  //       combo.id ?? 'N/A',
                                  //       style: const TextStyle(fontSize: 16),
                                  //     ),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Text(
                                        'Name:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        combo.name!,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Products:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Card(
                                          color: Colors.grey[200],
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: products.map((e) {
                                                  final product = e[
                                                          'product_id'] ??
                                                      {}; // Fetch product details safely
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical:
                                                            8.0), // Add some space between products
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                product['displayName'] ??
                                                                    'Product Name: N/A', // Display product name
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              const SizedBox(
                                                                  height: 4),
                                                              Text(
                                                                'Description: ${product['description'] ?? 'N/A'}', // Display description
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            16),
                                                              ),
                                                              const SizedBox(
                                                                  height: 4),
                                                              Text(
                                                                'Weight: ${product['weight'] ?? 'N/A'}', // Display weight
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            16),
                                                              ),
                                                              const SizedBox(
                                                                  height: 4),
                                                              Text(
                                                                'Type: ${product['productType'] ?? 'N/A'}', // Display product type
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            16),
                                                              ),
                                                              const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .grey), // Divider for separation
                                                            ],
                                                          ),
                                                        ),
                                                        const Expanded(
                                                          flex:
                                                              1, // Adjust the space ratio for the image/icon
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .image, // Placeholder for product image
                                                                size:
                                                                    50, // Size of the icon
                                                                color: Colors
                                                                    .grey, // Icon color
                                                              ),
                                                              SizedBox(
                                                                  height: 8),
                                                              // Optional: Add a placeholder for future image if needed
                                                              // Image.network(productImageUrl), // If you have product image URLs
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Text(
                                        'MRP:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '₹${combo.mrp!.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Text(
                                        'Cost:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '₹${combo.cost!.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Text(
                                        'SKU:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        combo.sku!,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
                // Do not touch this code - End
              ],
            );
          },
        ),
      ),
    );
  }
}
