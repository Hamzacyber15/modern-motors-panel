import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/sign_in_screens/forgot_password.dart';
import 'package:modern_motors_panel/widgets/check_profile.dart';
import 'package:modern_motors_panel/widgets/loading_widget.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;
  bool loading = false;
  String language = "";
  String selectedLanguage = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        )
        .then((value) {
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) {
                  /// we need to decide what should be the flow for terms page?
                  return const CheckProfile();
                },
              ),
              (route) => false,
            );
          }
        })
        .catchError((onError) {
          setState(() {
            loading = false;
          });
          if (mounted) {
            Constants.showMessage(context, onError.message);
          }
        });
  }

  void checkCredentials() {
    if (loading) {
      return;
    }
    if (emailController.text.trim().isEmpty) {
      Constants.showMessage(context, "Please enter your your Email Address");
    } else if (passwordController.text.trim().isEmpty) {
      Constants.showMessage(context, "Please enter your Password");
    } else {
      login();
    }
  }

  void next() {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) {
    //       return const ColdStoreOwnerRegistration();
    //     },
    //   ),
    // );
  }

  void goforgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const ForgotPassword();
        },
      ),
    );
  }

  void changeLanguage(String lang) {
    if (lang == "en") {
      context.setLocale(const Locale('en', 'US'));
      setState(() {
        language = "en";
      });
    } else if (lang == "ar") {
      context.setLocale(const Locale('ar', 'SA'));
      setState(() {
        language = "ar";
      });
    } else if (lang == "ur") {
      context.setLocale(const Locale('ur', 'PK'));
      setState(() {
        language = "ur";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants.bigScreen = size.width > 700;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.greyColor,
          actions: [
            PopupMenuButton<String>(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: language == "en"
                    ? const Image(
                        image: ExactAssetImage(
                          'assets/images/united-kingdom.png',
                        ),
                        height: 60,
                        width: 60,
                      )
                    : const Image(
                        image: ExactAssetImage('assets/images/dhad.png'),
                        height: 60,
                        width: 60,
                      ),
              ),
              onSelected: (String item) {
                setState(() {
                  selectedLanguage = item;
                });
                changeLanguage(item);
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: "en",
                  child: Row(
                    children: [
                      // Image(
                      //   image:
                      //       ExactAssetImage('assets/images/united-kingdom.png'),
                      //   height: 40,
                      //   width: 40,
                      // ),
                      SizedBox(width: 5),
                      Text('English'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: "ar",
                  child: Row(
                    children: [
                      // Image(
                      //   image: ExactAssetImage('assets/images/dhad.png'),
                      //   height: 40,
                      //   width: 40,
                      // ),
                      SizedBox(width: 5),
                      Text('Arabic'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: "ur",
                  child: Row(
                    children: [
                      // Image(
                      //   image:
                      //       ExactAssetImage('assets/images/united-kingdom.png'),
                      //   height: 40,
                      //   width: 40,
                      // ),
                      SizedBox(width: 5),
                      Text('Urdu'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: loading
            ? const LoadingWidget()
            : Center(
                child: SizedBox(
                  width: Constants.bigScreen
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //const SizedBox(height: 20),
                          Container(
                            height: 70,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  //'assets/images/logo_new.jpg',
                                  'assets/images/silal_longlogo.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "welcomeToGlobalLogistics".tr(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          // Divider(
                          //   endIndent: 20,
                          //   indent: 20,
                          // ),
                          const SizedBox(height: 30),
                          Card(
                            child: TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                labelText: "email".tr(),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                              ),
                              cursorColor: AppTheme.primaryColor,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                FocusScope.of(context).nextFocus();
                              },
                            ),
                          ),
                          Card(
                            child: TextField(
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: hidePassword,
                              decoration: InputDecoration(
                                labelText: "password".tr(),
                                contentPadding: const EdgeInsets.all(5),
                                prefixIcon: const Icon(
                                  Icons.password_rounded,
                                  color: Colors.black,
                                ),
                                suffixIcon: IconButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },
                                  icon: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Icon(
                                      hidePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                ),
                              ),
                              cursorColor: AppTheme.primaryColor,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: () {
                                checkCredentials();
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: goforgotPassword,
                                child: Text("forgotPassword".tr()),
                              ),
                              ElevatedButton(
                                onPressed: checkCredentials,
                                child: Text('signIn'.tr()),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: next,
                            child: Text(
                              "dontHaveAnAccount".tr(),
                              style: TextStyle(
                                color: AppTheme.blackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Powered By ",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 70,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      //'assets/images/logo_new.jpg',
                                      'assets/images/logo_new.png',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
