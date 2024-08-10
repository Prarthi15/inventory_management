import 'package:flutter/material.dart';

class TestPurpose extends StatelessWidget {
  const TestPurpose({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure all variables are not null before using them
    return Scaffold(
      appBar: AppBar(title: const Text('Test Purpose')),
      body:const Center(
        child: Text('Welcome to Test Purpose!'),
      ),
    );
  }
}
