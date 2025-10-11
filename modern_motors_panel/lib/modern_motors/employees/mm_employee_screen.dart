import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/modern_motors/employees/access_role_permission_page.dart';
import 'package:modern_motors_panel/modern_motors/employees/profile_detail.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/employee_branch_drop_down';
import 'package:provider/provider.dart';

class MmEmployeeScreen extends StatefulWidget {
  final EmployeeModel employee;
  final String roleName;
  final String branchName;
  final String nationalityName;

  const MmEmployeeScreen({
    super.key,
    required this.employee,
    required this.roleName,
    required this.branchName,
    required this.nationalityName,
  });

  @override
  State<MmEmployeeScreen> createState() => _EmployeeProfileDetailScreenState();
}

class _EmployeeProfileDetailScreenState extends State<MmEmployeeScreen> {
  late EmployeeModel employee;
  bool isLoading = false;
  String? selectedBranchId;

  @override
  void initState() {
    super.initState();
    employee = widget.employee;
    debugPrint("Employee loaded: $employee");
    if (employee.profileAccessKey != null &&
        employee.profileAccessKey!.isNotEmpty) {
      debugPrint(
        "Employee already has permissions: ${employee.profileAccessKey}",
      );
    }

    _reloadEmployeeData();
  }

  Future<void> _reloadEmployeeData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('mmEmployees')
          .doc(employee.id)
          .get();
      if (snapshot.exists) {
        // final data = snapshot.data() as Map<String, dynamic>? ?? {};
        EmployeeModel employeeModel = EmployeeModel.fromMap(snapshot);
        employee.permissions = employeeModel.permissions;
        setState(() {});
        // final savedPermissions =
        //     (data['profileAccessKey'] as List<dynamic>?)
        //         ?.map((e) => e.toString())
        //         .toList() ??
        //     <String>[];
        // setState(() => employee.profileAccessKey = savedPermissions);
      }
    } catch (e) {
      debugPrint('Error reloading employee: $e');
    }
  }

  // Future<void> _reloadEmployeeData() async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('mmEmployees')
  //         .doc(employee.id)
  //         .get();
  //     if (snapshot.exists) {
  //       final data = snapshot.data() as Map<String, dynamic>? ?? {};
  //       final savedPermissions =
  //           (data['profileAccessKey'] as List<dynamic>?)
  //               ?.map((e) => e.toString())
  //               .toList() ??
  //           <String>[];
  //       setState(() => employee.profileAccessKey = savedPermissions);
  //     }
  //   } catch (e) {
  //     debugPrint('Error reloading employee: $e');
  //   }
  // }

  String truncateAtWord(String text, int maxLength) {
    if (text.length <= maxLength) return text;

    final words = text.split(' ');
    String truncated = '';

    for (final word in words) {
      if ((truncated + (truncated.isEmpty ? '' : ' ') + word).length >
          maxLength) {
        break;
      }
      truncated += (truncated.isEmpty ? '' : ' ') + word;
    }

    return '$truncated...';
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: AppBar(
        title: Text(
          'Profile Detail',
          style: AppTheme.getCurrentTheme(
            false,
            connectionStatus,
          ).textTheme.headlineLarge!.copyWith(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    (employee.profileUrl != null &&
                                        employee.profileUrl!.isNotEmpty)
                                    ? NetworkImage(employee.profileUrl!)
                                    : const AssetImage(
                                        "assets/images/img_2.png",
                                      ),
                              ),
                              8.w,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    truncateAtWord(
                                      employee.name,
                                      15,
                                    ), // max 20 chars word-wise
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  6.h,
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      widget.roleName,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            onPressed:
                                (employee.permissions == null &&
                                    employee.profileAccessKey!.isEmpty)
                                ? null
                                : () async {
                                    final updatedPermissions =
                                        await AccessRolePermissionPage.open(
                                          context,
                                          employeeId: employee.id,
                                          employeeModel: employee,
                                          selected:
                                              employee.profileAccessKey ?? [],
                                        );

                                    if (updatedPermissions != null) {
                                      setState(() {
                                        employee.profileAccessKey =
                                            updatedPermissions;
                                      });

                                      await _reloadEmployeeData();
                                    }
                                  },

                            child: Text(
                              (employee.permissions != null &&
                                      employee.permissions!.isNotEmpty)
                                  ? "Assigned"
                                  : "Assign Permission",
                              style: TextStyle(
                                color: AppTheme.whiteColor,
                                //  (employee.profileAccessKey != null &&
                                //         employee.profileAccessKey!.isNotEmpty)
                                //     ? AppTheme.whiteColor
                                //     : AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _InfoRow(
                            icon: Icons.badge,
                            label: "Employee ID",
                            value: employee.employeeId ?? "N/A",
                          ),
                          12.h,
                          _InfoRow(
                            icon: Icons.calendar_today,
                            label: "Date Of Birth",
                            value: employee.dob != null
                                ? "${employee.dob!.day}-${employee.dob!.month}-${employee.dob!.year}"
                                : "N/A",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.w,
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProfileDetail(headerTitle: "Basic Information"),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Wrap(
                            runSpacing: 12,
                            spacing: 40,
                            children: [
                              _BasicInfo(
                                label: "Phone",
                                value: employee.contactNumber,
                              ),
                              _BasicInfo(label: "Email", value: employee.email),
                              _BasicInfo(label: "Gender", value: ""),
                              if (widget.branchName.isNotEmpty)
                                _BasicInfo(
                                  label: "Branch",
                                  value: widget.branchName,
                                ),
                              _BasicInfo(
                                label: "Nationality",
                                value: widget.nationalityName,
                              ),
                              _BasicInfo(
                                label: "Address",
                                value:
                                    "${employee.streetAddress1}, ${employee.city}, ${employee.state},",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.h,
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProfileDetail(headerTitle: "Emergency Contact"),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Wrap(
                            runSpacing: 12,
                            spacing: 40,
                            children: [
                              _BasicInfo(
                                label: "Phone",
                                value: employee.emergencyContact,
                              ),
                              _BasicInfo(
                                label: "Name",
                                value: employee.emergencyName,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.h,
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Assigned Permissions',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: context.width * 0.2,
                                child: EmployeeBranchDropdown(
                                  employee: employee,
                                  onBranchSelected: (branchId) {
                                    selectedBranchId = branchId;
                                    setState(() {});
                                    debugPrint("Selected branchId: $branchId");
                                  },
                                ),
                              ),
                              if (employee.permissions != null &&
                                  employee.permissions!.isNotEmpty)
                                IconButton(
                                  icon: Image.asset(
                                    'assets/icons/edit_icon.png',
                                    height: 18,
                                  ),
                                  tooltip: "Edit Permissions",
                                  onPressed: () async {
                                    // final updatedPermissions =
                                    await AccessRolePermissionPage.open(
                                      context,
                                      employeeId: employee.id,
                                      employeeModel: employee,
                                      selected: employee.profileAccessKey ?? [],
                                    );
                                    await _reloadEmployeeData();

                                    // if (updatedPermissions != null) {
                                    //   setState(() {
                                    //     employee.permissions =
                                    //         updatedPermissions;
                                    //   });
                                    //   await _reloadEmployeeData();
                                    // }
                                  },
                                ),

                              // if (employee.profileAccessKey != null &&
                              //     employee.profileAccessKey!.isNotEmpty)
                              //   IconButton(
                              //     icon: Image.asset(
                              //       'assets/images/edit_icon.png',
                              //       height: 18,
                              //     ),
                              //     tooltip: "Edit Permissions",
                              //     onPressed: () async {
                              //       final updatedPermissions =
                              //           await AccessRolePermissionPage.open(
                              //             context,
                              //             employeeId: employee.id,
                              //             selected:
                              //                 employee.profileAccessKey ?? [],
                              //           );

                              //       if (updatedPermissions != null) {
                              //         setState(() {
                              //           employee.profileAccessKey =
                              //               updatedPermissions;
                              //         });
                              //         await _reloadEmployeeData();
                              //       }
                              //     },
                              //   ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Builder(
                            builder: (context) {
                              // selected branch ka permissions nikaalna
                              final branchPermissions =
                                  employee.permissions
                                      ?.firstWhere(
                                        (p) => p.branchId == selectedBranchId,
                                        orElse: () => Permissions(
                                          branchId: selectedBranchId ?? '',
                                          permission: [],
                                        ),
                                      )
                                      .permission ??
                                  [];

                              if (branchPermissions.isEmpty) {
                                return const Text(
                                  "No permissions assigned",
                                  style: TextStyle(color: Colors.grey),
                                );
                              }

                              return Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: branchPermissions
                                    .map(
                                      (perm) => Chip(
                                        label: Text(perm),
                                        backgroundColor: Colors.blue.shade50,
                                        labelStyle: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.all(16.0),
                        //   child:
                        //       employee.profileAccessKey != null &&
                        //           employee.profileAccessKey!.isNotEmpty
                        //       ? Wrap(
                        //           spacing: 8,
                        //           runSpacing: 8,
                        //           children: employee.profileAccessKey!
                        //               .map(
                        //                 (perm) => Chip(
                        //                   label: Text(perm),
                        //                   backgroundColor: Colors.blue.shade50,
                        //                   labelStyle: const TextStyle(
                        //                     color: Colors.black87,
                        //                     fontWeight: FontWeight.w500,
                        //                   ),
                        //                 ),
                        //               )
                        //               .toList(),
                        //         )
                        //       : const Text(
                        //           "No permissions assigned",
                        //           style: TextStyle(color: Colors.grey),
                        //         ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 10),
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
        Expanded(child: Text(value)),
      ],
    );
  }
}

class _BasicInfo extends StatelessWidget {
  final String label;
  final String? value;

  const _BasicInfo({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value ?? "N/A")),
        ],
      ),
    );
  }
}
