// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  Widget child;
   ResponsiveLayout({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:const BoxConstraints(
        maxWidth:700,
      ),
      child:child,
      );
  }
}