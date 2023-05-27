import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
   MyTextField({
    super.key,required this.controller, required this.obscureText,
    required this.hintText
  });

  final controller;
  final bool obscureText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
              ),
              fillColor: Colors.grey.shade100,
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500])
          ),
      ),
    );
  }
}