// import 'package:app/app_theme.dart';
// import 'package:app/modern_motors/widgets/animations/custom_tab_animation_view.dart';
// import 'package:flutter/material.dart';

// enum ButtonType { Filled, Bordered, TextOnly, IconAndText, IconOnly }

// class CustomButton extends StatefulWidget {
//   final String? text;
//   final VoidCallback? onPressed;
//   final ValueNotifier<bool>? loadingNotifier;
//   final Color? backgroundColor;
//   final Color? textColor;
//   final String? iconAsset;
//   final Color? iconColor;
//   final double? iconSize;
//   final double? width;
//   final double? height;
//   final double borderRadius;
//   final double? fontSize;
//   final FontWeight fontWeight;
//   final ValueNotifier<bool>? isEnabledNotifier;
//   final ButtonType buttonType;
//   final Color? borderColor;

//   const CustomButton({
//     super.key,
//     this.text,
//     required this.onPressed,
//     this.loadingNotifier,
//     this.isEnabledNotifier,
//     this.backgroundColor,
//     this.textColor = Colors.white,
//     this.fontWeight = FontWeight.w400,
//     this.iconAsset,
//     this.iconColor,
//     this.iconSize,
//     this.fontSize = 16,
//     this.width,
//     this.height,
//     this.borderRadius = 4,
//     this.buttonType = ButtonType.Filled,
//     this.borderColor,
//   });

//   @override
//   State<CustomButton> createState() => _CustomButtonState();
// }

// class _CustomButtonState extends State<CustomButton>
//     with TickerProviderStateMixin {
//   bool _isHovered = false;
//   bool _isPressed = false;
//   late AnimationController _animationController;
//   late AnimationController _pulseController;
//   late AnimationController _shimmerController;

//   late Animation<double> _scaleAnimation;
//   late Animation<double> _elevationAnimation;
//   late Animation<double> _pulseAnimation;
//   late Animation<double> _shimmerAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Main interaction animation
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );

//     // Pulse animation for loading states
//     _pulseController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );

//     // Shimmer effect for premium feel
//     _shimmerController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );

//     _scaleAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.95,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOutCubic,
//     ));

//     _elevationAnimation = Tween<double>(
//       begin: 2.0,
//       end: 12.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutQuart,
//     ));

//     _pulseAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.2,
//     ).animate(CurvedAnimation(
//       parent: _pulseController,
//       curve: Curves.easeInOut,
//     ));

//     _shimmerAnimation = Tween<double>(
//       begin: -1.0,
//       end: 2.0,
//     ).animate(CurvedAnimation(
//       parent: _shimmerController,
//       curve: Curves.easeInOut,
//     ));

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(-0.1, 0),
//       end: const Offset(0.1, 0),
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));

//     // Start shimmer effect periodically
//     //  _startPeriodicShimmer();
//   }

//   // void _startPeriodicShimmer() {
//   //   Future.delayed(const Duration(seconds: 2), () {
//   //     if (mounted && !_isPressed && widget.onPressed != null) {
//   //       _shimmerController.forward().then((_) {
//   //         if (mounted) {
//   //           _shimmerController.reset();
//   //           _startPeriodicShimmer();
//   //         }
//   //       });
//   //     }
//   //   });
//   // }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _pulseController.dispose();
//     _shimmerController.dispose();
//     super.dispose();
//   }

//   Color _getButtonColor() {
//     final baseColor = widget.backgroundColor ?? Theme.of(context).primaryColor;
//     final isDisabled = widget.onPressed == null;

//     if (isDisabled) {
//       return baseColor.withOpacity(0.4);
//     }

//     if (_isPressed) {
//       return _adjustColor(baseColor, -0.15);
//     }

//     if (_isHovered) {
//       return _adjustColor(baseColor, 0.08);
//     }

//     return baseColor;
//   }

//   Color _getBorderColor() {
//     final baseColor = widget.borderColor ?? Theme.of(context).primaryColor;
//     final isDisabled = widget.onPressed == null;

//     if (isDisabled) {
//       return baseColor.withOpacity(0.4);
//     }

//     if (_isPressed) {
//       return _adjustColor(baseColor, -0.15);
//     }

