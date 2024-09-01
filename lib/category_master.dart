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
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();

  List<String> _categories = [];
  List<String> _filteredCategories = [];
  bool _isFetching = false;
  bool _isSearchMode = false;
  bool _isCreatingCategory = false;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchAllCategories();
    _searchController.addListener(() {
      if (_isSearchMode) {
        _filterCategories(_searchController.text);
      }
    });
  }

  Future<List<String>> _fetchAllCategories({String? name}) async {
    List<String> allCategories = [];
    bool hasMore = true;
    int page = 1;

    while (hasMore) {
      if (_isFetching) return allCategories;
      _isFetching = true;

      final result =
          await AuthProvider().getAllCategories(page: page, name: name);
      _isFetching = false;

      if (result['success']) {
        final List<dynamic> data = result['data'];
        if (data.isNotEmpty) {
          allCategories.addAll(
              data.map((category) => category['name'] as String).toList());
          hasMore = data.length == 20; // Assuming 20 items per page
          page++;
        } else {
          hasMore = false;
        }
      } else {
        print('Failed to fetch categories: ${result['message']}');
        hasMore = false;
      }
    }

    setState(() {
      _categories = allCategories;
      _filteredCategories = _categories;
    });

    return allCategories;
  }

  void _filterCategories(String query) {
    setState(() {
      _filteredCategories = _categories.where((category) {
        return category.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _createCategory() async {
    final name = _categoryNameController.text;

    if (name.isNotEmpty) {
      final result = await AuthProvider().createCategory('', name);

      if (result['success']) {
        setState(() {
          _categoriesFuture = _fetchAllCategories(); // Refresh the list
          _searchController.clear();
          _categoryNameController.clear();
          _isCreatingCategory = false; // Hide the input field
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category created successfully!'),
            backgroundColor: AppColors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create category: ${result['message']}'),
            backgroundColor: AppColors.cardsred,
          ),
        );
      }
    }
  }

  void _toggleSearchMode() {
    setState(() {
      _isSearchMode = !_isSearchMode;
      if (!_isSearchMode) {
        _searchController.clear();
        _filteredCategories = _categories;
      }
    });
  }

  void _toggleCreateCategoryMode() {
    setState(() {
      _isCreatingCategory = !_isCreatingCategory;
      if (_isCreatingCategory) {
        _searchController.clear();
        _filteredCategories = _categories;
        _isSearchMode = false; // Ensure search mode is off
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;

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
                            text: _isCreatingCategory ? 'Cancel' : 'Create',
                            color: AppColors.tealcolor,
                            icon:
                                _isCreatingCategory ? Icons.cancel : Icons.add,
                            onTap: _toggleCreateCategoryMode,
                          ),
                          if (!_isCreatingCategory) ...[
                            _buildButton(
                              text: _isSearchMode ? 'Cancel' : 'Search',
                              color: AppColors.primaryBlue,
                              icon: _isSearchMode ? Icons.cancel : Icons.search,
                              onTap: _toggleSearchMode,
                            ),
                          ],
                          if (_isCreatingCategory)
                            Container(
                              margin: const EdgeInsets.only(top: 16.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 150, // Adjust the width here
                                    child: TextField(
                                      controller: _categoryNameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Category Name',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  ElevatedButton(
                                    onPressed: _createCategory,
                                    child: const Text('Add'),
                                  ),
                                ],
                              ),
                            ),
                          if (_isSearchMode && !_isCreatingCategory)
                            Container(
                              margin: const EdgeInsets.only(top: 16.0),
                              child: SizedBox(
                                width: 150, // Adjust the width here
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    labelText: 'Search Category by Name',
                                    suffixIcon: Icon(Icons.search),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      )
                    : Row(
                        children: [
                          _buildButton(
                            text: _isCreatingCategory ? 'Cancel' : 'Create',
                            color: AppColors.tealcolor,
                            icon:
                                _isCreatingCategory ? Icons.cancel : Icons.add,
                            onTap: _toggleCreateCategoryMode,
                          ),
                          const SizedBox(width: 16.0),
                          if (!_isCreatingCategory) ...[
                            _buildButton(
                              text: _isSearchMode ? 'Cancel' : 'Search',
                              color: AppColors.primaryBlue,
                              icon: _isSearchMode ? Icons.cancel : Icons.search,
                              onTap: _toggleSearchMode,
                            ),
                          ],
                          const SizedBox(width: 16.0),
                          if (_isCreatingCategory)
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 200, // Adjust the width here
                                    child: TextField(
                                      controller: _categoryNameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Category Name',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  ElevatedButton(
                                    onPressed: _createCategory,
                                    child: const Text('Add'),
                                  ),
                                ],
                              ),
                            ),
                          if (_isSearchMode && !_isCreatingCategory)
                            Expanded(
                              child: SizedBox(
                                width: 200, // Adjust the width here
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    labelText: 'Search Category by Name',
                                    suffixIcon: Icon(Icons.search),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                const SizedBox(height: 24.0),
                Expanded(
                  child: FutureBuilder<List<String>>(
                    future: _categoriesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Failed to load categories',
                            style:
                                TextStyle(fontSize: 18, color: AppColors.grey),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No categories found',
                            style:
                                TextStyle(fontSize: 18, color: AppColors.grey),
                          ),
                        );
                      } else {
                        final categoriesToShow =
                            _isSearchMode ? _filteredCategories : _categories;

                        return ListView.builder(
                          itemCount: categoriesToShow.length,
                          itemBuilder: (context, index) {
                            return CategoryCard(
                              category: categoriesToShow[index],
                              isSmallScreen: isSmallScreen,
                              cardColor: AppColors.white,
                              shadowColor: AppColors.shadowblack1,
                              elevation: 3,
                              borderRadius: 12,
                            );
                          },
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
    return CustomButton(
      width: 120,
      height: 40,
      onTap: onTap,
      color: color,
      textColor: AppColors.white,
      fontSize: 16,
      text: text,
      borderRadius: BorderRadius.circular(12),
      prefixIcon: Icon(icon, size: 18, color: AppColors.white),
    );
  }
}
