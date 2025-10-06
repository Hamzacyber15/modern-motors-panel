import 'package:flutter/material.dart';
import 'package:modern_motors_panel/provider/main_container.dart';

class MainPageProvider extends ChangeNotifier {
  MainContainer selectedPage = MainContainer.dashboard;

  void setSelectedPage(MainContainer container) {
    selectedPage = container;
    notifyListeners();
  }
}
