import 'package:flutter/material.dart';
import 'package:inventory_management/Api/auth_provider.dart';
import 'package:inventory_management/dashboard.dart';
import 'package:inventory_management/forgot_password.dart';
import 'package:inventory_management/login_page.dart';
import 'package:inventory_management/products.dart';
import 'package:provider/provider.dart';

import 'create_account.dart';

void main() {
  runApp(          ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color.fromRGBO(6, 90, 216, 1),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromRGBO(6, 90, 216, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/createAccount': (context) => const CreateAccountPage(),
        '/forgotPassword': (context) => const ForgotPasswordPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/products': (context) => const Products()
      },
    );
  }
}
