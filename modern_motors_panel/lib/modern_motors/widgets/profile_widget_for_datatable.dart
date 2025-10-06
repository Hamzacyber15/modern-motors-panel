import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/profile_models/public_profile_model.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class ProfileWidgetForDatatable extends StatefulWidget {
  final String userId;

  const ProfileWidgetForDatatable({super.key, required this.userId});

  @override
  State<ProfileWidgetForDatatable> createState() =>
      _ProfileWidgetForDatatableState();
}

class _ProfileWidgetForDatatableState extends State<ProfileWidgetForDatatable> {
  PublicProfileModel? profileModel;
  ValueNotifier<bool> loading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    getUsersData();
  }

  void getUsersData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (loading.value) return;
      loading.value = true;
      final profile = await context.read<MmResourceProvider>().getProfileByID(
        widget.userId,
      ); //UserDb().fetchSingleProfile(context, widget.userId);

      if (!mounted) return; // ⛔ prevent calling setState after dispose

      setState(() {
        profileModel = profile;
        debugPrint('profile: ${profileModel!.id}');
        debugPrint('profile1: ${profile.id}');
        loading.value = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    if (loading.value || profileModel == null) {
      return Row(
        children: [
          const Icon(Icons.broken_image),
          10.w,
          const Text("Loading..."),
        ],
      );
    }

    return Row(
      children: [
        Container(
          color: AppTheme.bgColor,
          padding: const EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              profileModel!.profileUrl,
              height: 25,
              width: 25,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
        ),
        10.w,
        Text(
          profileModel == null ? 'Invalid' : profileModel!.userName,
          style: AppTheme.getCurrentTheme(false, connectionStatus)
              .textTheme
              .bodyMedium!
              .copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppTheme.black50,
              ),
        ),
      ],
    );
  }
}
