import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/build_drop_down_ui.dart';
import 'package:modern_motors_panel/modern_motors/widgets/helper.dart';

class CustomSearchableDropdown extends StatefulWidget {
  final String hintText;
  final String? value;
  final List<String>? selectedValues;
  final Map<String, String> items;
  final void Function(String)? onChanged;
  final bool loading;
  final void Function(List<MapEntry<String, String>>)? onMultiChanged;
  final bool isMultiSelect;
  final double? verticalPadding;
  final bool isRequired;

  const CustomSearchableDropdown({
    super.key,
    required this.hintText,
    required this.items,
    this.onChanged,
    this.onMultiChanged,
    this.loading = false,
    this.value,
    this.selectedValues,
    this.verticalPadding,
    this.isMultiSelect = false,
    this.isRequired = true,
  });

  @override
  State<CustomSearchableDropdown> createState() =>
      _CustomSearchableDropdownState();
}

class _CustomSearchableDropdownState extends State<CustomSearchableDropdown> {
  final TextEditingController _searchController = TextEditingController();
  List<MapEntry<String, String>> _filteredItems = [];
  List<MapEntry<String, String>> _selectedEntries = [];
  final _formFieldKey = GlobalKey<FormFieldState>();

  String? _selectedValue;
  bool _showDropdown = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items.entries.toList();

    if (widget.isMultiSelect && widget.selectedValues != null) {
      _selectedEntries = widget.items.entries
          .where((entry) => widget.selectedValues!.contains(entry.key))
          .toList();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formFieldKey.currentState?.didChange(widget.selectedValues);
      });
    } else {
      _selectedValue = widget.value;
    }
  }

  @override
  void didUpdateWidget(covariant CustomSearchableDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isMultiSelect && widget.selectedValues != null) {
      _selectedEntries = widget.items.entries
          .where((entry) => widget.selectedValues!.contains(entry.key))
          .toList();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formFieldKey.currentState?.didChange(widget.selectedValues);
      });
    }
  }

  void _toggleDropdown(FormFieldState field) {
    if (_showDropdown) {
      _removeOverlay();
    } else {
      _showOverlay(field);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _showDropdown = false;
  }

  void _showOverlay(FormFieldState field) {
    _filteredItems = widget.items.entries.toList();

    if (widget.isMultiSelect && widget.selectedValues != null) {
      _selectedEntries = widget.items.entries
          .where((entry) => widget.selectedValues!.contains(entry.key))
          .toList();
    }

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // Tapping outside to close
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _removeOverlay(),
              child: Container(),
            ),
          ),

          Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 4.0,
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height + 4.0),
              child: Material(
                elevation: 4,
                child: StatefulBuilder(
                  builder: (context, setOverlayState) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.items.length > 3)
                            CustomMmTextField(
                              labelText: 'Search',
                              controller: _searchController,
                              hintText: widget.hintText,

                              onChanged: (query) {
                                setOverlayState(() {
                                  _filteredItems = widget.items.entries
                                      .where(
                                        (entry) => entry.value
                                            .toLowerCase()
                                            .contains(query.toLowerCase()),
                                      )
                                      .toList();
                                });
                              },
                            ),
                          8.h,
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 160),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final entry = _filteredItems[index];
                                // final isSelected =
                                //     widget.isMultiSelect
                                //         ? _selectedEntries.contains(entry)
                                //         : entry.key == _selectedValue;
                                final isSelected = widget.isMultiSelect
                                    ? _selectedEntries.any(
                                        (e) => e.key == entry.key,
                                      )
                                    : entry.key == _selectedValue;

                                return MouseRegion(
                                  onEnter: (_) {
                                    setOverlayState(() {
                                      _hoveredIndex = index;
                                    });
                                  },
                                  onExit: (_) {
                                    setOverlayState(() {
                                      _hoveredIndex = null;
                                    });
                                  },
                                  child: InkWell(
                                    onTap: () {
                                      if (widget.isMultiSelect) {
                                        setOverlayState(() {
                                          final alreadySelected =
                                              _selectedEntries.any(
                                                (e) => e.key == entry.key,
                                              );
                                          if (alreadySelected) {
                                            _selectedEntries.removeWhere(
                                              (e) => e.key == entry.key,
                                            );
                                          } else {
                                            _selectedEntries.add(entry);
                                          }

                                          // if (_selectedEntries.contains(
                                          //   entry,
                                          // )) {
                                          //   _selectedEntries.remove(entry);
                                          // } else {
                                          //   _selectedEntries.add(entry);
                                          // }
                                        });
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                              widget.onMultiChanged?.call(
                                                _selectedEntries,
                                              );
                                              field.didChange(
                                                'updated',
                                              ); // dummy value for validation
                                            });
                                      } else {
                                        _selectedValue = entry.key;
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                              widget.onChanged?.call(entry.key);
                                              field.didChange(entry.key);
                                            });
                                        _removeOverlay();
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      color: isSelected
                                          ? AppTheme.primaryColor
                                          : (_hoveredIndex == index
                                                ? AppTheme.primaryColor
                                                      .withAlpha(10)
                                                : Colors.transparent),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              entry.value,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (widget.isMultiSelect) ...[
                            8.h,
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    widget.onMultiChanged?.call(
                                      _selectedEntries,
                                    );
                                    field.didChange(
                                      _selectedEntries
                                          .map((e) => e.key)
                                          .toList(),
                                    );
                                    _removeOverlay();
                                  });
                                },

                                icon: const Icon(Icons.done, size: 18),
                                label: const Text("Done"),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
    setState(() => _showDropdown = true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayText = getDropDownDisplayText(
      isMultiSelect: widget.isMultiSelect,
      selectedValues: widget.selectedValues,
      value: widget.value,
      items: widget.items,
      hintText: widget.hintText,
    );
    // widget.isMultiSelect
    //     ? ((widget.selectedValues == null || widget.selectedValues!.isEmpty)
    //         ? widget.hintText
    //         : widget.selectedValues!
    //             .map((key) => widget.items[key])
    //             .whereType<String>()
    //             .join(', '))
    //     : (widget.items[widget.value] ?? widget.hintText);

    if (widget.isMultiSelect) {
      return FormField<List<String>>(
        key: _formFieldKey,
        enabled: !widget.loading,
        initialValue: widget.selectedValues ?? [],
        validator: (val) {
          // if (val == null || val.isEmpty)
          if (widget.isRequired && (val == null || val.isEmpty)) {
            return 'Please ${widget.hintText}';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (field) => buildDropdownUI(
          context: context,
          field: field,
          displayText: displayText,
          hintText: widget.hintText,
          layerLink: _layerLink,
          showDropdown: _showDropdown,
          verticalPadding: widget.verticalPadding ?? 6,
          toggleDropdown: _toggleDropdown,
        ),
      );
    } else {
      return FormField<String>(
        key: _formFieldKey,
        initialValue: widget.value,
        validator: (val) {
          // if (val == null || val.isEmpty)
          if (widget.isRequired && (val == null || val.isEmpty)) {
            return 'Please ${widget.hintText}';
          }
          return null;
        },
        autovalidateMode: widget.loading
            ? AutovalidateMode.disabled
            : AutovalidateMode.onUserInteraction,
        builder: (field) => buildDropdownUI(
          context: context,
          field: field,
          displayText: displayText,
          hintText: widget.hintText,
          layerLink: _layerLink,
          showDropdown: _showDropdown,
          verticalPadding: widget.verticalPadding ?? 6,
          toggleDropdown: _toggleDropdown,
        ),
      );
    }
  }
}
