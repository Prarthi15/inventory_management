import 'package:flutter/material.dart';
import 'package:inventory_management/Custom-Files/colors.dart';

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
    // Create DataColumn list from column names
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
            // If the cell data is a widget, return it as a DataCell
            return DataCell(cellData);
          } else {
            // Otherwise, treat it as a string and return it in a Text widget
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
class InventoryDataTable extends StatelessWidget {
  final List<String> columnNames;
  final List<Map<String, dynamic>> rowsData;
  final ScrollController scrollController;

  const InventoryDataTable({
    Key? key,
    required this.columnNames,
    required this.rowsData,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith(
            (states) => AppColors.green.withOpacity(0.2),
          ),
          columns: columnNames.map((name) {
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
          rows: rowsData.map((data) {
            return DataRow(
              cells: columnNames.map((columnName) {
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
                              _showDetailsDialog(context, data);
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

  void _showUpdateQuantityDialog(
      BuildContext context, Map<String, dynamic> data) {
    TextEditingController quantityController = TextEditingController();
    TextEditingController reasonController = TextEditingController();

    // Pre-fill the quantity field
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
              const SizedBox(height: 16.0), // Add space between the two fields
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: 'Reason',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.multiline, // Allow multiple lines of input
                minLines: 2, // Minimum 2 lines
                maxLines: 3, // Maximum 3 lines
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Print the updated quantity and reason (if provided)
                print(
                    'Updated quantity for ${data['PRODUCT NAME']}: ${quantityController.text}');
                if (reasonController.text.isNotEmpty) {
                  print('Reason: ${reasonController.text}');
                }
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }


  // void _showDetailsDialog(BuildContext context, Map<String, dynamic> data) {
  //   List<dynamic> inventoryLogs = data['inventoryLogs'] ?? [];
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Details for ${data['PRODUCT NAME']}'),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // Scrollable List for Inventory Logs
  //               Container(
  //                 height: 200,  // Define the height for the scrollable area
  //                 child: SingleChildScrollView(
  //                   child: ListView.builder(
  //                     shrinkWrap: true,
  //                     itemCount: inventoryLogs.length,
  //                     itemBuilder: (context, index) {
  //                       var log = inventoryLogs[index];
  //                       return Card(
  //                         margin: const EdgeInsets.symmetric(vertical: 8),
  //                         elevation: 2,
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text('Action: ${log['actionType']}', style: const TextStyle(fontWeight: FontWeight.bold)),
  //                               Text('Quantity Changed: ${log['quantityChanged']}'),
  //                               Text('Previous Total: ${log['previousTotal']}'),
  //                               Text('New Total: ${log['newTotal']}'),
  //                               Text('Updated By: ${log['updatedBy']}'),
  //                               Text('Source: ${log['source']}'),
  //                               Text('Timestamp: ${log['timestamp']}'),
  //                             ],
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void _showDetailsDialog(BuildContext context, Map<String, dynamic> data) {
    List<dynamic> inventoryLogs = data['inventoryLogs'] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Container(
                  height:30,
                  width:200,
                  child: Text('Details for ${data['PRODUCT NAME']}',
                    style: TextStyle(fontSize:20),

                  ),),
            ],
          ),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4, // Max height 60% of screen
              ),
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
                        return Row(
                          children: [
                            // Card containing log details
                            Expanded(
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Action: ${log['actionType']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('Quantity Changed: ${log['quantityChanged']}'),
                                      Text('Previous Total: ${log['previousTotal']}'),
                                      Text('New Total: ${log['newTotal']}'),
                                      Text('Updated By: ${log['updatedBy']}'),
                                      Text('Source: ${log['source']}'),
                                      Text('Timestamp: ${log['timestamp']}'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // "+" and "-" Icon Buttons to the right of the card
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    // TODO: Add functionality here
                                  },
                                ),
                                // IconButton(
                                //   icon: const Icon(Icons.remove),
                                //   onPressed: () {
                                //     // TODO: Remove functionality here
                                //   },
                                // ),
                              ],
                            ),
                          ],
                        );
                      }).toList(), // Convert logs to widgets
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
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

}
