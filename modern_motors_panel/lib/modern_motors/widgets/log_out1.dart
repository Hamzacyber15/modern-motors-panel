import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/sign_in_screens/sign_in.dart';
import 'package:provider/provider.dart';

class Logout1 extends StatefulWidget {
  const Logout1({super.key});

  @override
  State<Logout1> createState() => _Logout1State();
}

class _Logout1State extends State<Logout1> {
  ValueNotifier<bool> loading = ValueNotifier(false);

  void logout() async {
    if (loading.value) {
      return;
    }
    setState(() {
      loading.value = true;
    });

    try {
      await FirebaseAuth.instance.signOut().then((value) {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) {
                return const SignIn();
              },
            ),
            (route) => false,
          );
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          loading.value = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
        width: context.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppTheme.whiteColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/logout.png',
              height: context.height * 0.2,
            ),
            (context.height * 0.02).dh,
            Text(
              "Are you sure, you want to logout?",
              style: AppTheme.getCurrentTheme(false, connectionStatus)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: AppTheme.pageHeaderSubTitleColor),
            ),
            (context.height * 0.07).dh,
            SizedBox(
              height: context.height * 0.06,
              width: context.height * 0.22,
              child: CustomButton(
                loadingNotifier: loading,
                text: 'Logout',
                onPressed: logout,
                fontSize: 14,
                buttonType: ButtonType.Filled,
                backgroundColor: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
