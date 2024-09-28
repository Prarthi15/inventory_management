import 'package:flutter/material.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:inventory_management/Custom-Files/show-details-order-item.dart';
import 'package:inventory_management/provider/book_provider.dart';
import 'package:provider/provider.dart';
 // Import the provider

class BookPage extends StatelessWidget {
  const BookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        return Scaffold(
          body: Column(
            children: [
              // Horizontal Tab Bar
              Container(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          bookProvider.toggleSelection(true);
                        },
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                            color: bookProvider.isB2BSelected
                                ? Colors.blue
                                : AppColors.greyBackground,
                          ),
                          child: Center(
                            child: Text(
                              'B2B',
                              style: TextStyle(
                                color: bookProvider.isB2BSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      GestureDetector(
                        onTap: () {
                          bookProvider.toggleSelection(false);
                        },
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                            color: !bookProvider.isB2BSelected
                                ? Colors.blue
                                : AppColors.greyBackground,
                          ),
                          child: Center(
                            child: Text(
                              'B2C',
                              style: TextStyle(
                                color: !bookProvider.isB2BSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.list),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Display number of selected products
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Selected Products: ${bookProvider.selectedCount}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              // Table with horizontal scroll
              Expanded(
                child: Container(
                  color: AppColors.greyBackground,
                  width: double.infinity, // Make the table take the full width of the screen
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Optional padding

                  child: SingleChildScrollView(
                    child: DataTable(
                      dataRowHeight: 300,
                      columnSpacing: 30.0,
                      columns: [
                        // DataColumn with checkbox to select/deselect all products
                        DataColumn(
                          label: Row(
                            children: [
                              Transform.scale(
                                scale: 1,
                                child: Checkbox(
                                  value: bookProvider.selectAll,
                                  onChanged: (bool? value) {
                                    bookProvider.toggleSelectAll(value ?? false);
                                  },
                                  activeColor: Colors.blue, // Customize the active color
                                  checkColor: Colors.white, // Customize the check mark color
                                  side: const BorderSide(color: Colors.blue), // Customize the border color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4), // Customize the border radius
                                  ),
                                ),
                              ),
                              const Text('Select All'),
                            ],
                          ),
                        ),
                        const DataColumn(
                          label: Text(
                            'PRODUCTS',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const DataColumn(
                          label: Text(
                            'DELIVERY',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const DataColumn(
                          label: Text(
                            'SHIPROCKET',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      rows: List<DataRow>.generate(
                        bookProvider.selectedProducts.length,
                        (index) => DataRow(
                          selected: bookProvider.selectedProducts[index],
                          cells: [
                            // Checkbox for each row
                            DataCell(
                              Transform.scale(
                                scale: 1,
                                child: Checkbox(
                                  value: bookProvider.selectedProducts[index],
                                  onChanged: (bool? value) {
                                    bookProvider.toggleProductSelection(index, value ?? false);
                                  },
                                  activeColor: Colors.blue, // Customize the active color
                                  checkColor: Colors.white, // Customize the check mark color
                                  side: const BorderSide(color: Colors.blue), // Customize the border color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4), // Customize the border radius
                                  ),
                                ),
                              ),
                            ),

                            // Product Image and Name in one cell
                            DataCell(
                              SizedBox(
                                width: 556,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Display the Order ID
                                      Text(
                                        'ORDER ID: KSK-2599${index + 1}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.blue),
                                      ),

                                      const SizedBox(height: 10),

                                      const Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.image,
                                            size: 100,
                                            color: Colors.grey,
                                          ),
                                          // Image.network(
                                          //   'https://sharmellday.com/wp-content/uploads/2022/12/032_Canva-Text-to-Image-Generator-min-1.jpg',
                                          //   width: 50,
                                          //   height: 50,
                                          // ),
                                          SizedBox(width: 10),
                                          SizedBox(
                                            width: 430,
                                            child: Column(
                                              children: [
                                                // Product 1 Information
                                                Text(
                                                  'Nemotude Plus (Bio Pesticides verticillium chalamydosporium 1% WP)',
                                                  style: TextStyle(fontSize: 16),
                                                  softWrap: true, // Enable text wrapping
                                                  maxLines: 3, // Adjust max lines if needed
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),

                                                Row(
                                                  children: [
                                                    Text(
                                                      'SKU : k-5560 ',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    SizedBox(width: 150),
                                                    Text(
                                                      'Quality : 10 ',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(color: Colors.grey),
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.image,
                                            size: 100,
                                            color: Colors.grey,
                                          ),
                                          // Image.network(
                                          //   'https://sharmellday.com/wp-content/uploads/2022/12/032_Canva-Text-to-Image-Generator-min-1.jpg',
                                          //   width: 50,
                                          //   height: 50,
                                          // ),
                                          SizedBox(width: 10),
                                          SizedBox(
                                            width: 430,
                                            child: Column(
                                              children: [
                                                // Product 1 Information
                                                Text(
                                                  'Motude Plus (Bio Pesticides verticillium chalamydosporium 1% WP)',
                                                  style: TextStyle(fontSize: 16),
                                                  softWrap: true, // Enable text wrapping
                                                  maxLines: 3, // Adjust max lines if needed
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'SKU : k-9560 ',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    SizedBox(width: 150),
                                                    Text(
                                                      'Quality : 04 ',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Delivery price (INR)
                            const DataCell(
                              Text(
                                'Rs. 2000',
                                style: TextStyle(fontSize: 18),
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),

                            // Shiprocket price (INR)
                            const DataCell(
                              Text(
                                'Rs. 2000',
                                style: TextStyle(fontSize: 18),
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
