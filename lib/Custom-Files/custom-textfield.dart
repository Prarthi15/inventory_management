import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final int maxLines;
  final double height;
  final double width;
  final IconData? icon;
  final String? unit;
  final String? prefix;
  // final IconData? icon;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  // Constructor with default values
  CustomTextField({
    this.maxLines = 1,
    this.height = 51,
    this.width = 550,
    this.icon,
    this.unit,
    this.prefix,
    this.keyboardType = TextInputType.text,
    required this.controller,
    this.validator,
  });

  // Method to build the TextFormField
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0.0, top: 0),
        child: TextFormField(
          cursorWidth: 2.0,
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: icon != null && prefix == null
                ? Icon(icon)
                : prefix != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(prefix!),
                      )
                    : null,
            suffix: unit != null ? Text(unit!) : const Text(''),
            errorStyle:const TextStyle(height: 0.1),
            fillColor:Colors.blue.shade50,
            filled:true,
            border:OutlineInputBorder(
              borderRadius:BorderRadius.circular(10),
              borderSide:BorderSide.none,
             
            )
            
            
            
          ),
          validator: validator,
        ),
      ),
    );
  }
}