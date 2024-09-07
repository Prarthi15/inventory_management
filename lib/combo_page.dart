import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inventory_management/provider/combo_provider.dart';
import 'package:inventory_management/Custom-Files/colors.dart';

class ComboPage extends StatefulWidget {
  const ComboPage({super.key});

  @override
  _ComboPageState createState() => _ComboPageState();
}

class _ComboPageState extends State<ComboPage> {
  bool _isFormVisible = false;

  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();

  final List<Map<String, dynamic>> _products = [];
  final List<Map<String, dynamic>> _mrp = [];
  final List<Map<String, dynamic>> _cost = [];

  void _addProduct() {
    // add products logic
  }

  void _addMRP() {
    // add mrp logic
  }

  void _addCost() {
    // add cost logic
  }

  @override
  Widget build(BuildContext context) {
    final comboProvider = Provider.of<ComboProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isFormVisible = !_isFormVisible;
                });
              },
              child: Text(_isFormVisible ? 'Cancel' : 'Create Combo'),
            ),
            if (_isFormVisible) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _idController,
                      decoration: const InputDecoration(labelText: 'ID'),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _skuController,
                      decoration: const InputDecoration(labelText: 'SKU'),
                    ),
                    const SizedBox(height: 16),
                    const Text('Products'),
                    ElevatedButton(
                      onPressed: _addProduct,
                      child: const Text('Add Product'),
                    ),
                    const SizedBox(height: 16),
                    const Text('MRP'),
                    ElevatedButton(
                      onPressed: _addMRP,
                      child: const Text('Add MRP'),
                    ),
                    const SizedBox(height: 16),
                    const Text('Cost'),
                    ElevatedButton(
                      onPressed: _addCost,
                      child: const Text('Add Cost'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final combo = Combo(
                          id: _idController.text,
                          products: _products,
                          name: _nameController.text,
                          mrp: _mrp,
                          cost: _cost,
                          sku: _skuController.text,
                        );
                        comboProvider.createCombo(combo);
                        setState(() {
                          _isFormVisible = false;
                        });
                      },
                      child: const Text('Save Combo'),
                    ),
                  ],
                ),
              ),
            ],
            if (comboProvider.combo != null) ...[
              const SizedBox(height: 16),
              const Text('Created Combo:'),
              Text('ID: ${comboProvider.combo!.id}'),
              Text('Name: ${comboProvider.combo!.name}'),
              Text(
                  'MRP: ${comboProvider.combo!.mrp.map((e) => e.toString()).join(', ')}'),
              Text(
                  'Cost: ${comboProvider.combo!.cost.map((e) => e.toString()).join(', ')}'),
              Text('SKU: ${comboProvider.combo!.sku}'),
            ],
          ],
        ),
      ),
    );
  }
}
