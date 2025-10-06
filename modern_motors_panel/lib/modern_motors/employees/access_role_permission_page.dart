import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/modern_motors/employees/permissions_list.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/search_box.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:provider/provider.dart';

class AccessRolePermissionPage extends StatefulWidget {
  final String employeeId;
  final VoidCallback? onBack;
  final List<String> initiallySelected;

  const AccessRolePermissionPage({
    super.key,
    required this.employeeId,
    this.onBack,
    this.initiallySelected = const [],
  });

  static Future<List<String>?> open(
    BuildContext context, {
    required String employeeId,
    List<String> selected = const [],
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AccessRolePermissionPage(
              employeeId: employeeId,
              initiallySelected: selected,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  State<AccessRolePermissionPage> createState() =>
      _AccessRolePermissionPageState();
}

class _AccessRolePermissionPageState extends State<AccessRolePermissionPage> {
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  Map<String, bool> selectedPermissions = {};
  bool showSearch = false;
  String searchQuery = "";
  bool isModified = false;

  @override
  void initState() {
    super.initState();

    for (var section in permissionLists.values) {
      for (var item in section) {
        selectedPermissions[item] = false;
      }
    }

    _loadExistingPermissions();
  }

  Future<void> _loadExistingPermissions() async {
    catLoader.value = true;

    try {
      // ✅ Firestore se fetch karo
      final doc = await FirebaseFirestore.instance
          .collection("mmEmployees")
          .doc(widget.employeeId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data.containsKey("profileAccessKey")) {
          List<dynamic> savedPermissions = data["profileAccessKey"];
          for (var item in savedPermissions) {
            if (selectedPermissions.containsKey(item)) {
              selectedPermissions[item] = true;
            }
          }
        }
      } else {
        // Agar document nahi mila to initiallySelected ka use karo
        for (var item in widget.initiallySelected) {
          if (selectedPermissions.containsKey(item)) {
            selectedPermissions[item] = true;
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading permissions: $e");
    }

    catLoader.value = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PageHeaderWidget(
              title: 'Profile Permission Access',
              buttonText: isModified ? 'Update Permission' : 'Add Permission',
              subTitle: isModified ? 'Edit Permissions' : 'Assign Permissions',
              onCreateIcon: 'assets/images/back.png',
              selectedItems: [],
              buttonWidth: 0.34,
              onCreate: () async {
                final selected = _getSelectedPermissions();

                final batch = FirebaseFirestore.instance.batch();

                final empRef = FirebaseFirestore.instance
                    .collection("mmEmployees")
                    .doc(widget.employeeId);
                final profileRef = FirebaseFirestore.instance
                    .collection("mmProfile")
                    .doc(widget.employeeId);

                batch.set(empRef, {
                  "profileAccessKey": selected,
                }, SetOptions(merge: true));
                batch.set(profileRef, {
                  "profileAccessKey": selected,
                }, SetOptions(merge: true));

                await batch.commit();

                Navigator.pop(context, selected);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: OverlayLoader(
              loader: catLoader.value,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.whiteColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.borderColor, width: 0.6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          top: 20,
                          bottom: 10,
                          right: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Permissions',
                              style:
                                  AppTheme.getCurrentTheme(
                                    false,
                                    connectionStatus,
                                  ).textTheme.bodyMedium!.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (showSearch) {
                                      searchQuery = "";
                                      showSearch = false;
                                    } else {
                                      showSearch = true;
                                    }
                                  });
                                },
                                icon: showSearch
                                    ? const Icon(
                                        Icons.close,
                                        size: 24,
                                        color: Colors.redAccent,
                                      )
                                    : Image.asset(
                                        'assets/images/search.png',
                                        height: 24,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (showSearch)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SearchBox(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value.toLowerCase();
                              });
                            },
                            hintText: 'Search Permission...',
                          ),
                        ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: permissionLists.entries.map((entry) {
                            final title = entry.key;
                            final permissions = entry.value;

                            final filtered = permissions
                                .where(
                                  (p) => p.toLowerCase().contains(searchQuery),
                                )
                                .toList();

                            if (filtered.isEmpty) return const SizedBox();

                            final half = (filtered.length / 2).ceil();
                            final left = filtered.sublist(0, half);
                            final right = filtered.sublist(half);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.grey.shade100,
                                  margin: const EdgeInsets.only(
                                    top: 16,
                                    bottom: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        '(Active: ${_countActivePermissions(permissions)}/${permissions.length})',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: _buildCheckboxList(left)),
                                    const SizedBox(width: 20),
                                    Expanded(child: _buildCheckboxList(right)),
                                  ],
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxList(List<String> items) {
    return Column(
      children: items.map((item) {
        return CheckboxListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            item,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          value: selectedPermissions[item],
          onChanged: (val) {
            setState(() {
              selectedPermissions[item] = val ?? false;
              isModified = true;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        );
      }).toList(),
    );
  }

  int _countActivePermissions(List<String> permissions) {
    return permissions.where((p) => selectedPermissions[p] == true).length;
  }

  List<String> _getSelectedPermissions() {
    return selectedPermissions.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }
}
