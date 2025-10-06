import 'package:flutter/material.dart';

class KeyValueRow extends StatelessWidget {
  final String k;
  final String v;
  final bool emphasize;
  final TextStyle regular;
  final TextStyle bold;
  const KeyValueRow({
    super.key,
    required this.k,
    required this.v,
    required this.regular,
    required this.bold,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final kStyle = emphasize ? bold : regular;
    final vStyle = emphasize ? bold : regular;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(k, style: kStyle)),
        const SizedBox(width: 8),
        Text(v, style: vStyle),
      ],
    );
  }
}

Widget fancyTightDivider1111() {
  return Column(
    children: [
      Container(height: 0.5, color: Colors.black),
      SizedBox(height: 1.4),
      Container(height: 1.5, color: Colors.black),
      SizedBox(height: 1.4),
      Container(height: 0.5, color: Colors.black),
    ],
  );
}
