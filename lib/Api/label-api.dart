import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_management/Api/auth_provider.dart';

class LabelApi with ChangeNotifier{
  List<Map<String,dynamic>>_labelInformation=[];
   final String _baseUrl =
      'https://inventory-management-backend-s37u.onrender.com';
  //get all label
  List<Map<String,dynamic>> get labelInformation=>_labelInformation;
  Future<Map<String,dynamic>> getLabel()async{
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
          _labelInformation=List<Map<String,dynamic>>.from(data["data"]['labels']);
          print("now dta is gecccc  ${_labelInformation.length}");
          notifyListeners();
          return {'success': true, 'data':[]};
        } else {
          print('Unexpected response format: $data');
          return {'success': false, 'message': 'Unexpected response format'};
        }
      } else {
        return {
          'success': false,
          'message':
              'Failed to fetch categories with status code: ${response.statusCode}'
        };
      }
    } catch (error, stackTrace) {
      // print('An error occurred while fetching categories: $error');
      // print('Stack trace: $stackTrace');
      return {'success': false, 'message': 'An error occurred: $error'};
    }
  }
}