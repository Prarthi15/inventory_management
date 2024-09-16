import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_management/model/combo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComboApi with ChangeNotifier {
  final String baseUrl =
      'https://inventory-management-backend-s37u.onrender.com';

  Future<void> createCombo(
      Combo combo, List<Uint8List>? images, List<String> imageNames) async {
    try {
      // Get the token using the token retrieval method
      final token = await _getToken();
      if (token == null) {
        throw Exception("Authentication token is missing.");
      }

      var uri = Uri.parse('$baseUrl/combo');
      var request = http.MultipartRequest('POST', uri);

      // Log the URL and method
      debugPrint('Request URL: $uri');
      debugPrint('Request Method: POST');

      // Add authentication token in the header
      request.headers['Authorization'] = 'Bearer $token';

      // Add combo fields as text
      request.fields['name'] = combo.name;
      request.fields['mrp'] = combo.mrp;
      request.fields['cost'] = combo.cost;
      request.fields['comboSku'] = combo.comboSku;
      request.fields['products'] = jsonEncode(combo.products);

      debugPrint('Request Fields:');
      debugPrint('name: ${combo.name}');
      debugPrint('mrp: ${combo.mrp}');
      debugPrint('cost: ${combo.cost}');
      debugPrint('comboSku: ${combo.comboSku}');
      debugPrint('products: ${jsonEncode(combo.products)}');

      // Attach selected images to the request
      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'images', // Ensure this matches your server's expected field name
              images[i],
              filename: imageNames[i],
            ),
          );
          debugPrint('Added image: ${imageNames[i]}');
        }
      }

      // Send the request
      var response = await request.send();
      debugPrint('Response status: ${response.statusCode}');

      // Handle response
      if (response.statusCode == 200) {
        print('Combo created successfully');
        // Optionally, you can decode the response if your server returns any data
        var responseData = await http.Response.fromStream(response);
        print('Response Data: ${responseData.body}');
      } else {
        // Handle the error based on status code
        print('Failed to create combo: ${response.statusCode}');
        throw Exception('Failed to create combo: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions and provide feedback
      print('Error occurred: $e');
      throw Exception('Error creating combo: $e');
    }
  }

  // Get all combos
  Future<List<Map<String, dynamic>>> getCombos() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/combo/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        //print('Decoded response: $decodedResponse');

        // Handle different response structures here
        if (decodedResponse is List) {
          // If it's a list, return it directly
          print("list");
          return List<Map<String, dynamic>>.from(decodedResponse);
        } else if (decodedResponse is Map) {
          // If it's a map, check if it contains the list under a specific key
          print("map");
          final comboList = decodedResponse['combos'] as List<dynamic>? ?? [];
          return List<Map<String, dynamic>>.from(comboList);
        } else {
          throw Exception('Unexpected JSON format');
        }
      } else {
        throw Exception('Failed to load combos: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching combos: $e');
      throw Exception('Error fetching combos: $e');
    }
  }

  Future<List<dynamic>> getAllProducts() async {
    try {
      final token = await _getToken(); // Fetch token dynamically

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/products/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      //print('get products response: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return the list of products
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<Product> getProductById(String productId) async {
    try {
      final token = await _getToken();
      //print(token);
      final response = await http.get(
        Uri.parse('$baseUrl/products/search/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      //print(response.body);
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }
}