//     if (_isHovered) {
//       return _adjustColor(baseColor, 0.08);
//     }

//     return baseColor;
//   }

//   Color _getTextColor() {
//     final baseColor = widget.textColor ?? Colors.white;
//     final isDisabled = widget.onPressed == null;

//     if (isDisabled) {
//       return baseColor.withOpacity(0.6);
//     }

//     return baseColor;
//   }

//   Color _getIconColor() {
//     final baseColor = widget.iconColor ?? widget.textColor ?? Colors.white;
//     final isDisabled = widget.onPressed == null;

//     if (isDisabled) {
//       return baseColor.withOpacity(0.6);
//     }

//     return baseColor;
//   }

//   Color _adjustColor(Color color, double amount) {
//     final hsl = HSLColor.fromColor(color);
//     final adjusted = hsl.withLightness(
//       (hsl.lightness + amount).clamp(0.0, 1.0),
//     );
//     return adjusted.toColor();
//   }

//   void _handleHover(bool isHovered) {
//     if (widget.onPressed == null) return;

//     setState(() {
//       _isHovered = isHovered;
//     });

//     if (isHovered) {
//       _animationController.forward();
//     } else {
//       _animationController.reverse();
//     }
//   }

//   void _handleTapDown(TapDownDetails details) {
//     if (widget.onPressed == null) return;

//     setState(() {
//       _isPressed = true;
//     });
//   }

//   void _handleTapUp(TapUpDetails details) {
//     if (widget.onPressed == null) return;

//     setState(() {
//       _isPressed = false;
//     });
//   }

//   void _handleTapCancel() {
//     if (widget.onPressed == null) return;

//     setState(() {
//       _isPressed = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isTabletOrDesktop = MediaQuery.of(context).size.width > 600;
//     final double defaultHeight =
//         isTabletOrDesktop ? 40.0 : widget.height ?? 45.0;
//     final ValueNotifier<bool> enabledNotifier =
//         widget.isEnabledNotifier ?? ValueNotifier(true);

//     final Widget? iconWidget = widget.iconAsset != null
//         ? Image.asset(
//             widget.iconAsset!,
//             width: widget.iconSize ?? 16,
//             height: widget.iconSize ?? 16,
//             color: _getIconColor(),
//             errorBuilder: (_, __, ___) => Icon(
//               Icons.broken_image,
//               size: widget.iconSize ?? 16,
//               color: _getIconColor(),
//             ),
//           )
//         : null;

//     Widget buildButtonChild() {
//       switch (widget.buttonType) {
//         case ButtonType.Filled:
//         case ButtonType.Bordered:
//         case ButtonType.IconAndText:
//           return _buildCombined(iconWidget, context);
//         case ButtonType.TextOnly:
//           return _buildTextOnly();
//         case ButtonType.IconOnly:
//           return _buildIconOnly(iconWidget);
//       }
//     }

//     return ValueListenableBuilder<bool>(
//       valueListenable: enabledNotifier,
//       builder: (_, isEnabled, __) {
//         final bool canInteract = isEnabled && widget.onPressed != null;

//         return AnimatedBuilder(
//           animation: Listenable.merge([
//             _animationController,
//             _pulseController,
//             _shimmerController,
//           ]),
//           builder: (context, child) {
//             return Transform.scale(
//               scale: _isPressed ? _scaleAnimation.value : 1.0,
//               child: MouseRegion(
//                 onEnter: (_) => _handleHover(true),
//                 onExit: (_) => _handleHover(false),
//                 cursor: canInteract
//                     ? SystemMouseCursors.click
//                     : SystemMouseCursors.forbidden,
//                 child: CommonTabAnimationView(
//                   onTab: canInteract
//                       ? () {
//                           if (widget.loadingNotifier != null &&
//                               widget.loadingNotifier!.value) {
//                             return;
//                           }
//                           widget.onPressed?.call();
//                         }
//                       : null,
//                   child: GestureDetector(
//                     onTapDown: _handleTapDown,
//                     onTapUp: _handleTapUp,
//                     onTapCancel: _handleTapCancel,
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 200),
//                       curve: Curves.easeOutCubic,
//                       height: defaultHeight,
//                       width: widget.width ?? double.infinity,
//                       decoration: _buildBoxDecoration(context),
//                       child: Stack(
//                         children: [
//                           // Shimmer overlay
//                           if (_shouldShowShimmer()) _buildShimmerOverlay(),
//                           // Main content
//                           Center(
//                             child: widget.loadingNotifier != null
//                                 ? ValueListenableBuilder<bool>(
//                                     valueListenable: widget.loadingNotifier!,
//                                     builder: (_, isLoading, __) {
//                                       if (isLoading) {
//                                         _startPulseAnimation();
//                                       } else {
//                                         _stopPulseAnimation();
//                                       }

