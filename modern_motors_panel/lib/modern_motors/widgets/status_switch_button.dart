import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dynamic_data_table_buttons.dart';

class StatusSwitchWidget extends StatelessWidget {
  final bool isSwitched;
  final String title;
  final Function(bool)? onChanged;

  const StatusSwitchWidget({
    super.key,
    required this.isSwitched,
    this.title = 'Status',
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title.tr()),
        SizedBox(
          height: 2,
          child: Switch(
            trackOutlineColor: WidgetStatePropertyAll(AppTheme.borderColor),
            inactiveTrackColor: AppTheme.backgroundGreyColor,
            value: isSwitched,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

class AddTerms extends StatelessWidget {
  final VoidCallback onAdd;

  const AddTerms({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Add'),
        (context.width * 0.02).dw,
        buildActionButton(
          icon: Icons.add,
          color: const Color(0xFF0AEF0D),
          onTap: onAdd,
          tooltip: 'Add',
        ),
      ],
    );
  }
}
