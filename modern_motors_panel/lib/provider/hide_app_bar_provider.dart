import 'package:flutter/cupertino.dart';

class HideAppbarProvider extends ChangeNotifier {
  bool _isBarHid = true;

  bool get getIsBarValue => _isBarHid;

  void setIsBarValue(bool value) {
    _isBarHid = value;
    notifyListeners();
  }
}
