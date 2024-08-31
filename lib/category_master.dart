//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:inventory_management/Api/auth_provider.dart';
import 'package:inventory_management/Custom-Files/categoryCard.dart';

class CategoryMasterPage extends StatefulWidget {
  @override
  _CategoryMasterPageState createState() => _CategoryMasterPageState();
}

class _CategoryMasterPageState extends State<CategoryMasterPage> {
  late Future<List<String>> _categoriesFuture;
  final TextEditingController _categoryIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories();
  }

  Future<List<String>> _fetchCategories() async {
    final result = await AuthProvider().getAllCategories();
    if (result['success']) {
      final List<dynamic> data = result['data'];
      return data.map((category) => category['name'] as String).toList();
    } else {
      print('Failed to fetch categories: ${result['message']}');
      return [];
    }
  }

  Future<void> _createCategory() async {
    final TextEditingController idController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: idController,
                  decoration: InputDecoration(hintText: 'Enter Category ID'),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: 'Enter Category Name'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Create'),
              onPressed: () async {
                final id = idController.text;
                final name = nameController.text;

                // Call createCategory API
                final result = await AuthProvider().createCategory(id, name);

                if (result['success']) {
                  // Refresh the category list
                  setState(() {
                    _categoriesFuture = _fetchCategories();
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(result['message'] ?? 'An error occurred')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCategoryByIdDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fetch Category by ID'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _categoryIdController,
                  decoration: InputDecoration(hintText: 'Enter Category ID'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Fetch'),
              onPressed: () async {
                final id = _categoryIdController.text;

                // Call getCategoryById API
                final result = await AuthProvider().getCategoryById(id);

                if (result['success']) {
                  setState(() {});
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(result['message'] ?? 'An error occurred')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

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
                  onPressed: _createCategory,
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
                ElevatedButton.icon(
                  onPressed: _showCategoryByIdDialog,
                  icon: const Icon(Icons.search),
                  label: const Text("Fetch Category by ID"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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
                  child: FutureBuilder<List<String>>(
                    future: _categoriesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        print('Snapshot error: ${snapshot.error}');
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No categories found'));
                      }

                      final categories = snapshot.data!;
                      return GridView.builder(
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
