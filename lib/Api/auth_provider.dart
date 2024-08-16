import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  final String _baseUrl = 'https://inventory-management-backend-s37u.onrender.com';

  bool _isLoading = false;
  String? _errorMessage;
  String? _token;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;

  // Helper method to handle HTTP requests
  Future<void> _postRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    if (kDebugMode) {
      print('Making POST request to: $url');
      print('Request body: $body');
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      ).timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (kDebugMode) {
          print('Response body (decoded): $responseBody');
        }
        if (responseBody['success']) {
          _token = responseBody['token']; // Assuming the token is returned on successful request
          if (kDebugMode) {
            print('Request successful, token: $_token');
          }
        } else {
          _errorMessage = responseBody['message'];
          if (kDebugMode) {
            print('Request failed, message: $_errorMessage');
          }
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      _errorMessage = 'Network error: ${e.message}';
      if (kDebugMode) {
        print('ClientException: ${e.message}');
      }
    } on SocketException catch (e) {
      _errorMessage = 'Socket error: ${e.message}';
      if (kDebugMode) {
        print('SocketException: ${e.message}');
      }
    } catch (error) {
      _errorMessage = 'Error: $error';
      if (kDebugMode) {
        print('General Error: $error');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register
  Future<void> register(String username, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _postRequest('/register', {
        'username': username,
        'email': email,
        'password': password,
      });
    } catch (error) {
      _errorMessage = error.toString();
      if (kDebugMode) {
        print('Error during registration: $_errorMessage');
      }
    } finally {
      notifyListeners();
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _postRequest('/login', {
        'email': email,
        'password': password,
      });
    } catch (error) {
      _errorMessage = error.toString();
      if (kDebugMode) {
        print('Error during login: $_errorMessage');
      }
    } finally {
      notifyListeners();
    }
  }
}
