import 'package:flutter/cupertino.dart';

Widget twoCol(String l, String r) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(l)),
        Text(r, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
