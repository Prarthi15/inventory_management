import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldInput extends StatefulWidget {

  final TextEditingController textEditingController;

  final String hintText;
  final TextInputType textInputType;
  final maxlines;
  final ispass;

  const TextFieldInput({
    Key? key,
    required this.textEditingController,

    required this.hintText,
    required this.textInputType, this.maxlines=1, this.ispass=false,

      }) : super(key: key);

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {

  @override
  Widget build(BuildContext context) {


    return TextFormField(

      maxLines: widget.maxlines,
      decoration: InputDecoration(
        fillColor: Colors.grey[200],
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (text)=>setState(() {
        widget.textEditingController.text =text;
      }),
      obscureText: widget.ispass ? true : false,
    );
  }
}