//                                       return isLoading
//                                           ? _buildLoadingIndicator()
//                                           : buildButtonChild();
//                                     },
//                                   )
//                                 : buildButtonChild(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   bool _shouldShowShimmer() {
//     return widget.buttonType == ButtonType.Filled ||
//         widget.buttonType == ButtonType.IconAndText;
//   }

//   Widget _buildShimmerOverlay() {
//     return Positioned.fill(
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(widget.borderRadius),
//         child: AnimatedBuilder(
//           animation: _shimmerAnimation,
//           builder: (context, child) {
//             return Transform.translate(
//               offset: Offset(_shimmerAnimation.value * 200, 0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                     colors: [
//                       Colors.transparent,
//                       Colors.white.withOpacity(0.2),
//                       Colors.transparent,
//                     ],
//                     stops: const [0.0, 0.5, 1.0],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingIndicator() {
//     return AnimatedBuilder(
//       animation: _pulseAnimation,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _pulseAnimation.value,
//           child: SizedBox(
//             width: 20,
//             height: 20,
//             child: CircularProgressIndicator(
//               strokeWidth: 2.5,
//               valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
//               backgroundColor: _getTextColor().withOpacity(0.3),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _startPulseAnimation() {
//     _pulseController.repeat(reverse: true);
//   }

//   void _stopPulseAnimation() {
//     _pulseController.stop();
//     _pulseController.reset();
//   }

//   BoxDecoration _buildBoxDecoration(BuildContext context) {
//     final buttonColor = _getButtonColor();
//     final borderColor = _getBorderColor();

//     List<BoxShadow> shadows = [];

//     // Enhanced shadow system
//     if (widget.buttonType == ButtonType.Filled ||
//         widget.buttonType == ButtonType.IconAndText ||
//         widget.buttonType == ButtonType.IconOnly) {
//       final shadowOpacity = widget.onPressed == null ? 0.1 : 0.25;
//       final elevation = _isHovered ? _elevationAnimation.value : 3.0;

//       shadows = [
//         // Main shadow
//         BoxShadow(
//           color: buttonColor.withOpacity(shadowOpacity),
//           blurRadius: elevation,
//           offset: Offset(0, elevation / 2),
//           spreadRadius: 0,
//         ),
//         // Ambient shadow
//         BoxShadow(
//           color: Colors.black.withOpacity(0.1),
//           blurRadius: elevation * 0.5,
//           offset: Offset(0, elevation / 4),
//           spreadRadius: -1,
//         ),
//       ];
//     }

//     // Enhanced gradient system
//     Gradient? gradient;
//     if (widget.buttonType == ButtonType.Filled ||
//         widget.buttonType == ButtonType.IconAndText) {
//       final gradientColors = [
//         _adjustColor(buttonColor, 0.05),
//         buttonColor,
//         _adjustColor(buttonColor, -0.05),
//       ];

//       gradient = LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: gradientColors,
//         stops: const [0.0, 0.5, 1.0],
//       );
//     }

//     return BoxDecoration(
//       color: gradient == null ? buttonColor : null,
//       gradient: gradient,
//       borderRadius: BorderRadius.circular(widget.borderRadius),
//       border: (widget.buttonType == ButtonType.Bordered ||
//               widget.borderColor != null)
//           ? Border.all(
//               color: borderColor,
//               width: _isHovered ? 2.5 : 1.5,
//             )
//           : null,
//       boxShadow: shadows,
//     );
//   }

