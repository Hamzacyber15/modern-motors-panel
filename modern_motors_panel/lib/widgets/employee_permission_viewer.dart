import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/widgets/employee_branch_drop_down';

class EmployeePermissionsViewer extends StatefulWidget {
  final EmployeeModel employee;
  final String title;

  const EmployeePermissionsViewer({
    super.key,
    required this.employee,
    this.title = "Employee Permissions",
  });

  @override
  State<EmployeePermissionsViewer> createState() =>
      _EmployeePermissionsViewerState();
}

class _EmployeePermissionsViewerState extends State<EmployeePermissionsViewer> {
  String? selectedBranchId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: const Text("View Permissions"),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return StatefulBuilder(
              builder: (context, setDialogState) {
                final branchPermissions = widget.employee.permissions ?? [];
                final selectedPerms = selectedBranchId == null
                    ? null
                    : branchPermissions.firstWhere(
                        (p) => p.branchId == selectedBranchId,
                        orElse: () => Permissions(branchId: "", permission: []),
                      );

                return AlertDialog(
                  backgroundColor: Colors.white,
                  elevation: 2.0,
                  title: Row(
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 180,
                        child: EmployeeBranchDropdown(
                          employee: widget.employee,
                          onBranchSelected: (branchId) {
                            setDialogState(() {
                              selectedBranchId = branchId;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: selectedBranchId == null
                        ? const Text(
                            "Please select a branch to view permissions",
                            style: TextStyle(color: Colors.grey),
                          )
                        : (selectedPerms?.permission.isEmpty ?? true)
                        ? const Text(
                            "No permissions assigned for this branch",
                            style: TextStyle(color: Colors.grey),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: selectedPerms!.permission
                                .map(
                                  (perm) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.blue),
                                    ),
                                    child: Text(
                                      perm,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Close",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
