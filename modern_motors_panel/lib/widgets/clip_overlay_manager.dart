import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/modern_motors/widgets/helper.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/provider/main_container.dart';
import 'package:provider/provider.dart';

class ChipOverlayManager {
  static OverlayEntry? _chipOverlay;

  static void showChipOverlay(
    BuildContext context, {
    required Function(MainContainer) onItemSelected,
  }) {
    // Close existing overlay if open
    hideChipOverlay();

    final entries = [
      MainContainer.dashboard,
      MainContainer.product,
      MainContainer.productCategory,
      MainContainer.subCategory,
      MainContainer.brand,
      MainContainer.inventory,
      MainContainer.vendor,
    ];

    _chipOverlay = OverlayEntry(
      builder: (context) =>
          _ChipOverlayContent(entries: entries, onItemSelected: onItemSelected),
    );

    Overlay.of(context).insert(_chipOverlay!);
  }

  static void hideChipOverlay() {
    _chipOverlay?.remove();
    _chipOverlay = null;
  }

  static bool get isOverlayVisible => _chipOverlay != null;
}

class _ChipOverlayContent extends StatefulWidget {
  final List<MainContainer> entries;
  final Function(MainContainer) onItemSelected;

  const _ChipOverlayContent({
    required this.entries,
    required this.onItemSelected,
  });

  @override
  _ChipOverlayContentState createState() => _ChipOverlayContentState();
}

class _ChipOverlayContentState extends State<_ChipOverlayContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _closeOverlay() {
    _animationController.reverse().then((_) {
      ChipOverlayManager.hideChipOverlay();
    });
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            // Enhanced background with blur effect
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeOverlay,
                child: Container(
                  color: Colors.black.withValues(
                    alpha: 0.1 * _fadeAnimation.value,
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 2.0 * _fadeAnimation.value,
                      sigmaY: 2.0 * _fadeAnimation.value,
                    ),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            Positioned(
              top: kToolbarHeight + 16,
              right: 80,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Material(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Container(
                        width: context.width * 0.38,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.whiteColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.borderColor.withValues(alpha: 0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header section
                            Container(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.dashboard_rounded,
                                      size: 18,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                  12.w,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Quick Navigation',
                                          style:
                                              AppTheme.getCurrentTheme(
                                                false,
                                                connectionStatus,
                                              ).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.black50,
                                              ),
                                        ),
                                        2.h,
                                        Text(
                                          'Choose a section to navigate to',
                                          style:
                                              AppTheme.getCurrentTheme(
                                                false,
                                                connectionStatus,
                                              ).textTheme.bodySmall?.copyWith(
                                                color: AppTheme.black50
                                                    .withValues(alpha: 0.6),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    AppTheme.borderColor.withValues(alpha: 0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: widget.entries.asMap().entries.map((
                                entry,
                              ) {
                                final index = entry.key;
                                final item = entry.value;

                                return TweenAnimationBuilder<double>(
                                  duration: Duration(
                                    milliseconds: 200 + (index * 50),
                                  ),
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: 0.5 + (0.5 * value),
                                      child: Opacity(
                                        opacity: value,
                                        child: _EnhancedHoverableChipItem(
                                          entry: item,
                                          onTap: () {
                                            widget.onItemSelected(item);
                                            _closeOverlay();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EnhancedHoverableChipItem extends StatefulWidget {
  final MainContainer entry;
  final VoidCallback onTap;

  const _EnhancedHoverableChipItem({required this.entry, required this.onTap});

  @override
  _EnhancedHoverableChipItemState createState() =>
      _EnhancedHoverableChipItemState();
}

class _EnhancedHoverableChipItemState extends State<_EnhancedHoverableChipItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            child: Material(
              elevation: _elevationAnimation.value,
              borderRadius: BorderRadius.circular(12),
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  height: context.height * 0.14,
                  width: context.width * 0.065,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isHovered
                          ? AppTheme.primaryColor.withValues(alpha: 0.3)
                          : AppTheme.borderColor.withValues(alpha: 0.2),
                      width: _isHovered ? 2 : 1,
                    ),
                    gradient: _isHovered
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryColor.withValues(alpha: 0.05),
                              AppTheme.primaryColor.withValues(alpha: 0.08),
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              AppTheme.whiteColor,
                              AppTheme.whiteColor.withValues(alpha: 0.8),
                            ],
                          ),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: _isHovered
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.primaryColor,
                                    AppTheme.primaryColor.withValues(
                                      alpha: 0.8,
                                    ),
                                  ],
                                )
                              : LinearGradient(
                                  colors: [
                                    AppTheme.primaryColor.withValues(
                                      alpha: 0.1,
                                    ),
                                    AppTheme.primaryColor.withValues(
                                      alpha: 0.05,
                                    ),
                                  ],
                                ),
                          boxShadow: _isHovered
                              ? [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Image.asset(
                            widget.entry.data.iconPath,
                            key: ValueKey(_isHovered),
                            height: 18,
                            width: 18,
                            color: _isHovered
                                ? AppTheme.whiteColor
                                : AppTheme.primaryColor,
                          ),
                        ),
                      ),

                      8.h,

                      // Enhanced text
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: AppTheme.getCurrentTheme(false, connectionStatus)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                              color: _isHovered
                                  ? AppTheme.primaryColor
                                  : AppTheme.black50.withValues(alpha: 0.8),
                              fontWeight: _isHovered
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              fontSize: _isHovered ? 12 : 11,
                            ),
                        child: Text(
                          getTruncatedText(
                            widget.entry.data.label,
                            maxLength: 8,
                            proposedLength: 12,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
