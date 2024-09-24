import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inventory_management/provider/marketplace_provider.dart';
import 'package:inventory_management/custom-files/custom-dropdown.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  _MarketplacePageState createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MarketplaceProvider>(context, listen: false);
      provider.fetchProducts();
      provider.fetchMarketplaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MarketplaceProvider>(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              provider.toggleForm(); // Toggle the form visibility
            },
            child: const Text('Create Marketplace'),
          ),
          const SizedBox(height: 8),
          if (provider.isFormVisible) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Marketplace',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: provider.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'SKU Map:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Consumer<MarketplaceProvider>(
                    builder: (context, provider, child) {
                      // Prepare the options for CustomDropdown
                      List<Map<String, dynamic>> options = provider.products
                          .map((product) => {
                                'name': product.displayName ?? 'Unknown',
                                'product': product,
                              })
                          .toList();

                      return Column(
                        children: provider.skuMaps.map((skuMap) {
                          int index = provider.skuMaps.indexOf(skuMap);
                          return Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(
                                      text: skuMap.mktpSku),
                                  decoration: const InputDecoration(
                                    labelText: 'SKU',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    provider.updateSkuMap(
                                        index, value, skuMap.product);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: CustomDropdown(
                                  option: options,
                                  selectedIndex: skuMap.product != null
                                      ? options.indexWhere((option) =>
                                          option['product'] == skuMap.product)
                                      : 0,
                                  onSelectedChanged: (selectedIndex) {
                                    final selectedProduct = options.isNotEmpty
                                        ? options[selectedIndex]['product']
                                        : null;
                                    provider.updateSkuMap(
                                        index, skuMap.mktpSku, selectedProduct);
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () {
                                  provider.removeSkuMapRow(index);
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      provider
                          .addSkuMapRow(); // Adds a new empty row for SKU Map
                    },
                    child: const Text('Add New Row'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.isSaving
                        ? null // Disable button while saving
                        : () async {
                            await provider
                                .saveMarketplace(); // Save marketplace
                          },
                    child: provider.isSaving
                        ? const CircularProgressIndicator(
                            color: Colors
                                .purple, // Show progress indicator while saving
                          )
                        : const Text(
                            'Save Marketplace'), // Normal text when not saving
                  ),
                ],
              ),
            ),
          ],
          if (!provider.isFormVisible) ...[
            const SizedBox(height: 16),
            const Text(
              'Existing Marketplaces:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<MarketplaceProvider>(
                builder: (context, provider, child) {
                  if (provider.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.marketplaces.isEmpty) {
                    return const Center(child: Text('No marketplaces found.'));
                  }

                  return ListView.builder(
                    itemCount: provider.marketplaces.length,
                    itemBuilder: (context, index) {
                      final marketplace = provider.marketplaces[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    marketplace.name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      // Confirm deletion
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Delete Marketplace'),
                                            content: const Text(
                                                'Are you sure you want to delete this marketplace?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  provider.deleteMarketplace(
                                                      marketplace
                                                          .id!); // Implement delete method
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: marketplace.skuMap.map((skuMap) {
                                  final product = skuMap.product;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'SKU: ${skuMap.mktpSku}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Product: ${product?.displayName ?? 'Unknown'}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Product SKU: ${product?.sku ?? 'N/A'}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
