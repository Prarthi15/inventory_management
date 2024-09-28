import 'package:flutter/material.dart';
import 'package:inventory_management/Custom-Files/excelFileUpload.dart';
import 'package:inventory_management/provider/product_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:inventory_management/Api/auth_provider.dart';

class ProductDataDisplay extends StatelessWidget {
  const ProductDataDisplay({super.key});

  Future<void> _uploadProducts(BuildContext context) async {
    final authProvider = AuthProvider();
    final productDataProvider =
        Provider.of<ProductDataProvider>(context, listen: false);

    if (productDataProvider.dataGroups.isEmpty) {
      _showMessage(context, 'No data available to upload.', isError: true);
      return;
    }

    productDataProvider.setUploading(true);

    int successCount = 0;
    List<String> errorMessages = [];

    for (var productData in productDataProvider.dataGroups) {
      Map<String, dynamic> productApiData = {
        'displayName': productData['displayName'] ?? '',
        'parentSku': productData['parentSku'] ?? '',
        'sku': productData['sku'] ?? '',
        'netWeight': productData['netWeight'] ?? '',
        'grossWeight': productData['grossWeight'] ?? '',
        'cost': productData['cost'] ?? '',
        'mrp': productData['mrp'] ?? '',
        'ean': productData['ean'] ?? '',
        'brand_id': productData['brand_id'] ?? '',
        'tax_rule': productData['tax_rule'] ?? '',
        'description': productData['description'] ?? '',
        'technicalName': productData['technicalName'] ?? '',
        'labelSku': productData['labelSku'] ?? '',
        'box_name': productData['box_name'] ?? '',
        'categoryName': productData['categoryName'] ?? '',
        'length': productData['length'] ?? '',
        'width': productData['width'] ?? '',
        'height': productData['height'] ?? '',
        'shopifyImage': productData['shopifyImage'] ?? '',
        'grade': productData['grade'] ?? ''
      };

      String? result = await authProvider.createProduct(productApiData);
      if (result != null && result.contains('successfully')) {
        successCount++;
      } else {
        errorMessages.add(result ?? 'Unknown error');
      }
    }

    productDataProvider.setUploading(false);

    if (successCount > 0) {
      productDataProvider.reset();
      _showMessage(context, '$successCount products uploaded successfully!');
    }

    if (errorMessages.isNotEmpty) {
      String errorMessage = errorMessages.join('\n');
      _showMessage(context, errorMessage, isError: true);
    }
  }

  void _showMessage(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.cardsred : AppColors.primaryGreen,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productDataProvider = Provider.of<ProductDataProvider>(context);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double baseTextSize =
        screenWidth > 1200 ? 16.0 : (screenWidth > 800 ? 15.0 : 14.0);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ExcelFileUploader(
                  sheetName: 'Sheet1',
                  onUploadSuccess: (List<Map<String, String>> uploadedData) {
                    productDataProvider.setDataGroups(uploadedData);
                  },
                  onError: (String errorMessage) {
                    _showMessage(context, errorMessage, isError: true);
                  },
                ),
                const SizedBox(width: 16.0),
                if (productDataProvider.isUploadSuccessful) ...[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                    ),
                    onPressed: productDataProvider.isUploading
                        ? null
                        : () => _uploadProducts(context),
                    child: const Text('Upload Products'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () {
                      // Clear the uploaded data
                      productDataProvider.reset();
                      _showMessage(context, 'Upload cancelled.');
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: productDataProvider.dataGroups.isEmpty
                  ? const Center(child: Text('No data available.'))
                  : ListView.builder(
                      itemCount: productDataProvider.dataGroups.length,
                      itemBuilder: (context, index) {
                        Map<String, String> dataMap =
                            productDataProvider.dataGroups[index];

                        return GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.blueAccent, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (dataMap['shopifyImage'] != null &&
                                    dataMap['shopifyImage']!.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      dataMap['shopifyImage']!,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                const SizedBox(height: 4.0),
                                _buildRowContent(dataMap, baseTextSize),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowContent(Map<String, String> dataMap, double baseTextSize) {
    final List<String> fieldsToShow = dataMap.keys.toList();

    List<Widget> rowWidgets = [];

    for (int i = 0; i < fieldsToShow.length; i += 2) {
      String leftField = fieldsToShow[i];
      String rightField =
          fieldsToShow.length > i + 1 ? fieldsToShow[i + 1] : '';

      rowWidgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTwoColumnRow(
                leftField, dataMap[leftField] ?? 'N/A', baseTextSize),
            if (rightField.isNotEmpty)
              _buildTwoColumnRow(
                  rightField, dataMap[rightField] ?? 'N/A', baseTextSize),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rowWidgets,
    );
  }

  Widget _buildTwoColumnRow(
      String fieldName, String value, double baseTextSize) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                '$fieldName:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: baseTextSize,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              flex: 5,
              child: Text(
                value,
                style: TextStyle(fontSize: baseTextSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