//   Widget _buildCombined(Widget? icon, BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: widget.buttonType == ButtonType.IconAndText ? 20.0 : 16.0,
//         vertical: 2.0,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (icon != null)
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               transform: Matrix4.identity()
//                 ..scale(_isHovered ? 1.1 : 1.0)
//                 ..translate(_isHovered ? 2.0 : 0.0, 0.0),
//               child: icon,
//             ),
//           if (icon != null && (widget.text?.isNotEmpty ?? false))
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               width: _isHovered ? 10 : 8,
//             ),
//           if (widget.text != null && widget.text!.isNotEmpty)
//             Flexible(
//               child: AnimatedDefaultTextStyle(
//                 duration: const Duration(milliseconds: 200),
//                 style: TextStyle(
//                   color: _getTextColor(),
//                   fontWeight: widget.fontWeight,
//                   fontSize: widget.fontSize! * (_isHovered ? 1.02 : 1.0),
//                   fontFamily: AppTheme.fontName,
//                   letterSpacing: _isHovered ? 0.8 : 0.5,
//                   height: 1.2,
//                 ),
//                 child: Text(
//                   widget.text!,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextOnly() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
//       child: AnimatedDefaultTextStyle(
//         duration: const Duration(milliseconds: 200),
//         style: TextStyle(
//           color: _getTextColor(),
//           fontWeight: widget.fontWeight,
//           fontSize: widget.fontSize! * (_isHovered ? 1.02 : 1.0),
//           fontFamily: AppTheme.fontName,
//           letterSpacing: _isHovered ? 0.8 : 0.5,
//           height: 1.2,
//         ),
//         child: Text(
//           widget.text ?? '',
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//     );
//   }

//   Widget _buildIconOnly(Widget? icon) {
//     if (icon == null) {
//       debugPrint('⚠️ CustomButton: `iconAsset` is null for IconOnly button');
//       return const SizedBox();
//     }

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       curve: Curves.easeOutCubic,
//       transform: Matrix4.identity()
//         ..scale(_isHovered ? 1.15 : 1.0)
//         ..rotateZ(_isHovered ? 0.05 : 0.0),
//       child: icon,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/modern_motors/widgets/animations/custom_tab_animation_view.dart';

enum ButtonType { Filled, Bordered, TextOnly, IconAndText, IconOnly }

