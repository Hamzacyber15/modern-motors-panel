import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';

enum CustomerType { individual, business }

class RadioButtonWidget extends StatelessWidget {
  final CustomerType selectedType;
  final ValueChanged<CustomerType?> onChanged;

  const RadioButtonWidget({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Radio<CustomerType>(
              value: CustomerType.individual,
              groupValue: selectedType,
              onChanged: onChanged,
            ),
            const Text("Individual"),
          ],
        ),
        10.w,
        Row(
          children: [
            Radio<CustomerType>(
              value: CustomerType.business,
              groupValue: selectedType,
              onChanged: onChanged,
            ),
            const Text("Business"),
          ],
        ),
      ],
    );
  }
}

// class RadioButtonWidget extends StatefulWidget {
//   const RadioButtonWidget({super.key});
//
//   @override
//   State<RadioButtonWidget> createState() => _RadioButtonWidgetState();
// }
//
// class _RadioButtonWidgetState extends State<RadioButtonWidget> {
//   AccountType? _selectedType = AccountType.individual;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Individual Option
//         Row(
//           children: [
//             Radio<AccountType>(
//               value: AccountType.individual,
//               groupValue: _selectedType,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedType = value;
//                 });
//               },
//             ),
//             const Text("Individual"),
//           ],
//         ),
//
//         // Business Option
//         Row(
//           children: [
//             Radio<AccountType>(
//               value: AccountType.business,
//               groupValue: _selectedType,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedType = value;
//                 });
//               },
//             ),
//             const Text("Business"),
//           ],
//         ),
//       ],
//     );
//   }
// }
