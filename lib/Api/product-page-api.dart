import 'dart:convert';
// import 'dart:js_interop';

import 'package:inventory_management/Api/auth_provider.dart';
import 'package:http/http.dart' as http;

class ProductPageApi {
  final String _baseUrl =
      'https://inventory-management-backend-s37u.onrender.com';
  Future<Map<String, dynamic>> getAllBrandName(
      {int page = 1, int limit = 20, String? name}) async {
    final url = Uri.parse('$_baseUrl/brand/');

    try {
      final token = await AuthProvider().getToken();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // print('Get All brand Response: ${response.statusCode}');
      // print('Get All brand  Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('brands') && data['brands'] is List) {
          print("i am dipu");
          List brand;

          brand = parseJsonToList(response.body.toString(), 'brands');
          // }
          // print("i am dipu us here wiht success");
          return {'success': true, 'data': brand};
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
      print('An error occurred while fetching categories: $error');
      print('Stack trace: $stackTrace');
      return {'success': false, 'message': 'An error occurred: $error'};
    }
  }

  //label url
  Future<Map<String, dynamic>> getLabel(
      {int page = 1, int limit = 20, String? name}) async {
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

      // print('Get All brand Response: ${response.statusCode}');
      // print('Get All brand  Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('product_id') && data['product_id'] is List) {
          // print("i am dipu");
          List label;

          label = parseJsonToList(response.body.toString(), 'product_id');
          // }
          // print("i am dipu us here wiht success");
          return {'success': true, 'data': label};
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
      print('An error occurred while fetching categories: $error');
      print('Stack trace: $stackTrace');
      return {'success': false, 'message': 'An error occurred: $error'};
    }
  }

//technical name
  Future<Map<String, dynamic>> getTechnicalName(
      {int page = 1, int limit = 20, String? name}) async {
    final url = Uri.parse('$_baseUrl/technicalname/');

    try {
      final token = await AuthProvider().getToken();
      print("token is heree $token");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // print('Get All brand Response: ${response.statusCode}');
      // print('Get All brand  Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body).toList();
        if (data.isNotEmpty) {
          // List<Map<String,dynamic>>dup=data.cast(List<Map<String,dynamic>>);
          print("techna e data is here ${data.runtimeType}  ");

          return {
            'success': true,
            'data': List<Map<String, dynamic>>.from(data)
          };
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
      print('An error occurred while fetching categories: $error');
      print('Stack trace: $stackTrace');
      return {'success': false, 'message': 'An error occurred: $error'};
    }
  }

  //boxsize
  Future<Map<String, dynamic>> getBoxSize(
      {int page = 1, int limit = 20, String? name}) async {
    final url = Uri.parse('$_baseUrl/boxsize/');

    try {
      final token = await AuthProvider().getToken();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // print('Get All brand Response: ${response.statusCode}');
      // print('Get All brand  Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // print("jajajjhjhj");
        final data = json.decode(response.body);
        if (data.containsKey('boxsizes') && data['boxsizes'] is List) {
          List<Map<String, dynamic>> boxSize =
              parseJsonToList(response.body.toString(), 'boxsizes');

          return {'success': true, 'data': boxSize};
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
      print('An error occurred while fetching categories: $error');
      print('Stack trace: $stackTrace');
      return {'success': false, 'message': 'An error occurred: $error'};
    }
  }



Future createProduct({
  required String productName,
  required String parentSku,
  required String sku,
  required String ean,
  required String description,
  required String brand,
  required String category,
  required String technicalName,
  required String label,
  required String color,
  required String taxRule,
  required Map<String, dynamic> dimensions,
  required double weight,
  required String boxSize,
  required double mrp,
  required double cost,
  required bool active,
}) async {
  final url = Uri.parse('$_baseUrl/products/');

  try {
    final token = await AuthProvider().getToken();
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "displayName": productName,
        "parentSku": parentSku,
        "sku":"SKU1234",
        "ean": ean,
        "description": description,
        "brand": brand,
        "category": category,
        "technicalName": technicalName,
        "label": label,
        "color": color,
        "tax_rule": taxRule,
        "dimensions": dimensions,
        "weight": weight,
        "boxSize": boxSize,
        "Mrp": mrp,
        "Cost": cost,
        "active": active,
      }),
    );

     
    print("product is created succesfully ${response.body}");
    
  } catch (error, stackTrace) {
    print('An error occurred while fetching categories: $error');
    print('Stack trace: $stackTrace');
    return {'success': false, 'message': 'An error occurred: $error'};
  }
}


  List<Map<String, dynamic>> parseJsonToList(String jsonString, String key) {
    // Decode the JSON string
    // print("heee;loo i am dipu $")
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    // Access the array of objects
    final List<dynamic> categories = jsonData[key];

    // Convert the List<dynamic> to List<Map<String, dynamic>>
    return categories.map((item) => item as Map<String, dynamic>).toList();
  }
}
