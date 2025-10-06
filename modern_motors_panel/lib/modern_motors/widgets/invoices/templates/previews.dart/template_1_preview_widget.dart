import 'package:flutter/material.dart';

// ——— Helpers for Template1Preview ———
class MetaRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle regular;
  final TextStyle bold;

  const MetaRow({
    super.key,
    required this.label,
    required this.value,
    required this.regular,
    required this.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(label.padRight(14), style: bold),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: regular)),
        ],
      ),
    );
  }
}

class T1Row {
  final String item;
  final String desc;
  final int qty;
  final double unit;
  final double subtotal;

  const T1Row({
    required this.item,
    required this.desc,
    required this.qty,
    required this.unit,
    required this.subtotal,
  });
}

class TableHeader extends StatelessWidget {
  final TextStyle bold;

  const TableHeader({super.key, required this.bold});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFe0e0e0),
        border: Border.all(color: const Color(0xFFbdbdbd), width: 1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
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
}

class TableRowItem extends StatelessWidget {
  final T1Row row;
  final TextStyle regular;

  const TableRowItem({super.key, required this.row, required this.regular});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFbdbdbd), width: 1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(row.item, style: regular)),
          Expanded(flex: 3, child: Text(row.desc, style: regular)),
          Expanded(flex: 1, child: Text('${row.qty}', style: regular)),
          Expanded(
            flex: 1,
            child: Text(row.unit.toStringAsFixed(2), style: regular),
          ),
          Expanded(
            flex: 1,
            child: Text(row.subtotal.toStringAsFixed(2), style: regular),
          ),
        ],
      ),
    );
  }
}

class AmountRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle regular;
  final TextStyle bold;
  final bool emphasize;

  const AmountRow({
    super.key,
    required this.label,
    required this.value,
    required this.regular,
    required this.bold,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final ls = emphasize ? bold : regular;
    final rs = emphasize ? bold : regular;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: ls)),
          const SizedBox(width: 10),
          Text(value, style: rs),
        ],
      ),
    );
  }
}