class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final ValueNotifier<bool>? loadingNotifier;
  final Color? backgroundColor;
  final Color? textColor;
  final String? iconAsset;
  final Color? iconColor;
  final double? iconSize;
  final double? width;
  final double? height;
  final double borderRadius;
  final double? fontSize;
  final FontWeight fontWeight;
  final ValueNotifier<bool>? isEnabledNotifier;
  final ButtonType buttonType;
  final Color? borderColor;

  const CustomButton({
    super.key,
    this.text,
    required this.onPressed,
    this.loadingNotifier,
    this.isEnabledNotifier,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.w400,
    this.iconAsset,
    this.iconColor,
    this.iconSize,
    this.fontSize = 16,
    this.width,
    this.height,
    this.borderRadius = 4,
    this.buttonType = ButtonType.Filled,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTabletOrDesktop = MediaQuery.of(context).size.width > 600;
    final double defaultHeight = isTabletOrDesktop ? 40.0 : height ?? 45.0;
    final ValueNotifier<bool> enabledNotifier =
        isEnabledNotifier ?? ValueNotifier(true);

    final Widget? iconWidget = iconAsset != null
        ? Image.asset(
            iconAsset!,
            width: iconSize ?? 16,
            height: iconSize ?? 16,
            color: iconColor,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          )
        : null;

    Widget buildButtonChild() {
      switch (buttonType) {
        case ButtonType.Filled:
        case ButtonType.Bordered:
        case ButtonType.IconAndText:
          return _buildCombined(iconWidget, context);
        case ButtonType.TextOnly:
          return _buildTextOnly();
        case ButtonType.IconOnly:
          return _buildIconOnly(iconWidget);
      }
    }

    final container = Container(
      height: defaultHeight,
      width: width ?? double.infinity,
      decoration: _buildBoxDecoration(context),
      child: Center(
        child: loadingNotifier != null
            ? ValueListenableBuilder<bool>(
                valueListenable: loadingNotifier!,
                builder: (_, isLoading, __) {
                  return isLoading
                      ? const CircularProgressIndicator(
                          padding: EdgeInsets.all(2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                      : buildButtonChild();
                },
              )
            : buildButtonChild(),
      ),
    );

    return ValueListenableBuilder<bool>(
      valueListenable: enabledNotifier,
      builder: (_, isEnabled, __) => CommonTabAnimationView(
        onTab: (loadingNotifier != null && loadingNotifier!.value) || !isEnabled
            ? null
            : onPressed,
        child: container,
      ),
    );
  }

  BoxDecoration? _buildBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color:
          (buttonType == ButtonType.Filled ||
              buttonType == ButtonType.IconOnly ||
              buttonType == ButtonType.TextOnly)
          ? backgroundColor
          : null,
      borderRadius: BorderRadius.circular(borderRadius),
      border: (buttonType == ButtonType.Bordered || borderColor != null)
          ? Border.all(color: borderColor ?? Theme.of(context).primaryColor)
          : null,
      gradient:
          buttonType == ButtonType.Filled ||
              buttonType == ButtonType.IconAndText
          ? LinearGradient(
              colors: [
                backgroundColor ?? Theme.of(context).primaryColor,
                backgroundColor ?? Theme.of(context).primaryColor,
              ],
            )
          : null,
    );
  }

  Widget _buildCombined(Widget? icon, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) icon,
        if (icon != null && (text?.isNotEmpty ?? false)) 8.w,
        if (text != null && text!.isNotEmpty)
          Text(
            text!,
            style: TextStyle(
              color: textColor,
              fontWeight: fontWeight,
              fontSize: fontSize,
              fontFamily: AppTheme.fontName,
            ),
          ),
      ],
    );
  }

  Widget _buildTextOnly() {
    return Text(
      text ?? '',
      style: TextStyle(
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: AppTheme.fontName,
      ),
    );
  }

  Widget _buildIconOnly(Widget? icon) {
    if (icon == null) {
      debugPrint('⚠️ CustomButton: `iconAsset` is null for IconOnly button');
    }
    return icon ?? const SizedBox();
  }
}

// import 'package:flutter/material.dart';
// import 'package:practice_erp/core/app_theme.dart';
// import 'package:practice_erp/view/unit/extensions.dart';

// import 'custom_animation_tab_view.dart';

// enum ButtonType { Filled, Bordered, TextOnly, IconAndText, IconOnly }

// class CustomButton extends StatefulWidget {
//   final String? text;
//   final VoidCallback? onPressed;
//   final ValueNotifier<bool>? loadingNotifier;
//   final Color? backgroundColor;
//   final Color? textColor;
//   final String? iconAsset;
//   final Color? iconColor;
//   final double? iconSize;
//   final double? width;
//   final double? height;
//   final double borderRadius;
//   final double? fontSize;
//   final FontWeight fontWeight;
//   final ValueNotifier<bool>? isEnabledNotifier;
//   final ButtonType buttonType;
//   final Color? borderColor;

//   const CustomButton({
//     super.key,
//     this.text,
//     required this.onPressed,
//     this.loadingNotifier,
//     this.isEnabledNotifier,
//     this.backgroundColor,
//     this.textColor = Colors.white,
//     this.fontWeight = FontWeight.w400,
//     this.iconAsset,
//     this.iconColor,
//     this.iconSize,
//     this.fontSize = 16,
//     this.width,
//     this.height,
//     this.borderRadius = 4,
//     this.buttonType = ButtonType.Filled,
//     this.borderColor,
//   });

//   @override
//   State<CustomButton> createState() => _CustomButtonState();
// }

// class _CustomButtonState extends State<CustomButton>
//     with SingleTickerProviderStateMixin {
//   bool _isHovered = false;
//   bool _isPressed = false;
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _elevationAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.96,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//     _elevationAnimation = Tween<double>(
//       begin: 2.0,
//       end: 8.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Color _getButtonColor() {
//     final baseColor = widget.backgroundColor ?? Theme.of(context).primaryColor;

