import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_management/model/orders_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersApi {
  final String _baseUrl =
      'https://inventory-management-backend-s37u.onrender.com';

  // Fetch orders from API
  Future<List<Order>> getOrders({int page = 1, int limit = 20}) async {
    // Retrieve the token from shared preferences
    final token = await _getToken();

    // Check if the token is valid
    if (token == null || token.isEmpty) {
      throw Exception('Authorization token is missing or invalid.');
    }

    // Set up the headers for the request
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      // Make the GET request
      final response = await http.get(
          Uri.parse('$_baseUrl/orders?page=$page&limit=$limit'),
          headers: headers);

      // Print the received response for debugging
      //print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        // Check if the response has an "orders" key
        if (jsonBody is Map<String, dynamic> && jsonBody['orders'] != null) {
          List<dynamic> ordersList = jsonBody['orders'];
          return ordersList.map((data) => Order.fromJson(data)).toList();
        } else {
          throw Exception('Unexpected JSON format: $jsonBody');
        }
      } else {
        throw Exception(
            'Failed to load orders: ${response.statusCode} ${response.body}');
      }
    } catch (error) {
      print('Error during HTTP request: $error');
      throw Exception('An error occurred while fetching orders: $error');
    }
  }

  // Fetch a specific order by its order_id
  Future<Order?> getOrderById(String orderId) async {
    final String? token = await _getToken(); // Retrieve the token

    if (token == null) {
      throw Exception('No auth token found');
    }

    final url =
        'https://inventory-management-backend-s37u.onrender.com/orders?order_id=$orderId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Add the token to the headers
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final Order order = Order.fromJson(jsonData);
        return order;
      } else {
        throw Exception('Failed to load order: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching order by ID: $error');
      return null;
    }
  }

  // Method to get the token from shared preferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }
}
