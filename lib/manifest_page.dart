import 'package:flutter/material.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:inventory_management/provider/manifest_provider.dart';
import 'package:provider/provider.dart';

class ManifestPage extends StatefulWidget {
  const ManifestPage({super.key});

  @override
  _ManifestPageState createState() => _ManifestPageState();
}

class _ManifestPageState extends State<ManifestPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ManifestProvider>(
      builder: (context, manifestProvider, child) {
        return Scaffold(
          body: Column(
            children: [
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
                        columnSpacing: MediaQuery.of(context).size.width * 0.2,
                        columns: const [
                          DataColumn(
                            label: Text(
                              'PRODUCTS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'DELIVERY PARTNER SIGNATURE',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          manifestProvider.selectedProducts.length,
                          (index) => DataRow(
                            selected: manifestProvider.selectedProducts[index],
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
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 130,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 24,
                                    ),
                                    Icon(
                                      Icons.image,
                                      size: 130,
                                      color: Colors.grey,
                                    ),
                                  ],
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
