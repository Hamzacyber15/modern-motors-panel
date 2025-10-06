import 'package:flutter/material.dart';

class AppDropdown<T> extends StatefulWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.labelBuilder, // how to show each item
    this.value,
    this.hint,
    this.width,
    this.menuMaxHeight = 280,
    this.itemHeight = 44,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    this.backgroundColor,
    this.borderColor,
    this.icon,
    this.enabled = true,
  });

  final List<T> items;
  final T? value;
  final ValueChanged<T> onChanged;
  final String Function(T item) labelBuilder;

  final String? hint;
  final double? width;
  final double menuMaxHeight;
  final double itemHeight;
  final double borderRadius;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final Widget? icon;
  final bool enabled;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;
  bool _open = false;

  void _toggle() {
    if (!_open) {
      _openDropdown();
    } else {
      _closeDropdown();
    }
  }

  void _openDropdown() {
    if (!mounted || _open) return;
    _entry = _buildOverlay();
    Overlay.of(context).insert(_entry!);
    setState(() => _open = true);
  }

  void _closeDropdown() {
    _entry?.remove();
    _entry = null;
    if (mounted) setState(() => _open = false);
  }

  OverlayEntry _buildOverlay() {
    final theme = Theme.of(context);
    final bg = widget.backgroundColor ?? theme.cardColor;
    final borderColor = widget.borderColor ?? theme.dividerColor;

    return OverlayEntry(
      builder: (ctx) => Stack(
        children: [
          // tap outside to dismiss
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeDropdown,
            ),
          ),
          CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            offset: const Offset(0, 8), // small gap under the button
            child: Material(
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: widget.width ?? MediaQuery.of(context).size.width,
                  maxHeight: widget.menuMaxHeight,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius,
                    ),
                    border: Border.all(color: borderColor),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 16,
                        spreadRadius: 0,
                        offset: Offset(0, 8),
                        color: Color(0x1A000000), // subtle shadow
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: theme.dividerColor.withOpacity(.4),
                    ),
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final selected = item == widget.value;
                      return InkWell(
                        onTap: () {
                          widget.onChanged(item);
                          _closeDropdown();
                        },
                        child: Container(
                          height: widget.itemHeight,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.labelBuilder(item),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight:
                                        selected ? FontWeight.w600 : null,
                                  ),
                                ),
                              ),
                              if (selected)
                                Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: theme.colorScheme.primary,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = widget.borderColor ?? theme.dividerColor;

    return CompositedTransformTarget(
      link: _link,
      child: Opacity(
        opacity: widget.enabled ? 1 : .6,
        child: GestureDetector(
          onTap: widget.enabled ? _toggle : null,
          child: Container(
            width: widget.width,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? theme.cardColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.value != null
                        ? widget.labelBuilder(widget.value as T)
                        : (widget.hint ?? 'Select'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: widget.value == null ? theme.hintColor : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                widget.icon ??
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 150),
                      turns: _open ? .5 : 0,
                      child: const Icon(Icons.expand_more_rounded, size: 20),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
