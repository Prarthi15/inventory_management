import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_management/model/combo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComboApi with ChangeNotifier {
  final String baseUrl =
      'https://inventory-management-backend-s37u.onrender.com';

  Future<Combo> createCombo(Combo combo) async {
    final url = Uri.parse('$baseUrl/combo/');

    try {
      final token = await _getToken();
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(combo.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        print(response.body);
        return Combo.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Failed to create combo. Status code: ${response.statusCode}. Response: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to create combo: $e');
    }
  }

  // Get all combos
  Future<List<Combo>> getCombos() async {
    final url = Uri.parse('$baseUrl/combo/');

    try {
      final token = await _getToken();

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        final List<dynamic> comboList = jsonResponse['combos'];

        final combos = comboList.map((combo) => Combo.fromJson(combo)).toList();
        return combos;
      } else {
        throw Exception(
            'Failed to fetch combos. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred while fetching combos: $e');
      throw Exception('Failed to fetch combos: $e');
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(
            'https://inventory-management-backend-s37u.onrender.com/products/'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final productsData = responseData['products'] as List?;

        //print(productsData);
        if (productsData != null) {
          return productsData
              .map((product) =>
                  Product.fromJson(product as Map<String, dynamic>))
              .toList();
        }
        throw Exception('Products key is missing or null in the response');
      }
      throw Exception(
          'Failed to load products. Status Code: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  Future<Product> getProductById(String productId) async {
    try {
      final token = await _getToken();
      //print(token);
      final response = await http.get(
        Uri.parse('$baseUrl/$productId'),
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
