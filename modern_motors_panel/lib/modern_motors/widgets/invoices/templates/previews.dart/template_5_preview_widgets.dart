import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';

class KV extends StatelessWidget {
  final String k, v;
  final TextStyle regular, bold;
  final bool isTotal;

  const KV({
    super.key,
    required this.k,
    required this.v,
    required this.regular,
    this.isTotal = false,
    required this.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          k,
          style: isTotal
              ? regular.copyWith(color: AppTheme.primaryColor)
              : regular,
        ),
        Text(v, style: isTotal ? bold : regular),
      ],
    );
  }
}

// Table row model for T5
class T5ROW {
  final String item;
  final String desc;
  final int qty;
  final double unit;
  final double subtotal;

  const T5ROW({
    required this.item,
    required this.desc,
    required this.qty,
    required this.unit,
    required this.subtotal,
  });
}

class ItemsTableT5 extends StatelessWidget {
  final List<T5ROW> rows;
  final TextStyle regular;
  final TextStyle bold;

  const ItemsTableT5({
    super.key,
    required this.rows,
    required this.regular,
    required this.bold,
  });

  @override
  Widget build(BuildContext context) {
    // Column widths: Items(1), Description(3), Qty(1), Unit Price(1), Subtotal(1)
    Widget header() {
      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE0E0E0), // grey300 like PDF
          // Note: PDF had no border here; keeping consistent
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Text('Items', style: bold.copyWith(fontSize: 12)),
            ),
            Expanded(
              flex: 3,
              child: Text('Description', style: bold.copyWith(fontSize: 12)),
            ),
            Expanded(
              flex: 1,
              child: Text('Qty', style: bold.copyWith(fontSize: 12)),
            ),
            Expanded(
              flex: 1,
              child: Text('Unit Price', style: bold.copyWith(fontSize: 12)),
            ),
            Expanded(
              flex: 1,
              child: Text('Subtotal', style: bold.copyWith(fontSize: 12)),
            ),
          ],
        ),
      );
    }

    Widget dataRow(T5ROW r) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: Text(r.item, style: regular)),
                Expanded(flex: 3, child: Text(r.desc, style: regular)),
                Expanded(flex: 1, child: Text('${r.qty}', style: regular)),
                Expanded(
                  flex: 1,
                  child: Text(r.unit.toStringAsFixed(2), style: regular),
                ),
                Expanded(
                  flex: 1,
                  child: Text(r.subtotal.toStringAsFixed(2), style: regular),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.black, thickness: 1, height: 16),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [header(), ...rows.map(dataRow)],
    );
  }
}
