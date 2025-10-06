import 'package:flutter/material.dart';

const double kMobileBreakpoint = 700;

bool isMobileView(BoxConstraints constraints) {
  return constraints.maxWidth <= kMobileBreakpoint;
}
