// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:excel/excel.dart' as excel;
import 'package:file_picker/file_picker.dart';

class ProductDataDisplay extends StatefulWidget {
  const ProductDataDisplay({super.key});

  @override
  _ProductDataDisplayState createState() => _ProductDataDisplayState();
}

class _ProductDataDisplayState extends State<ProductDataDisplay> {
  List<Map<String, String>> dataGroups = [];

  final List<String> headers = [
    'displayName',
    'parentSku',
    'sku',
    'weight',
    'cost',
    'mrp',
    'ean',
    'brand',
    'tax_rule',
    'description',
    'technicalName',
    'label',
    'boxSize',
    'category',
    'dimensions',
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

      if (result != null && result.files.single.bytes != null) {
        final Uint8List bytes = result.files.single.bytes!;

        var excelFile = excel.Excel.decodeBytes(bytes);

        if (excelFile.tables.containsKey('Sheet1')) {
          List<List<dynamic>> rows = excelFile.tables['Sheet1']?.rows ?? [];

          if (rows.isNotEmpty) {
            List<Map<String, String>> tempDataGroups = [];
            for (var row in rows.skip(1)) {
              if (_isRowEmpty(row)) continue;

              Map<String, String> dataMap = {};
              for (int i = 0; i < headers.length; i++) {
                var cellValue = row.length > i && row[i] != null
                    ? _cleanCellValue(row[i])
                    : 'N/A';
                dataMap[headers[i]] = cellValue;
              }
              tempDataGroups.add(dataMap);
            }

            setState(() {
              dataGroups = tempDataGroups;
            });
          } else {
            print('Sheet1 is empty.');
          }
        } else {
          print('Sheet1 not found in the Excel file.');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('Error loading Excel file: $e');
    }
  }

  bool _isRowEmpty(List<dynamic> row) {
    for (var cell in row) {
      if (cell != null && cell.toString().trim().isNotEmpty) {
        return false;
      }
    }
    return true;
  }

  String _cleanCellValue(dynamic cell) {
    if (cell is String) {
      return cell;
    } else if (cell is Map) {
      return cell.toString();
    } else if (cell.toString().contains('Data(')) {
      return cell.toString().replaceAllMapped(
            RegExp(r'Data\((.*?),.*\)'),
            (match) => match.group(1) ?? '',
          );
    }
    return cell.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Upload Excel File'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: dataGroups.isEmpty
                  ? const Center(child: Text('No data available.'))
                  : ListView.builder(
                      itemCount: dataGroups.length,
                      itemBuilder: (context, index) {
                        Map<String, String> dataMap = dataGroups[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
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
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: headers.map((header) {
                                String value = dataMap[header] ?? 'N/A';
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '$header:',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          value,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
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
}
