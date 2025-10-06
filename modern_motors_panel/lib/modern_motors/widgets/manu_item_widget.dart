import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/provider/main_container.dart';
import 'package:modern_motors_panel/provider/main_page_provider.dart';
import 'package:provider/provider.dart';

class MenuItemWidget extends StatefulWidget {
  final String imgPath;
  final String title;
  final MainContainer container;
  final bool isMobile;
  final bool isSidebarCollapsed;

  const MenuItemWidget({
    super.key,
    required this.imgPath,
    required this.title,
    required this.container,
    required this.isMobile,
    required this.isSidebarCollapsed,
  });

  @override
  State<MenuItemWidget> createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = context.select<MainPageProvider, bool>(
      (p) => p.selectedPage == widget.container,
    );
    final provider = Provider.of<MainPageProvider>(context, listen: false);

    return Padding(
      padding: (!widget.isSidebarCollapsed && !widget.isMobile)
          ? const EdgeInsets.only(left: 16, right: 16, bottom: 4)
          : const EdgeInsets.only(left: 12, right: 12, bottom: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: () {
            provider.setSelectedPage(widget.container);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Scaffold.of(context).isDrawerOpen) {
                Navigator.of(context).pop();
              }
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor
                  : _isHovered
                  ? const Color(0xFF2A2D3A)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              // border: isSelected
              //     ? Border.all(
              //         color: AppTheme.primaryColor.withValues(alpha: 0.3),
              //       )
              //     : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: widget.isSidebarCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Image.asset(
                    widget.imgPath,
                    height: 18,
                    width: 18,
                    fit: BoxFit.cover,
                    color: isSelected
                        ? Colors.white
                        : _isHovered
                        ? Colors.white.withValues(alpha: 0.9)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
                if (!widget.isSidebarCollapsed && !widget.isMobile) ...[
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : _isHovered
                            ? Colors.white.withValues(alpha: 0.9)
                            : const Color(0xFF9CA3AF),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
