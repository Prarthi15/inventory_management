import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final String _baseUrl =
      'https://inventory-management-backend-s37u.onrender.com';
  Future<Map<String, dynamic>> register(String email, String password) async {
    final url = Uri.parse('$_baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        await _saveCredentials(email, password);
        return {'success': true, 'data': json.decode(response.body)};
      } else if (response.statusCode == 400) {
        final errorResponse = json.decode(response.body);
        if (errorResponse['error'] == 'Email already exists') {
          return {
            'success': false,
            'message':
                'This email is already registered. Please use a different email or log in.'
          };
        }
        return {'success': false, 'message': 'Registration failed'};
      } else {
        return {
          'success': false,
          'message':
              'Registration failed with status code: ${response.statusCode}'
        };
      }
    } catch (error) {
      print('An error occurred during registration: $error');
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> registerOtp(
      String email, String otp, String password) async {
    final url = Uri.parse('$_baseUrl/register-otp');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'otp': otp,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': json.decode(response.body)};
      } else {
        print(
            'OTP verification failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {'success': false, 'message': 'OTP verification failed'};
      }
    } catch (error) {
      print('An error occurred during OTP verification: $error');
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('Login Response: ${response.statusCode}');
      print('Login Response Body: ${response.body}');
      print('Response Headers: ${response.headers}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Parsed Response Data: $responseData');

        // Directly extract the token from the response body
        final token = responseData['token'];

        if (token != null && token.isNotEmpty) {
          await _saveToken(token);
          print('Token retrieved and saved: $token');
        } else {
          print('Token not retrieved');
        }

        await _saveCredentials(email, password);
        return {'success': true, 'data': responseData};
      } else if (response.statusCode == 400) {
        final errorResponse = json.decode(response.body);
        return {'success': false, 'message': errorResponse['error']};
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'User does not exist'};
      } else {
        return {
          'success': false,
          'message': 'Login failed with status code: ${response.statusCode}'
        };
      }
    } catch (error) {
      print('An error occurred during login: $error');
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse('$_baseUrl/forgot-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      print('Forgot Password Response: ${response.statusCode}');
      print('Forgot Password Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'OTP sent to email'};
      } else if (response.statusCode == 400) {
        final errorResponse = json.decode(response.body);
        return {'success': false, 'message': errorResponse['error']};
      } else {
        return {
          'success': false,
          'message':
              'Forgot password request failed with status code: ${response.statusCode}'
        };
      }
    } catch (error) {
      print('An error occurred during forgot password request: $error');
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final url = Uri.parse('$_baseUrl/verify-otp');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'otp': otp}),
      );

      print('Verify OTP Response: ${response.statusCode}');
      print('Verify OTP Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'OTP verified successfully'};
      } else {
        final errorResponse = json.decode(response.body);
        return {'success': false, 'message': errorResponse['error']};
      }
    } catch (error) {
      print('An error occurred during OTP verification: $error');
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> resetPassword(
      String email, String newPassword) async {
    final url = Uri.parse('$_baseUrl/reset-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'newPassword': newPassword,
        }),
      );

      print('Reset Password Response: ${response.statusCode}');
      print('Reset Password Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Password reset successfully'};
      } else if (response.statusCode == 400) {
        final errorResponse = json.decode(response.body);
        return {'success': false, 'message': errorResponse['error']};
      } else {
        return {
          'success': false,
          'message':
              'Password reset failed with status code: ${response.statusCode}'
        };
      }
    } catch (error) {
      print('An error occurred during password reset: $error');
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> getAllCategories(
      {int page = 1, int limit = 20}) async {
    final url = Uri.parse('$_baseUrl/category/?page=$page&limit=$limit');

    try {
      final token = await _getToken();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get All Categories Response: ${response.statusCode}');
      print('Get All Categories Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('categories') && data['categories'] is List) {
          return {'success': true, 'data': data['categories']};
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

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<Map<String, dynamic>> createCategory(String id, String name) async {
    final url = Uri.parse('$_baseUrl/category/');

    try {
      final token = await _getToken(); // Retrieve the token
      if (token == null) {
        return {'success': false, 'message': 'No token provided'};
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include token in headers
        },
        body: json.encode({
          'id': id,
          'name': name,
        }),
      );

      print('Create Category Response: ${response.statusCode}');
      print('Create Category Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': json.decode(response.body)};
      } else if (response.statusCode == 400) {
        final errorResponse = json.decode(response.body);
        return {
          'success': false,
          'message': errorResponse['error'] ?? 'Failed to create category'
        };
      } else {
        return {
          'success': false,
          'message':
              'Create category failed with status code: ${response.statusCode}'
        };
      }
    } catch (error, stackTrace) {
      print('An error occurred while creating the category: $error');
      print('Stack trace: $stackTrace');
      return {'success': false, 'message': 'An error occurred: $error'};
    }
  }

  Future<Map<String, dynamic>> getCategoryById(String id) async {
    final url = Uri.parse('$_baseUrl/category/$id');

    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No token found'};
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Category By ID Response: ${response.statusCode}');
      print('Get Category By ID Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        print('Failed to load category. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {'success': false, 'message': 'Failed to load category'};
      }
    } catch (error) {
      print('Error fetching category by ID: $error');
      return {'success': false, 'message': 'Error fetching category by ID'};
    }
  }

  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<Map<String, String?>> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    return {
      'email': email,
      'password': password,
    };
  }

  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('authToken'); // Clear the token
  }
}
