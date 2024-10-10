
import 'package:flutter/material.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:provider/provider.dart';
import '../provider/inventory_provider.dart';

class CustomDataTable extends StatelessWidget {
  final List<String> columnNames;
  final List<Map<String, dynamic>> rowsData;

  const CustomDataTable({
    Key? key,
    required this.columnNames,
    required this.rowsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DataColumn> columns = columnNames.map((name) {
      return DataColumn(
        label: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
      );
    }).toList();

    // Create DataRow list from rowsData
    List<DataRow> rows = rowsData.map((data) {
      return DataRow(
        cells: columnNames.map((columnName) {
          var cellData = data[columnName];
          if (cellData is Widget) {

            return DataCell(cellData);
          } else {

            return DataCell(Text(cellData?.toString() ?? 'N/A'));
          }
        }).toList(),
      );
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith(
            (states) => AppColors.green.withOpacity(0.2),
          ),
          columns: columns,
          rows: rows,
        ),
      ),
    );
  }
}

// Inventory Data Table
class InventoryDataTable extends StatefulWidget {
  final List<String> columnNames;
  final List<Map<String, dynamic>> rowsData;
  final ScrollController scrollController;
  // final String inventoryId;

  const InventoryDataTable({
    Key? key,
    required this.columnNames,
    required this.rowsData,
    required this.scrollController,
   // required this.inventoryId,
  }) : super(key: key);

  @override
  State<InventoryDataTable> createState() => _InventoryDataTableState();
}

