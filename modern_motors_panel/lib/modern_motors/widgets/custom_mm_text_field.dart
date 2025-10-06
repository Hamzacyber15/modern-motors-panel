import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:provider/provider.dart';

class CustomMmTextField extends StatefulWidget {
  final String hintText;
  final String heading;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final IconData? icon;
  final bool? readOnly;
  final List<TextInputFormatter>? inputFormatter;
  final VoidCallback? onIcon;
  final bool obscureText, isHeadingAvailable;
  final AutovalidateMode? autovalidateMode;
  final String? labelText;
  final Function(String)? onChanged;
  final double topPadding;
  final VoidCallback? onTap;

  const CustomMmTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.heading = 'Heading',
    this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onIcon,
    this.obscureText = false,
    this.readOnly,
    this.validator,
    this.inputFormatter,
    this.autovalidateMode,
    this.labelText,
    this.onTap,
    this.onChanged,
    this.topPadding = 0,
    this.isHeadingAvailable = false,
  });

  @override
  State<CustomMmTextField> createState() => _CustomMmTextFieldState();
}

class _CustomMmTextFieldState extends State<CustomMmTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(left: 8)),
        widget.isHeadingAvailable
            ? Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 6),
                child: Text(
                  widget.heading,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.pageHeaderTitleColor,
                  ),
                ),
              )
            : Container(),
        Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            boxShadow: _focusNode.hasFocus
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.08),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(1, 1),
                    ),
                  ]
                : [],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            onTap: widget.onTap,
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            obscureText: widget.obscureText,
            readOnly: widget.readOnly ?? false,
            controller: widget.controller,
            validator: widget.validator,
            autovalidateMode: widget.autovalidateMode,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            style: AppTheme.getCurrentTheme(
              false,
              connectionStatus,
            ).textTheme.bodyMedium,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: widget.topPadding == 0
                  ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
                  : EdgeInsets.only(
                      top: widget.topPadding,
                      left: 10,
                      right: 10,
                      bottom: 6,
                    ),
              labelText: widget.labelText,
              labelStyle: AppTheme.getCurrentTheme(false, connectionStatus)
                  .textTheme
                  .bodySmall!
                  .copyWith(
                    color: _focusNode.hasFocus
                        ? AppTheme.primaryColor
                        : AppTheme.primaryColor,
                  ),
              filled: true,
              fillColor: AppTheme.whiteColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(width: 0.8, color: AppTheme.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(
                  width: 0.9,
                  color: AppTheme.primaryColor,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(width: 0.8, color: AppTheme.borderColor),
              ),
              suffixIcon: widget.icon != null
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        widget.icon,
                        size: 14,
                        color: AppTheme.primaryColor,
                      ),
                      onPressed: widget.onIcon ?? () {},
                    )
                  : SizedBox(width: 40, height: 14),
              hintText: widget.hintText,
              hintStyle: AppTheme.getCurrentTheme(
                false,
                connectionStatus,
              ).textTheme.bodySmall,
            ),
            inputFormatters: widget.inputFormatter,
          ),
        ),
      ],
    );
  }
}