//     if (widget.onPressed == null) {
//       return baseColor.withOpacity(0.6);
//     }

//     if (_isPressed) {
//       return _darkenColor(baseColor, 0.2);
//     }

//     if (_isHovered) {
//       return _lightenColor(baseColor, 0.1);
//     }

//     return baseColor;
//   }

//   Color _getBorderColor() {
//     final baseColor = widget.borderColor ?? Theme.of(context).primaryColor;

//     if (widget.onPressed == null) {
//       return baseColor.withOpacity(0.6);
//     }

//     if (_isPressed) {
//       return _darkenColor(baseColor, 0.2);
//     }

//     if (_isHovered) {
//       return _lightenColor(baseColor, 0.1);
//     }

//     return baseColor;
//   }

//   Color _getTextColor() {
//     final baseColor = widget.textColor ?? Colors.white;

//     if (widget.onPressed == null) {
//       return baseColor.withOpacity(0.7);
//     }

//     return baseColor;
//   }

//   Color _getIconColor() {
//     final baseColor = widget.iconColor ?? widget.textColor ?? Colors.white;

//     if (widget.onPressed == null) {
//       return baseColor.withOpacity(0.7);
//     }

//     return baseColor;
//   }

//   Color _lightenColor(Color color, double amount) {
//     final hsl = HSLColor.fromColor(color);
//     final lightened = hsl.withLightness(
//       (hsl.lightness + amount).clamp(0.0, 1.0),
//     );
//     return lightened.toColor();
//   }

//   Color _darkenColor(Color color, double amount) {
//     final hsl = HSLColor.fromColor(color);
//     final darkened = hsl.withLightness(
//       (hsl.lightness - amount).clamp(0.0, 1.0),
//     );
//     return darkened.toColor();
//   }

//   void _handleHover(bool isHovered) {
//     if (widget.onPressed == null) return;

//     setState(() {
//       _isHovered = isHovered;
//     });

//     if (isHovered) {
//       _animationController.forward();
//     } else {
//       _animationController.reverse();
//     }
//   }

//   void _handleTapDown(TapDownDetails details) {
//     if (widget.onPressed == null) return;

//     setState(() {
//       _isPressed = true;
//     });
//   }

//   void _handleTapUp(TapUpDetails details) {
//     if (widget.onPressed == null) return;

//     setState(() {
//       _isPressed = false;
//     });
//   }

//   void _handleTapCancel() {
//     if (widget.onPressed == null) return;

//     setState(() {
//       _isPressed = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isTabletOrDesktop = MediaQuery.of(context).size.width > 600;
//     final double defaultHeight = isTabletOrDesktop ? 40.0 : widget.height ?? 45.0;
//     final ValueNotifier<bool> enabledNotifier =
//         widget.isEnabledNotifier ?? ValueNotifier(true);

//     final Widget? iconWidget = widget.iconAsset != null
//         ? Image.asset(
//             widget.iconAsset!,
//             width: widget.iconSize ?? 16,
//             height: widget.iconSize ?? 16,
//             color: _getIconColor(),
//             errorBuilder: (_, __, ___) => Icon(
//               Icons.broken_image,
//               size: widget.iconSize ?? 16,
//               color: _getIconColor(),
//             ),
//           )
//         : null;

//     Widget buildButtonChild() {
//       switch (widget.buttonType) {
//         case ButtonType.Filled:
//         case ButtonType.Bordered:
//         case ButtonType.IconAndText:
//           return _buildCombined(iconWidget, context);
//         case ButtonType.TextOnly:
//           return _buildTextOnly();
//         case ButtonType.IconOnly:
//           return _buildIconOnly(iconWidget);
//       }
//     }

//     return ValueListenableBuilder<bool>(
//       valueListenable: enabledNotifier,
//       builder: (_, isEnabled, __) {
//         final bool canInteract = isEnabled && widget.onPressed != null;

