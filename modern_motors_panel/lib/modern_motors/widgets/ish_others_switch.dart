import 'package:flutter/material.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/provider/maintenance_booking_provider.dart';

class IshOthersSwitch extends StatelessWidget {
  final BillingParty value;
  final ValueChanged<BillingParty> onChanged;

  const IshOthersSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isIsh = value == BillingParty.ish;

    return Container(
      height: context.height * 0.08,
      width: context.width * 0.2,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6E6E6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _PillButton(
              label: 'Others',
              selected: !isIsh,
              onTap: () => onChanged(BillingParty.others),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _PillButton(
              label: 'ISH',
              selected: isIsh,
              onTap: () => onChanged(BillingParty.ish),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      height: 44,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF1565C0) : const Color(0xFFF4F6F8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? const Color(0xFF1565C0) : const Color(0xFFE6E6E6),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : const Color(0xFF5C6B7A),
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
