// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
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
  ComboProvider? comboProvider;
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _mrpController = TextEditingController();
  final _costController = TextEditingController();

  //final productController = MultiSelectController<String>();
 
  late final MultiSelectController<String> productController;

  void _clearFormFields() {
    _idController.clear();
    _nameController.clear();
    _mrpController.clear();
    _costController.clear();
    _skuController.clear();
    productController.selectedItems.clear();
  }

  void saveCombo(BuildContext context) async {
    ComboProvider comboProvider =
        Provider.of<ComboProvider>(context, listen: false);

    // Get the selected product IDs directly from the dropdown's selections
    List<String?> selectedProductIds =
        comboProvider.selectedProducts.map((product) => product.id).toList();

    final combo = Combo(
      id: _idController.text,
      products: selectedProductIds,
      name: _nameController.text,
      mrp: _mrpController.text,
      cost: _costController.text,
      comboSku: _skuController.text,
    );

    final comboApi = ComboApi();

    try {
      await comboApi.createCombo(
          combo, comboProvider.selectedImages, comboProvider.imageNames);
      // comboProvider.setCombo(combo);
      // comboProvider.addCombo(combo);
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
      comboProvider = Provider.of<ComboProvider>(context, listen: false);

      productController = MultiSelectController<String>();
      // print(1);
      // print(object)
      getDropValue();
    });
  }

  void getDropValue() async {
    await comboProvider!.fetchCombos();
    await comboProvider!.fetchProducts();
    print("new style");
    for (int i = 0; i < comboProvider!.products.length; i++) {
      print("heello i am divyansh");
      comboProvider!.addItem('$i:${comboProvider!.products[i].displayName}', comboProvider!.products[i].id);
      // items.add(DropdownItem<String>(
      //   label: '$i:${comboProvider!.products[i].displayName}',
      //   value: comboProvider!.products[i].id,
      // ));
    }

    print("length of it is here ${comboProvider!.item.length}");
    // setState(() {
  
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ComboProvider>(
          builder: (context, comboProvider, child) {
            // print("hete i am $items");

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
                    items:comboProvider.item,
                    controller: productController,
                    searchEnabled: true,
                    chipDecoration: const ChipDecoration(
                      backgroundColor: Colors.yellow,
                      wrap: true,
                      runSpacing: 2,
                      spacing: 10,
                    ),
                    fieldDecoration: FieldDecoration(
                      hintText: 'Select Products',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black87),
                      ),
                    ),
                    dropdownDecoration: const DropdownDecoration(
                      maxHeight: 500,
                    ),
                    onSelectionChange: (selectedItems) {
                      debugPrint(
                          'Selected items (product IDs): $selectedItems');
                      comboProvider.selectProductsByIds(selectedItems);
                    },
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
                  ElevatedButton(
                    onPressed: comboProvider.selectImages, // Pick images
                    child: const Text('Upload Images'),
                  ),
                  // Image Previews
                  comboProvider.selectedImages != null &&
                          comboProvider.selectedImages!.isNotEmpty
                      ? SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: comboProvider.selectedImages!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Image.memory(
                                        comboProvider.selectedImages![index],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      comboProvider.imageNames[index],
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : const Text('No images selected'),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => saveCombo(context),
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
                  if (comboProvider.loading)
                    const Center(child: CircularProgressIndicator()),
                  if (!comboProvider.loading &&
                      comboProvider.combosList.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: comboProvider.combosList.length,
                        itemBuilder: (context, index) {
                          final combo = comboProvider.combosList[index];
                          final products =
                              (combo['products'] as List<dynamic>?) ?? [];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name: ${combo['name'] ?? 'N/A'}'),
                                  Text('MRP: ${combo['mrp'] ?? 'N/A'}'),
                                  Text('Cost: ${combo['cost'] ?? 'N/A'}'),
                                  Text('SKU: ${combo['sku'] ?? 'N/A'}'),
                                  if (products.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    const Text('Products:'),
                                    Column(
                                      children: products.map((product) {
                                        // Ensure that 'image' field exists and is a list of URLs.
                                        final imageUrl = (product['images']
                                                        as List<dynamic>?)
                                                    ?.isNotEmpty ==
                                                true
                                            ? product['images'][0]
                                            : null;

                                        return ListTile(
                                          leading: imageUrl != null
                                              ? Image.network(
                                                  imageUrl,
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                )
                                              : const Icon(
                                                  Icons.image,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                          title: Text(
                                              product['displayName'] ?? 'N/A'),
                                          subtitle: Text(
                                              'SKU: ${product['sku'] ?? 'N/A'}'),
                                        );
                                      }).toList(),
                                    ),
                                  ],
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

class CustomDropdownItem<T> extends DropdownItem<T> {
  CustomDropdownItem({
    required String label,
    required T value,
    bool disabled = false,
    bool selected = false,
  }) : super(
          label: label,
          value: value,
          disabled: disabled,
          selected: selected,
        );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomDropdownItem<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
