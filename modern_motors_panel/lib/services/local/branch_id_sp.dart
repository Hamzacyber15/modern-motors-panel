import 'package:modern_motors_panel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BranchIdSp {
  static SharedPreferences? _sp;

  /// Call this once in main() before runApp
  static Future<void> initSp() async {
    _sp = await SharedPreferences.getInstance();
  }

  static Future<void> saveId(String id) async {
    await _sp?.setString('branchId', id);
  }

  static String getBranchId() {
    return _sp?.getString('branchId') ?? Constants.mainBranchId;
  }

  static Future<void> removeBranchId() async {
    await _sp?.remove('branchId');
  }
}
