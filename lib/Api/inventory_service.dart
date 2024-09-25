import 'dart:convert';
import 'package:http/http.dart' as http;

class InventoryService {
  final String baseUrl =
      'https://inventory-management-backend-s37u.onrender.com';

  // Method to create a new inventory
  Future<Map<String, dynamic>> createInventory(
      Map<String, dynamic> data, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/inventory/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body); // Return created inventory data
    } else {
      throw Exception('Failed to create inventory');
    }
  }

  Future<Map<String, dynamic>> getInventory(
      String token, int selectedPage, int jump) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inventory?page=$selectedPage&limit=$jump'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Return the response as a map
    } else {
      throw Exception('Failed to load inventory');
    }
  }

  // Method to get inventory by ID
  Future<Map<String, dynamic>> getInventoryById(String id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inventory/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Return inventory data by ID
    } else {
      throw Exception('Failed to load inventory by ID');
    }
  }

  // Method to update an inventory
  Future<Map<String, dynamic>> updateInventory(
      String id, Map<String, dynamic> data, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/inventory/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Return updated inventory data
    } else {
      throw Exception('Failed to update inventory');
    }
  }

  // Method to delete an inventory
  Future<void> deleteInventory(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/inventory/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete inventory');
    }
  }
}
