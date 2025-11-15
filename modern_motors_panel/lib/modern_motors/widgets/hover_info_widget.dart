import 'package:flutter/material.dart';

class HoverInfoWidget extends StatefulWidget {
  final String title;
  final String value;
  final Color color;
  final Color hoverColor;
  final IconData? icon;
  final bool removeColor;

  const HoverInfoWidget({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.hoverColor,
    this.icon,
    this.removeColor = true,
  });

  @override
  State<HoverInfoWidget> createState() => _HoverInfoWidgetState();
}

class _HoverInfoWidgetState extends State<HoverInfoWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: isHovered ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Container(
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            color: widget.removeColor
                ? Colors.grey.withValues(alpha: 0.1)
                : (isHovered
                      ? widget.hoverColor.withValues(alpha: 0.2)
                      : widget.color.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 10,
                  color: isHovered ? widget.hoverColor : widget.color,
                ),
                const SizedBox(width: 2),
              ],
              Text(
                widget.icon != null
                    ? widget.value
                    : '${widget.title}: ${widget.value}',
                style: TextStyle(
                  fontSize: isHovered ? 10 : 9,
                  color: widget.removeColor
                      ? Colors.black
                      : isHovered
                      ? widget.hoverColor
                      : widget.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildEmptyState(String searchQuery, String type) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          searchQuery.isNotEmpty
              ? Icons.search_off
              : Icons.inventory_2_outlined,
          size: 64,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 16),
        Text(
          searchQuery.isNotEmpty
              ? 'No $type found for "$searchQuery"'
              : 'No $type available',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          searchQuery.isNotEmpty
              ? 'Try searching with different keywords'
              : 'Add your first $type to get started',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
        ),
      ],
    ),
  );
}
