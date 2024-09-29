import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_management/Api/auth_provider.dart';

class LabelApi with ChangeNotifier {
  List<Map<String, dynamic>> _labelInformation = [];
  List<Map<String, dynamic>> _replication = [];
  // bool clean = true;
  final String _baseUrl = 'https://inventory-management-backend-s37u.onrender.com';

  // Get all labels
  List<Map<String, dynamic>> get labelInformation => _labelInformation;

  Future<Map<String, dynamic>> getLabel() async {
    final url = Uri.parse('$_baseUrl/label/');

    try {
      final token = await AuthProvider().getToken();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('data')) {
          _labelInformation = List<Map<String, dynamic>>.from(data["data"]['labels']);
          _replication = List<Map<String, dynamic>>.from(_labelInformation); // Create a copy
          print("Labels fetched: ${_labelInformation.length}, Replication: ${_replication.length}");
          notifyListeners();
          return {'success': true, 'data': []};
        } else {
          print('Unexpected response format: $data');
          return {'success': false, 'message': 'Unexpected response format'};
        }
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch labels with status code: ${response.statusCode}'
        };
      }
    } catch (error, stackTrace) {
      return {'success': false, 'message': 'An error occurred: $error'};
    }
  }

  // Search by label
  Future<Map<String, dynamic>> searchByLabel(String lbl) async {
    final url = Uri.parse('$_baseUrl/label?name=$lbl');
    try {
      final token = await AuthProvider().getToken();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('data')) {
          _labelInformation.clear();
          print("heeelo ${_labelInformation.length}   ${_replication.length}");
          _labelInformation = List<Map<String, dynamic>>.from(data["data"]['labels']);
          notifyListeners();
          return {'success': true, 'data': _labelInformation}; // Return updated labels
        } else {
          print('Unexpected response format: $data');
          return {'success': false, 'message': 'Unexpected response format'};
        }
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch labels with status code: ${response.statusCode}'
        };
      }
    } catch (error, stackTrace) {
      return {'success': false, 'message': 'An error occurred: $error'};
    }
  }

  void filterLable(String query) async {
    if (query.isEmpty) {
      print("prarthin  ###");
      _labelInformation =List<Map<String,dynamic>>.from(_replication);
    } else {
      print("prarthin  ###uunhn");
      _labelInformation = (await searchByLabel(query))["data"];
    }
    notifyListeners();
  }
   void cancel() async {
    
      _labelInformation =List<Map<String,dynamic>>.from(_replication);
   
    notifyListeners();
  }


}