//         return AnimatedBuilder(
//           animation: _animationController,
//           builder: (context, child) {
//             return Transform.scale(
//               scale: _isPressed ? _scaleAnimation.value : 1.0,
//               child: MouseRegion(
//                 onEnter: (_) => _handleHover(true),
//                 onExit: (_) => _handleHover(false),
//                 cursor: canInteract ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
//                 child: GestureDetector(
//                   onTapDown: _handleTapDown,
//                   onTapUp: _handleTapUp,
//                   onTapCancel: _handleTapCancel,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     curve: Curves.easeInOut,
//                     height: defaultHeight,
//                     width: widget.width ?? double.infinity,
//                     decoration: _buildBoxDecoration(context),
//                     child: Center(
//                       child: widget.loadingNotifier != null
//                           ? ValueListenableBuilder<bool>(
//                               valueListenable: widget.loadingNotifier!,
//                               builder: (_, isLoading, __) {
//                                 return isLoading
//                                     ? Container(
//                                         width: 20,
//                                         height: 20,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           valueColor: AlwaysStoppedAnimation<Color>(
//                                             _getTextColor(),
//                                           ),
//                                         ),
//                                       )
//                                     : buildButtonChild();
//                               },
//                             )
//                           : buildButtonChild(),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   BoxDecoration _buildBoxDecoration(BuildContext context) {
//     final buttonColor = _getButtonColor();
//     final borderColor = _getBorderColor();

//     List<BoxShadow> shadows = [];

//     // Add shadows for better depth
//     if (widget.buttonType == ButtonType.Filled ||
//         widget.buttonType == ButtonType.IconAndText ||
//         widget.buttonType == ButtonType.IconOnly) {
//       shadows = [
//         BoxShadow(
//           color: buttonColor.withOpacity(0.3),
//           blurRadius: _isHovered ? _elevationAnimation.value : 2.0,
//           offset: Offset(0, _isHovered ? 4 : 2),
//         ),
//       ];
//     }

//     // Create gradient for filled buttons
//     Gradient? gradient;
//     if (widget.buttonType == ButtonType.Filled ||
//         widget.buttonType == ButtonType.IconAndText) {
//       gradient = LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: [
//           buttonColor,
//           _darkenColor(buttonColor, 0.05),
//         ],
//         stops: const [0.0, 1.0],
//       );
//     }

//     return BoxDecoration(
//       color: gradient == null ? buttonColor : null,
//       gradient: gradient,
//       borderRadius: BorderRadius.circular(widget.borderRadius),
//       border: (widget.buttonType == ButtonType.Bordered || widget.borderColor != null)
//           ? Border.all(
//               color: borderColor,
//               width: _isHovered ? 2.0 : 1.5,
//             )
//           : null,
//       boxShadow: shadows,
//     );
//   }

//   Widget _buildCombined(Widget? icon, BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (icon != null)
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               transform: Matrix4.identity()
//                 ..scale(_isHovered ? 1.1 : 1.0),
//               child: icon,
//             ),
//           if (icon != null && (widget.text?.isNotEmpty ?? false))
//             SizedBox(width: 8),
//           if (widget.text != null && widget.text!.isNotEmpty)
//             Flexible(
//               child: Text(
//                 widget.text!,
//                 style: TextStyle(
//                   color: _getTextColor(),
//                   fontWeight: widget.fontWeight,
//                   fontSize: widget.fontSize,
//                   fontFamily: AppTheme.fontFamilyNunito,
//                   letterSpacing: 0.5,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextOnly() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Text(
//         widget.text ?? '',
//         style: TextStyle(
//           color: _getTextColor(),
//           fontWeight: widget.fontWeight,
//           fontSize: widget.fontSize,
//           fontFamily: AppTheme.fontFamilyNunito,
//           letterSpacing: 0.5,
//         ),
//         overflow: TextOverflow.ellipsis,
//       ),
//     );
//   }

//   Widget _buildIconOnly(Widget? icon) {
//     if (icon == null) {
//       debugPrint('⚠️ CustomButton: `iconAsset` is null for IconOnly button');
//       return const SizedBox();
//     }

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       transform: Matrix4.identity()
//         ..scale(_isHovered ? 1.1 : 1.0),
//       child: icon,
//     );
//   }
// }
