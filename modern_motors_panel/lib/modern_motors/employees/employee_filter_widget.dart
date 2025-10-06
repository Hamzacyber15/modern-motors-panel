import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/hr_models/employees/employees_filter_model.dart';
import 'package:modern_motors_panel/modern_motors/employees/permissions_list.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

Widget employeeFilterWidget(
  BuildContext context,
  EmployeeFilterModel tempFilter,
  VoidCallback onApply,
) {
  final provider = context.read<MmResourceProvider>();
  final allPermissions = permissionLists.values.expand((list) => list).toList();
  return StatefulBuilder(
    builder: (context, setStateDialog) {
      return AlertDialog(
        elevation: 0.0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Apply Filters",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Status Filter
              DropdownButtonFormField<String>(
                value: tempFilter.status,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: ["active", "inactive"]
                    .map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (val) =>
                    setStateDialog(() => tempFilter.status = val),
              ),
              const SizedBox(height: 16),

              // 🔹 Branch Filter
              DropdownButtonFormField<String>(
                value:
                    provider.branchesList.any(
                      (b) => b.id == tempFilter.branchId,
                    )
                    ? tempFilter.branchId
                    : null,
                decoration: const InputDecoration(
                  labelText: "Branch",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: provider.branchesList
                    .map(
                      (branch) => DropdownMenuItem(
                        value: branch.id,
                        child: Text(branch.branchName),
                      ),
                    )
                    .toList(),
                onChanged: (val) =>
                    setStateDialog(() => tempFilter.branchId = val),
              ),
              const SizedBox(height: 16),

              // 🔹 Designation Filter
              DropdownButtonFormField<String>(
                value:
                    provider.designationsList.any(
                      (d) => d.id == tempFilter.designationId,
                    )
                    ? tempFilter.designationId
                    : null,
                decoration: const InputDecoration(
                  labelText: "Designation",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: provider.designationsList
                    .map(
                      (desig) => DropdownMenuItem(
                        value: desig.id,
                        child: Text(desig.name),
                      ),
                    )
                    .toList(),
                onChanged: (val) =>
                    setStateDialog(() => tempFilter.designationId = val),
              ),
              const SizedBox(height: 16),

              // 🔹 Permission Filter
              DropdownButtonFormField<String>(
                value: allPermissions.contains(tempFilter.permission)
                    ? tempFilter.permission
                    : null,
                decoration: const InputDecoration(
                  labelText: "Permission",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: allPermissions
                    .toSet()
                    .map(
                      // <-- duplicates remove
                      (perm) =>
                          DropdownMenuItem(value: perm, child: Text(perm)),
                    )
                    .toList(),
                onChanged: (val) =>
                    setStateDialog(() => tempFilter.permission = val),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onApply,
            child: const Text("Apply"),
          ),
        ],
      );
    },
  );
}
