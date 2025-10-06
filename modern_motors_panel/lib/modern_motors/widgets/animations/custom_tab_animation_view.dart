import 'package:flutter/material.dart';

class CommonTabAnimationView extends StatefulWidget {
  final Function()? onTab;
  final Widget child;
  final bool isDelayed;

  const CommonTabAnimationView({
    super.key,
    required this.child,
    required this.onTab,
    this.isDelayed = false,
  });

  @override
  CommonTabAnimationViewState createState() => CommonTabAnimationViewState();
}

class CommonTabAnimationViewState extends State<CommonTabAnimationView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.2,
    )..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1 - _controller.value,
      child: GestureDetector(
        onTap: () async {
          if (mounted) {
            _controller.forward().then((value) => _controller.reverse());
            if (widget.isDelayed) {
              await Future.delayed(const Duration(milliseconds: 195));
            }
            widget.onTab!();
          }
        },
        child: widget.child,
      ),
    );
  }
}
