import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';

class NewCustomDropDown extends StatefulWidget {
  final String hintText;
  final String? value;
  final Map<String, String> items;
  final ValueChanged<String?> onChanged;

  const NewCustomDropDown({
    super.key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  State<NewCustomDropDown> createState() => _NewCustomDropDownState();
}

class _NewCustomDropDownState extends State<NewCustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(left: 8, bottom: 4)),
        DropdownButtonFormField<String>(
          isExpanded: true,
          isDense: true,
          icon: SizedBox.shrink(),
          value: widget.value,
          style: Theme.of(context).textTheme.bodyMedium,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            labelStyle: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontSize: 12),
            filled: true,
            fillColor: AppTheme.whiteColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(width: 0.8, color: AppTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(width: 0.8, color: AppTheme.primaryColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(width: 0.8, color: AppTheme.borderColor),
            ),
            hintText: widget.hintText,
            hintStyle: Theme.of(context).textTheme.bodySmall,
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: AppTheme.primaryColor,
            ),
          ),
          items: widget.items.entries
              .map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
