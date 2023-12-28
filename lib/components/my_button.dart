import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function() onTap;
  final String text;
  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor),
        onPressed: onTap,
        child: Text(text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )));
  }
}
