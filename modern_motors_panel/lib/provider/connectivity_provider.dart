import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityProvider with ChangeNotifier {
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  void setConnectivity(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      connectionStatus = result;
    } else if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      connectionStatus = result;
    } else {
      connectionStatus = ConnectivityResult.none;
    }
    notifyListeners();
  }
}
