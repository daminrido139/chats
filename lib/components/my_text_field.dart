import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obsecureText;
  final String hintText;
  const MyTextField({
    super.key,
    required this.controller,
    required this.obsecureText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obsecureText,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
