import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dots_loader.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/services/local/branch_id_sp.dart';
import 'package:modern_motors_panel/sign_in_screens/sign_in.dart';

import 'package:provider/provider.dart';

class ProfileOverlayWidget extends StatefulWidget {
  const ProfileOverlayWidget({super.key});

  @override
  State<ProfileOverlayWidget> createState() => _ProfileOverlayWidgetState();
}

class _ProfileOverlayWidgetState extends State<ProfileOverlayWidget> {
  final GlobalKey _iconKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  User? user = FirebaseAuth.instance.currentUser;
  ValueNotifier<bool> loading = ValueNotifier(false);
  BranchModel? selectedBranch;
  String? savedId;

  void logout() async {
    if (loading.value) return;
    loading.value = true;
    try {
      await FirebaseAuth.instance.signOut().then((value) async {
        await BranchIdSp.removeBranchId();
        if (mounted) {
          _removeOverlay();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignIn()),
          );
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) loading.value = false;
    }
  }

  void _toggleOverlay() {
    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final renderBox = _iconKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;
    const overlayWidth = 280.0;
    const margin = 10.0;

    double left = offset.dx;
    if (left + overlayWidth + margin > screenWidth) {
      left = screenWidth - overlayWidth - margin;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          Consumer<MmResourceProvider>(
            builder: (context, resource, child) {
              final userProfile = resource.getProfileByID(user!.uid);
              final branch = resource.getBranchByID(BranchIdSp.getBranchId());
              ImageProvider<Object>? image = userProfile.profileUrl.isEmpty
                  ? const AssetImage('assets/images/userimg.png')
                  : NetworkImage(userProfile.profileUrl);

              // Branch dropdown logic
              final currentUserId = FirebaseAuth.instance.currentUser?.uid;
              List<BranchModel> branches;
              if (currentUserId == Constants.adminId) {
                branches = [...resource.branchesList];
              } else {
                final employee = resource.getEmployeeByID(currentUserId ?? '');
                final allowedBranchIds = employee.branches ?? [];
                branches = resource.branchesList
                    .where((b) => allowedBranchIds.contains(b.id))
                    .toList();
              }

              branches.sort((a, b) {
                if (a.id == Constants.mainBranchId) return -1;
                if (b.id == Constants.mainBranchId) return 1;
                return a.branchName.compareTo(b.branchName);
              });

              savedId ??= BranchIdSp.getBranchId();
              if (savedId != null &&
                  branches.isNotEmpty &&
                  selectedBranch == null) {
                final branch = branches.firstWhere(
                  (b) => b.id == savedId,
                  orElse: () => branches.first,
                );
                selectedBranch = branch;
              }

              return Positioned(
                left: left,
                top: offset.dy + size.height + 5,
                width: overlayWidth,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header (Profile + Branch info)
                        Row(
                          children: [
                            CircleAvatar(radius: 24, backgroundImage: image),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${userProfile.userName} - ${userProfile.employeeNumber}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    branch.branchName,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(thickness: 1),

                        const SizedBox(height: 4),
                        const Text(
                          "My Account",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // _buildMenuItem(
                        //   Icons.email_outlined,
                        //   "Change Email",
                        // ),
                        _buildMenuItem(Icons.lock_outline, "Change Password"),
                        _buildMenuItem(
                          Icons.phone_android_outlined,
                          "Daftra Mobile Apps",
                        ),
                        _buildMenuItem(
                          Icons.autorenew_outlined,
                          "Renew Subscription",
                        ),

                        const SizedBox(height: 8),
                        const Text(
                          "My Branches",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          constraints: const BoxConstraints(
                            // limits max height to prevent overflow (adjust as needed)
                            maxHeight: 200,
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            radius: const Radius.circular(8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: branches.length,
                              itemBuilder: (context, index) {
                                final branch = branches[index];
                                final isSelected =
                                    selectedBranch?.id == branch.id;

                                return InkWell(
                                  onTap: () async {
                                    setState(() => selectedBranch = branch);
                                    await BranchIdSp.saveId(
                                      selectedBranch?.id ??
                                          Constants.mainBranchId,
                                    );
                                    await resource.update();
                                    _removeOverlay();
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 6),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blue.withValues(alpha: 0.08)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.blueAccent
                                            : Colors.grey.shade300,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isSelected
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_off_outlined,
                                          color: isSelected
                                              ? Colors.blueAccent
                                              : Colors.grey,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            branch.branchName,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: isSelected
                                                  ? Colors.blueAccent
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // const SizedBox(height: 12),
                        const Divider(thickness: 1),
                        // Logout button
                        CustomButton(
                          onPressed: logout,
                          loadingNotifier: loading,
                          buttonType: ButtonType.IconAndText,
                          iconAsset: 'assets/icons/logout_icon.png',
                          iconColor: Colors.black.withValues(alpha: 0.5),
                          textColor: Colors.black.withValues(alpha: 0.5),
                          text: 'Log out',
                          borderRadius: 12,
                          iconSize: 26,
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildMenuItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _iconKey,
      onTap: _toggleOverlay,
      child: Consumer<MmResourceProvider>(
        builder: (context, resource, child) {
          if (resource.isLoading) {
            return ThreeDotsLoader();
          } else {
            final userProfile = resource.getProfileByID(user!.uid);
            final branch = resource.getBranchByID(BranchIdSp.getBranchId());
            ImageProvider<Object>? image = userProfile.profileUrl.isEmpty
                ? const AssetImage('assets/images/userimg.png')
                : NetworkImage(userProfile.profileUrl);

            return Row(
              children: [
                CircleAvatar(radius: 20, backgroundImage: image),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userProfile.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      branch.branchName,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
