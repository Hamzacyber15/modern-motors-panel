// import 'package:app/main.dart';
// import 'package:flutter/foundation.dart';
// import 'package:restart_app/restart_app.dart';
// import 'package:shorebird_code_push/shorebird_code_push.dart';

// class UpdateProvider with ChangeNotifier {
//   UpdateStatus isShorebirdAvailable = UpdateStatus.unavailable;
//   bool isUpdateAvailable = false;
//   bool readyToInstall = false;

//   Future<void> checkUpdateAvailability() async {
//     if (kIsWeb) {
//       return;
//     }
//     isShorebirdAvailable = await shorebirdCodePush.checkForUpdate();
//     if (isShorebirdAvailable == UpdateStatus.outdated) {
//       isUpdateAvailable = true;
//       downloadUpdate();
//     }
//   }

//   Future<void> downloadUpdate() async {
//     shorebirdCodePush.update();
//     // await shorebirdCodePush. ().then((onValue) {
//     //   readyToInstall = true;
//     // }).catchError((onError) {
//     //   readyToInstall = false;
//     // });
//     notifyListeners();
//   }

//   void installUpdate() {
//     if (readyToInstall) {
//       Restart.restartApp();
//     }
//   }
// }
