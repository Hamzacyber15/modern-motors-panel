// dropdown_controller_provider.dart

import 'package:flutter/material.dart';

class DropdownControllerProvider extends ChangeNotifier {
  VoidCallback? _closeActiveDropdown;

  void registerActiveDropdown(VoidCallback closeDropdown) {
    // Close any existing one
    _closeActiveDropdown?.call();
    _closeActiveDropdown = closeDropdown;
  }

  void clearActiveDropdown() {
    _closeActiveDropdown = null;
  }

  void dismissDropdown() {
    _closeActiveDropdown?.call();
    _closeActiveDropdown = null;
    notifyListeners();
  }
}
