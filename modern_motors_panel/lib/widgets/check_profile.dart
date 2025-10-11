import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/model/business_models/business_profile_model.dart';
import 'package:modern_motors_panel/model/profile_models/public_profile_model.dart';
import 'package:modern_motors_panel/modern_motors/mm_admin_main_page.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/provider/order_provider.dart';
import 'package:modern_motors_panel/provider/resource_provider.dart';
import 'package:modern_motors_panel/provider/storage_provider.dart';
import 'package:modern_motors_panel/sign_in_screens/sign_in.dart';
import 'package:modern_motors_panel/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class CheckProfile extends StatefulWidget {
  const CheckProfile({super.key});

  @override
  State<CheckProfile> createState() => _CheckProfileState();
}

class _CheckProfileState extends State<CheckProfile> {
  bool loading = false;
  String role = "";
  String language = "";
  BusinessProfileModel? b;

  @override
  void initState() {
    super.initState();
    checkProfile();
  }

  Future<void> getProfile(id) async {
    b = await Provider.of<StorageProvider>(
      context,
      listen: false,
    ).getBusinessProfileById(id);
    if (b != null) {}
  }

  Future<void> getAdministrationData() async {
    bool show = false;
    bool packageShow = false;
    try {
      await FirebaseFirestore.instance
          .collection('administration')
          .doc(Constants.adminId)
          .get()
          .then((doc) {
            if (doc.exists) {
              show = doc['showDistance'] ?? false;
              packageShow = doc['packageDisplay'] ?? false;
            }
          });
      if (!mounted) {
        return;
      }
      Provider.of<StorageProvider>(context, listen: false).showStart = show;
      Provider.of<StorageProvider>(context, listen: false).showPackage =
          packageShow;
    } catch (e) {
      debugPrint(show.toString());
    }
  }

  void checkProfile() async {
    if (loading) {
      return;
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      navSignIn();
      return;
    }
    setState(() {
      loading = true;
    });
    PublicProfileModel? mmProfile = await PublicProfileModel.getmmPublicProfile(
      user.uid,
    );
    if (mmProfile != null) {
      navmmAdmin();
    }
    subscribeToFBM();
    await getDataStorage();
    PublicProfileModel? profile;
    if (user.uid == Constants.adminId) {
      profile = await PublicProfileModel.getPublicProfile(user.uid);
    }
    if (profile != null) {
      if (mounted) {
        bool result = await context.read<ResourceProvider>().start(
          profile.role,
        );
        if (!result) {
          return;
        }
        //await getProfile(profile.businessId);
        if (profile.role == "admin") {
          Constants.profile = profile;
          navAdmin();
        } else if (profile.role == "business") {
          if (profile.businessId != null) {
            Constants.businessId = profile.businessId!;
            Constants.profileId = profile.id;

            ///if (profile.terms != null && !profile.terms!) {
            navHomeTerms(profile);
            //}
            // else {
            //   navHome();
            // }
          }
        } else if (profile.role == "Driver") {
          if (mounted) {
            Provider.of<StorageProvider>(context, listen: false).profile =
                profile;
          }
          Constants.profile = profile;
          Constants.profileId = profile.id;
          navDrivers();
        } else if (profile.role == "Operation Supervisor") {
          if (mounted) {
            Provider.of<StorageProvider>(context, listen: false).profile =
                profile;
          }
          Constants.profile = profile;
          Constants.profileId = profile.id;
          Constants.businessId = profile.businessId!;
          navSupervisors();
        } else if (profile.role == "Labour") {
          if (mounted) {
            Provider.of<StorageProvider>(context, listen: false).profile =
                profile;
          }
          Constants.profile = profile;
          Constants.profileId = profile.id;
          navLabour();
        }
      }
    } else {
      updateIndex();
    }
  }

  Future<void> subscribeToFBM() async {
    if (kIsWeb) {
      return;
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseMessaging.instance.subscribeToTopic(user.uid);
    }
  }

  void updateIndex() {
    Provider.of<StorageProvider>(context, listen: false).updateStackIndex(1);
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
    //   builder: (_) {
    //     return const ColdStoreOwnerRegistration();
    //   },
    // ), (route) => false);
  }

  Future<void> getDataStorage() async {
    // await getAdministrationData();
    // if (!mounted) {
    //   return;
    // }
    // context.read<TimerProvider>().start();
  }

  void navSupervisors() async {
    // if (mounted) {
    //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
    //     builder: (_) {
    //       return const SupervisorBottomNavBar();
    //     },
    //   ), (route) => false);
    // }
  }

  void navDrivers() async {
    // if (mounted) {
    //   await getOrders();
    //   if (!mounted) {
    //     return;
    //   }
    //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
    //     builder: (_) {
    //       return const DriverBottomNavBar();
    //     },
    //   ), (route) => false);
    // }
  }

  // Future<void> getLocalData() async {
  //   Provider.of<LocalMemoryProvider>(context, listen: false).getAllOrder;
  // }

  void navLabour() async {
    // await getLocalData();
    // if (mounted) {
    //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
    //     builder: (_) {
    //       return const LabourBottomNavBar();
    //     },
    //   ), (route) => false);
    // }
  }

  Future<void> getOrders() async {
    List<String> eList = await Provider.of<StorageProvider>(
      context,
      listen: false,
    ).getEmployeeEquipment(Constants.profile.businessId!);
    debugPrint("${"emplyee id"} ${Constants.profile.businessId}");
    if (eList.isNotEmpty) {
      if (mounted) {
        Provider.of<OrderProvider>(
          context,
          listen: false,
        ).runOrderStream(eList);
      }
    }
  }

  void navmmAdmin() async {
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) {
            return const MmAdminMainPage(); //AdminMainPage();
          },
        ),
        (route) => false,
      );
    }
  }

  void navAdmin() async {
    if (mounted) {
      bool result = await context.read<MmResourceProvider>().start();
      if (!result) {
        return;
      }
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) {
          return const MmAdminMainPage(); //AdminMainPage1(); //AdminMainPage();
        },
      ),
      (route) => false,
    );
  }

  void navHome() async {
    // getBusinessOrders();
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
    //   builder: (_) {
    //     return const BottomNavBar();
    //   },
    // ), (route) => false);
  }

  void navHomeTerms(PublicProfileModel p) async {
    //getBusinessOrders();
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
    //   builder: (_) {
    //     return AgreementPage(profile: p);
    //   },
    // ), (route) => false);
  }

  void getBusinessOrders() {
    Provider.of<OrderProvider>(context, listen: false).getBusinessOrders();
  }

  void navSignIn() {
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
  }

  //

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoadingWidget());
  }
}
