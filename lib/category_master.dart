import 'package:flutter/material.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:inventory_management/Api/auth_provider.dart';
import 'package:inventory_management/Custom-Files/categoryCard.dart';
import 'package:inventory_management/Custom-Files/custom-button.dart';

class CategoryMasterPage extends StatefulWidget {
  @override
  _CategoryMasterPageState createState() => _CategoryMasterPageState();
}

class _CategoryMasterPageState extends State<CategoryMasterPage> {
  late Future<List<String>> _categoriesFuture;
  final TextEditingController _categoryIdController = TextEditingController();

  int _currentPage = 1;
  bool _hasMore = true;
  List<String> _categories = [];
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories(page: _currentPage);
  }

  Future<List<String>> _fetchCategories({int page = 1}) async {
    if (_isFetching)
      return _categories; // Avoid fetching if already in progress
    _isFetching = true;

    final result = await AuthProvider().getAllCategories(page: page);
    _isFetching = false;

    if (result['success']) {
      final List<dynamic> data = result['data'];
      if (data.isNotEmpty) {
        _currentPage++;
        setState(() {
          _categories.addAll(
              data.map((category) => category['name'] as String).toList());
          _hasMore = data.length == 20; // Assuming 20 items per page
        });
      } else {
        _hasMore = false;
      }
      return _categories;
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
            CustomButton(
              width: 100,
              height: 40,
              onTap: () async {
                final id = idController.text;
                final name = nameController.text;

                final result = await AuthProvider().createCategory(id, name);

                if (result['success']) {
                  // Refresh the category list
                  _currentPage = 1; // Reset page number
                  _categories.clear(); // Clear the existing list
                  setState(() {
                    _categoriesFuture = _fetchCategories(page: _currentPage);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Category created successfully!'),
                      backgroundColor: AppColors.green,
                    ),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Failed to create category: ${result['message']}'),
                      backgroundColor: AppColors.cardsred,
                    ),
                  );
                }
              },
              color: AppColors.tealcolor,
              textColor: AppColors.white,
              fontSize: 16,
              text: 'Create',
              borderRadius: BorderRadius.circular(12),
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
            CustomButton(
              width: 100,
              height: 40,
              onTap: () async {
                final id = _categoryIdController.text;

                // Call getCategoryById API
                final result = await AuthProvider().getCategoryById(id);

                if (result['success']) {
                  final category = result['data'];
                  setState(() {
                    if (category != null) {
                      _categories = [category['name']];
                      _currentPage = 1;
                      _hasMore = false;
                    } else {
                      _categories = [];
                    }
                  });
                  _categoryIdController.clear();
                  Navigator.of(context).pop();
                } else {
                  print('Failed to fetch category: ${result['message']}');
                  setState(() {
                    _categories = [];
                    _currentPage = 1; // Reset page number
                    _hasMore = false; // No more pages
                  });
                  _categoryIdController.clear();
                  Navigator.of(context).pop();
                }
              },
              color: AppColors.primaryBlue,
              textColor: AppColors.white,
              fontSize: 16,
              text: 'Fetch',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAllCategories() async {
    setState(() {
      _currentPage = 1; // Reset page number
      _categories.clear(); // Clear the existing list
      _hasMore = true;
      _categoriesFuture = _fetchCategories(page: _currentPage);
    });
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
                isSmallScreen
                    ? Wrap(
                        spacing: 16.0,
                        runSpacing: 16.0,
                        children: [
                          _buildButton(
                            text: 'Create Category',
                            color: AppColors.tealcolor,
                            icon: Icons.add,
                            onTap: _createCategory,
                          ),
                          _buildButton(
                            text: 'Fetch Category by ID',
                            color: AppColors.primaryBlue,
                            icon: Icons.search,
                            onTap: _showCategoryByIdDialog,
                          ),
                          _buildButton(
                            text: 'Show All Categories',
                            color: AppColors.green,
                            icon: Icons.list,
                            onTap: _showAllCategories,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          _buildButton(
                            text: 'Create Category',
                            color: AppColors.tealcolor,
                            icon: Icons.add,
                            onTap: _createCategory,
                          ),
                          const SizedBox(width: 16.0), // Space between buttons
                          _buildButton(
                            text: 'Fetch Category by ID',
                            color: AppColors.primaryBlue,
                            icon: Icons.search,
                            onTap: _showCategoryByIdDialog,
                          ),
                          const SizedBox(width: 16.0), // Space between buttons
                          _buildButton(
                            text: 'Show All Categories',
                            color: AppColors.green,
                            icon: Icons.list,
                            onTap: _showAllCategories,
                          ),
                        ],
                      ),
                const SizedBox(height: 24.0),
                Expanded(
                  child: FutureBuilder<List<String>>(
                    future: _categoriesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show loading indicator while waiting for the data
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        // Handle error case
                        return const Center(
                          child: Text(
                            'Failed to load categories',
                            style:
                                TextStyle(fontSize: 18, color: AppColors.grey),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // Handle the case when no data is returned
                        return const Center(
                          child: Text(
                            'No item found',
                            style:
                                TextStyle(fontSize: 18, color: AppColors.grey),
                          ),
                        );
                      } else {
                        // Data is successfully loaded
                        return NotificationListener<ScrollNotification>(
                          onNotification: (scrollInfo) {
                            if (!_isFetching &&
                                _hasMore &&
                                scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics.maxScrollExtent) {
                              _fetchCategories(page: _currentPage);
                            }
                            return true;
                          },
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              childAspectRatio: isSmallScreen ? 4 : 3,
                            ),
                            itemCount: _categories.length + (_hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= _categories.length) {
                                return const Center(
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              return CategoryCard(
                                category: _categories[index],
                                isSmallScreen: isSmallScreen,
                                cardColor: AppColors.white,
                                shadowColor: AppColors.shadowblack1,
                                elevation: 3,
                                borderRadius: 12,
                              );
                            },
                          ),
                        );
                      }
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

  Widget _buildButton({
    required String text,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 200,
      height: 50,
      child: CustomButton(
        onTap: onTap,
        color: color,
        textColor: AppColors.white,
        fontSize: 16,
        text: text,
        borderRadius: BorderRadius.circular(12),
        prefixIcon: Icon(icon, color: AppColors.white),
        width: 20,
        height: 20,
      ),
    );
  }
}