class _InventoryDataTableState extends State<InventoryDataTable> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: widget.scrollController,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith(
                (states) => AppColors.green.withOpacity(0.2),
          ),
          columns: widget.columnNames.map((name) {
            if (name == 'ACTIONS') {
              return DataColumn(
                label: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center, // Center vertically
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print('Save All clicked');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Save All'),
                    ),
                  ],
                ),
              );
            } else {
              return DataColumn(
                label: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              );
            }
          }).toList(),
          rows: widget.rowsData.map((data) {
            return DataRow(
              cells: widget.columnNames.map((columnName) {
                var cellData = data[columnName];

                if (columnName == 'IMAGE') {
                  return DataCell(
                    Image.network(
                      cellData,
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 40,
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  );
                } else if (columnName == 'ACTIONS') {
                  return DataCell(
                    ElevatedButton(
                      onPressed: () {
                        print('Save clicked for: ${data['PRODUCT NAME']}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  );
                } else if (columnName == 'QUANTITY') {
                  return DataCell(
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(cellData?.toString() ?? '0',
                                  style: const TextStyle(fontSize: 16)),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 16),
                                onPressed: () {
                                  _showUpdateQuantityDialog(context, data);
                                },
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              final inventoryId = data['inventoryId'];
                              if (inventoryId !=
                                  null) { // Check if inventoryId exists

                                _showDetailsDialog(context, data);
                                //_showDetailsDialog(context, inventoryId);

                              } else {

                                print(
                                    'Inventory ID not found for the selected item.');
                              }

                            },
                            child: const Text(
                              'View Details',
                              style: TextStyle(color: AppColors.primaryGreen),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (cellData is Widget) {
                  return DataCell(cellData);
                } else {
                  return DataCell(Text(cellData?.toString() ?? 'N/A'));
                }
              }).toList(),
            );
          }).toList(),
          headingRowHeight: 80,
          dataRowHeight: 100,
          columnSpacing: 55,
          horizontalMargin: 16,
          dataTextStyle: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  void _showUpdateQuantityDialog(BuildContext context,
      Map<String, dynamic> data) {
    TextEditingController quantityController = TextEditingController();
    TextEditingController reasonController = TextEditingController();

    quantityController.text = data['QUANTITY'].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Quantity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: 'New Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: 'Reason',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: 3,
              ),
            ],
          ),
          actions: [

            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                  'Cancel', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 5,),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () async {
                String newQuantity = quantityController.text;
                String reason = reasonController.text;

                int? parsedQuantity = int.tryParse(newQuantity);
                if (parsedQuantity == null) {
                  print('Invalid quantity entered');
                  return;
                }

                final inventoryProvider = Provider.of<InventoryProvider>(
                    context, listen: false);

                await inventoryProvider.updateInventoryQuantity(
                  data['inventoryId'],
                  parsedQuantity, // Parsednteger quantity
                  '66fceb5163c6d5c106cfa809', // Warehouse ID (hardcoded)
                  reason, // Reason for the update
                );

                inventoryProvider
                    .notifyListeners(); // This will rebuild the relevant widgets

                data['QUANTITY'] = parsedQuantity;

                print(
                    'Updated quantity for ${data['PRODUCT NAME']}: $newQuantity');
                if (reason.isNotEmpty) {
                  print('Reason: $reason');
                }

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text(
                  'Update', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showDetailsDialog(BuildContext context, Map<String, dynamic> data)async {


    List<dynamic> inventoryLogs = data['inventoryLogs'] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Container(
                height: 30,
                width: 100,
                child: Text(
                  'Updated Details ${data['PRODUCT NAME']}',
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Container(
            width:500, // Set width to maximum available
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4, // Max height of 40% of screen
            ),
            child: SingleChildScrollView( // Make the content scrollable
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inventory Logs:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Check if there are any logs, and render them in a Column
                  if (inventoryLogs.isNotEmpty)
                    Column(
                      children: inventoryLogs.map((log) {
                        // Determine icon and color based on changeType
                        IconData icon;
                        Color iconColor;
                        double size = 30;

                        if (log['changeType'] == 'Addition') {
                          icon = Icons.add; // Plus icon
                          iconColor = Colors.green; // Green color
                          //size=30;
                        } else if (log['changeType'] == 'Subtraction') {
                          icon = Icons.remove; // Minus icon
                          iconColor = Colors.red; // Red color
                        } else {
                          icon = Icons.info; // Default icon
                          iconColor = Colors.grey; // Default color
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          shadowColor: Colors.blueAccent,
                          surfaceTintColor: Colors.blueAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Expanded text section
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      LabelValueText(
                                        label: 'Quantity Changed : ',
                                        value: '${log['quantityChanged']}',
                                        fontSize: 17.0, // Adjust font size as needed
                                      ),
                                      LabelValueText(
                                        label: 'Previous Total : ',
                                        value: '${log['previousTotal']}',
                                        fontSize: 17.0,
                                      ),
                                      LabelValueText(
                                        label: 'New Total : ',
                                        value: '${log['newTotal']}',
                                        fontSize: 17.0,
                                      ),
                                      LabelValueText(
                                        label: 'Updated By : ',
                                        value: '${log['updatedBy']}',
                                        fontSize: 17.0,
                                      ),
                                      LabelValueText(
                                        label: 'Source : ',
                                        value: '${log['source']}',
                                        fontSize: 17.0,
                                      ),
                                      LabelValueText(
                                        label: 'Timestamp : ',
                                        value: '${log['timestamp']}',
                                        fontSize: 17.0,
                                      ),
                                      if (log['additionalInfo'] != null && log['additionalInfo']['reason'] != null)
                                        LabelValueText(
                                          label: 'Reason : ',
                                          value: '${log['additionalInfo']['reason']}',
                                          fontSize: 17.0,
                                        ),

                                      if (log['affectedWarehouse'] != null)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10), // Add some spacing
                                            Text(
                                              'Affected Warehouse:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            LabelValueText(
                                              label: 'Warehouse ID : ',
                                              value: '${log['affectedWarehouse']['warehouseId']}',
                                              fontSize: 17.0,
                                            ),
                                            LabelValueText(
                                              label: 'Previous Quantity : ',
                                              value: '${log['affectedWarehouse']['previousQuantity']}',
                                              fontSize: 17.0,
                                            ),
                                            LabelValueText(
                                              label: 'Updated Quantity : ',
                                              value: '${log['affectedWarehouse']['updatedQuantity']}',
                                              fontSize: 17.0,
                                            ),
                                          ],
                                        ),

                                    ],
                                  ),

                                ),
                                Center(child:

                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: iconColor.withOpacity(0.3), // Light background color for the icon
                                  ),
                                  padding: const EdgeInsets.all(8), // Padding to create space around the icon
                                  child: Icon(
                                    icon,
                                    color: iconColor,
                                    size: size,
                                  ),
                                ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )

                  else
                    const Center(
                      child: Text('No inventory logs available'),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Close',style:TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
  // void _showDetailsDialog(BuildContext context, String inventoryId) async {
  //   final inventoryProvider = Provider.of<InventoryProvider>(context,listen: false);
  //
  //   await inventoryProvider.fetchInventoryById(inventoryId);
  //   inventoryProvider
  //       .notifyListeners();
  //
  //   final item = inventoryProvider.inventory.firstWhere(
  //         (element) => element['inventoryId'] == inventoryId,
  //     //orElse: () => null,
  //   );
  //
  //   if (item == null) {
  //     print('Inventory item not found');
  //     return;  // Exit if no item found
  //   }
  //
  //   // Extract and cast inventory logs
  //   List<dynamic> inventoryLogs = [];
  //   if (item['inventoryLogs'] is List) {
  //     inventoryLogs = item['inventoryLogs'] as List<dynamic>;  // Safe cast
  //   }
  //
  //
  //   // Display data in dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Column(
  //           children: [
  //             Container(
  //               height: 30,
  //               width: 100,
  //               child: Text(
  //                 'Updated Details ${item['PRODUCT NAME'] ?? 'Unknown Product'}',
  //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           ],
  //         ),
  //         content: Container(
  //           width: 500,  // Set width to maximum available
  //           constraints: BoxConstraints(
  //             maxHeight: MediaQuery.of(context).size.height * 0.4,  // Max height of 40% of screen
  //           ),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'Inventory Logs:',
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 16,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //
  //                 // Check if there are any logs and render them
  //                 if (inventoryLogs.isNotEmpty)
  //                   Column(
  //                     children: inventoryLogs.map((log) {
  //                       // Handle log display here
  //                       IconData icon;
  //                       Color iconColor;
  //                       double size = 30;
  //
  //                       if (log['changeType'] == 'Addition') {
  //                         icon = Icons.add;
  //                         iconColor = Colors.green;
  //                       } else if (log['changeType'] == 'Subtraction') {
  //                         icon = Icons.remove;
  //                         iconColor = Colors.red;
  //                       } else {
  //                         icon = Icons.info;
  //                         iconColor = Colors.grey;
  //                       }
  //
  //                       return Card(
  //                         margin: const EdgeInsets.symmetric(vertical: 8),
  //                         elevation: 2,
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Row(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Expanded(
  //                                 child: Column(
  //                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                   children: [
  //                                     LabelValueText(
  //                                       label: 'Quantity Changed: ',
  //                                       value: '${log['quantityChanged']}',
  //                                     ),
  //                                     // Additional fields
  //                                   ],
  //                                 ),
  //                               ),
  //                               Icon(icon, color: iconColor, size: size),
  //                             ],
  //                           ),
  //                         ),
  //                       );
  //                     }).toList(),
  //                   )
  //                 else
  //                   const Center(child: Text('No inventory logs available')),
  //               ],
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Close', style: TextStyle(color: Colors.white)),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


}

class LabelValueText extends StatelessWidget {
  final String label;
  final String value;
  final double fontSize;

  const LabelValueText({
    Key? key,
    required this.label,
    required this.value,
    this.fontSize = 20.0, // Default font size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$label ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: Colors.black, // Customize color as needed
        ),
        children: <TextSpan>[
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: fontSize,
              color: Colors.black, // Customize color as needed
            ),
          ),
        ],
      ),
    );
  }
}