import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  final String _baseUrl =
      'https://inventory-management-backend-s37u.onrender.com';
  String? token;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        token = responseData['token'];
        _errorMessage = null;
      } else {
        _errorMessage = json.decode(response.body)['message'] ?? 'Login failed';
      }
    } catch (error) {
      _errorMessage = 'Failed to login: $error';
      token = null;
    }
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    final url = Uri.parse('$_baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        print('Registration successful');
      } else {
        print('Registration failed: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to register: $error');
    }
  }

  Future<void> registerOtp(String email, String otp) async {
    final url = Uri.parse('$_baseUrl/register-otp');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        print('OTP verification successful');
      } else {
        print('OTP verification failed: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to verify OTP: $error');
    }
  }

  Future<void> forgotPassword(String email) async {
    final url = Uri.parse('$_baseUrl/forgot-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        print('Password reset email sent');
      } else {
        print('Password reset failed: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to send password reset email: $error');
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    final url = Uri.parse('$_baseUrl/verify-otp');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        print('OTP verification successful');
      } else {
        print('OTP verification failed: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to verify OTP: $error');
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    final url = Uri.parse('$_baseUrl/reset-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'newPassword': newPassword}),
      );

      if (response.statusCode == 200) {
        print('Password reset successful');
      } else {
        print('Password reset failed: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to reset password: $error');
    }
  }
}
