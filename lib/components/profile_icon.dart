import 'package:flutter/material.dart';

final List<Color> _list = [
  Colors.cyan.shade100,
  Colors.brown.shade100,
  Colors.purple.shade100,
  Colors.lightGreen.shade100,
  Colors.pink.shade100,
  Colors.amber.shade100,
  Colors.redAccent.shade100,
  Colors.deepOrange.shade300
];

Widget profileIcon(String name, {double radius = 50}) {
  return Container(
    width: radius,
    height: radius,
    decoration: BoxDecoration(
      color: _list[name.codeUnits.reduce((value, element) => value + element) %
          _list.length],
      shape: BoxShape.circle,
    ),
    child: Center(
        child: Text(
      name[0],
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    )),
  );
}
