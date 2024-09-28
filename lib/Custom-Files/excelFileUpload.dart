import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excel;
import 'package:file_picker/file_picker.dart';
import 'package:inventory_management/Custom-Files/colors.dart';

class ExcelFileUploader extends StatelessWidget {
  final String sheetName;
  final Function(List<Map<String, String>>) onUploadSuccess;
  final Function(String) onError;

  const ExcelFileUploader({
    super.key,
    required this.sheetName,
    required this.onUploadSuccess,
    required this.onError,
  });

  Future<void> _pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

      if (result != null && result.files.single.bytes != null) {
        final Uint8List bytes = result.files.single.bytes!;
        var excelFile = excel.Excel.decodeBytes(bytes);

        if (excelFile.tables.containsKey(sheetName)) {
          List<List<dynamic>> rows = excelFile.tables[sheetName]?.rows ?? [];

          if (rows.isNotEmpty) {
            List<String> headers =
                rows.first.map((cell) => cell?.value.toString() ?? '').toList();

            List<Map<String, String>> tempDataGroups = [];
            for (var row in rows.skip(1)) {
              if (_isRowEmptyOrInvalid(row)) continue;

              Map<String, String> dataMap = {};
              bool hasValidValue = false;

              for (int i = 0; i < headers.length; i++) {
                var cellValue = row.length > i && row[i] != null
                    ? _cleanCellValue(row[i])
                    : 'N/A';

                if (cellValue != 'N/A') {
                  hasValidValue = true;
                }

                dataMap[headers[i]] = cellValue;
              }

              if (hasValidValue) {
                tempDataGroups.add(dataMap);
                print('Uploaded data: $dataMap'); // Log uploaded data
              }
            }

            onUploadSuccess(tempDataGroups);
            _showMessage(context, 'Excel file uploaded successfully!');
            print('------------------------------');
          } else {
            _showMessage(
                context, 'The uploaded sheet is empty. Please check your file.',
                isError: true);
            print('------------------------------');
          }
        } else {
          _showMessage(context,
              'Couldn\'t find "$sheetName" in the uploaded file. Please ensure it exists.',
              isError: true);
          print('------------------------------');
        }
      } else {
        _showMessage(
            context, 'Please upload an Excel file (.xlsx) only. Try again.',
            isError: true);
        print('------------------------------');
      }
    } catch (e) {
      onError('An unexpected error occurred: ${e.toString()}');
      _showMessage(context, 'An unexpected error occurred. Please try again.',
          isError: true);
      print('------------------------------');
    }
  }

  void _showMessage(BuildContext context, String message,
      {bool isError = false}) {
    print(message);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.cardsred : AppColors.primaryGreen,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  bool _isRowEmptyOrInvalid(List<dynamic> row) {
    for (var cell in row) {
      var cellValue = cell?.toString().trim() ?? '';
      if (cellValue.isNotEmpty && cellValue.toLowerCase() != 'n/a') {
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
    return ElevatedButton(
      onPressed: () => _pickFile(context),
      child: const Text('Upload Excel File'),
    );
  }
}
