import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/widgets/loading_widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void forgotPassword() {
    if (emailController.text.trim().isEmpty) {
      Constants.showMessage(context, "Please enter your email");
    } else {
      FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text)
          .then((value) {
            if (mounted) {
              Constants.showMessage(
                context,
                "Password reset link sent to your email",
              );
              Navigator.of(context).pop();
            }
          })
          .catchError((onError) {
            if (mounted) {
              Constants.showMessage(
                context,
                "Error resetting password, please try again later",
              );
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: loading
            ? const LoadingWidget()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 35,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Image.asset(
                        'assets/images/logo_new.png',
                        height: 120,
                        width: 160,
                      ),
                      const SizedBox(height: 30),
                      Card(
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email, color: Colors.black),
                            labelText: "Please Enter your email",
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          cursorColor: AppTheme.primaryColor,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: forgotPassword,
                              child: const Text('Reset Password'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
