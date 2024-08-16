import 'package:flutter/material.dart';

class AppColors {
  static const Color googleColor = Color.fromRGBO(219, 68, 55, 1);
  static const Color facebookColor = Color.fromRGBO(24, 119, 242, 1);
  static const Color linkedinColor = Color.fromRGBO(0, 119, 181, 1);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color primaryBlue = Color.fromRGBO(6, 90, 216, 1);
  static const Color primaryBlueLight = Color.fromRGBO(6, 90, 216, 0.7);
  static const Color primaryGreen = Color.fromRGBO(37, 128, 69, 1);
  static const Color lightGrey = Color.fromRGBO(240, 240, 240, 1);
  static const Color greyBackground = Color.fromRGBO(238, 238, 238, 1);
  static const Color greyText = Color.fromRGBO(135, 135, 135, 1);
  static const Color drawerBackground = Colors.grey;
  static const Color cardsred = Colors.redAccent;
  static const Color cardsgreen = Colors.greenAccent;
  //getWidth
  double getWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
  }
  // static const double MediaQuery.of(context).
  TextStyle get headerStyle{
    return const TextStyle(
      fontWeight:FontWeight.w600,
    );
  }
}
