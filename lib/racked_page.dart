import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:inventory_management/provider/racked_provider.dart';

class RackedPage extends StatefulWidget {
  const RackedPage({super.key});

  @override
  State<RackedPage> createState() => _RackedPageState();
}

class _RackedPageState extends State<RackedPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RackedProvider>(
      builder: (context, rackedProvider, child) {
        // Fixed variable name to pickerProvider
        return Scaffold(
          body: Column(
            children: [
              // Display number of selected products
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Selected Orders: ${rackedProvider.selectedCount}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Table with horizontal scroll
              Expanded(
                child: Container(
                  color: AppColors.greyBackground,
                  width: double
                      .infinity, // Make the table take the full width of the screen
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Optional padding

                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        dataRowHeight: 300,
                        columnSpacing: MediaQuery.of(context).size.width * 0.08,
                        columns: [
                          const DataColumn(
                            label: Text(
                              'ORDERS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              'CUSTOMER DETAIL',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              'DATE',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              'TOTAL',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              'WEIGHT',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // DataColumn with checkbox to select/deselect all products
                          DataColumn(
                            label: Row(
                              children: [
                                Transform.scale(
                                  scale: 1,
                                  child: Checkbox(
                                    value: rackedProvider.selectAll,
                                    onChanged: (bool? value) {
                                      rackedProvider
                                          .toggleSelectAll(value ?? false);
                                    },
                                    activeColor: Colors
                                        .blue, // Customize the active color
                                    checkColor: Colors
                                        .white, // Customize the check mark color
                                    side: const BorderSide(
                                        color: Colors
                                            .blue), // Customize the border color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          4), // Customize the border radius
                                    ),
                                  ),
                                ),
                                const Text('Select All'),
                              ],
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          rackedProvider.selectedProducts.length,
                          (index) => DataRow(
                            selected: rackedProvider.selectedProducts[index],
                            cells: [
                              // Product Image and Name in one cell
                              DataCell(
                                SizedBox(
                                  width: 556,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 10),
                                            SizedBox(
                                              width: 430,
                                              child: Column(
                                                children: [
                                                  // Product 1 Information
                                                  Text(
                                                    'Nemotude Plus (Bio Pesticides verticillium chalamydosporium 1% WP)',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    softWrap:
                                                        true, // Enable text wrapping
                                                    maxLines:
                                                        3, // Adjust max lines if needed
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 4),

                                                  Row(
                                                    children: [
                                                      Text(
                                                        'SKU : k-5560 ',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(width: 150),
                                                      Text(
                                                        'Quality : 10 ',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                            SizedBox(width: 10),
                                            SizedBox(
                                              width: 430,
                                              child: Column(
                                                children: [
                                                  // Product 1 Information
                                                  Text(
                                                    'Motude Plus (Bio Pesticides verticillium chalamydosporium 1% WP)',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    softWrap:
                                                        true, // Enable text wrapping
                                                    maxLines:
                                                        3, // Adjust max lines if needed
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'SKU : k-9560 ',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(width: 150),
                                                      Text(
                                                        'Quality : 04 ',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Deependra Singh',
                                      style: TextStyle(fontSize: 18),
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                    ),
                                    Text(
                                      '8758568384',
                                      style: TextStyle(fontSize: 18),
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),

                              // Shiprocket price (INR)
                              const DataCell(
                                Text(
                                  '12/02/2020',
                                  style: TextStyle(fontSize: 18),
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                              ),
                              const DataCell(
                                Text(
                                  '\$1200',
                                  style: TextStyle(fontSize: 18),
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                              ),

                              DataCell(
                                Text(
                                  'Weight ${index + 1}',
                                  style: const TextStyle(fontSize: 18),
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                              ),

                              // Checkbox for each row
                              DataCell(
                                Transform.scale(
                                  scale: 1,
                                  child: Checkbox(
                                    value:
                                        rackedProvider.selectedProducts[index],
                                    onChanged: (bool? value) {
                                      rackedProvider.toggleProductSelection(
                                          index, value ?? false);
                                    },
                                    activeColor: Colors
                                        .blue, // Customize the active color
                                    checkColor: Colors
                                        .white, // Customize the check mark color
                                    side: const BorderSide(
                                        color: Colors
                                            .blue), // Customize the border color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          4), // Customize the border radius
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
