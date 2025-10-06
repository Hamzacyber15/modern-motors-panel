// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class MmEmployeeInfoTile extends StatefulWidget {
  final String employeeId;
  const MmEmployeeInfoTile({required this.employeeId, super.key});

  @override
  State<MmEmployeeInfoTile> createState() => _MmEmployeeInfoTileState();
}

class _MmEmployeeInfoTileState extends State<MmEmployeeInfoTile> {
  EmployeeModel? employee;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  void getData() {
    final provider = context.read<MmResourceProvider>();
    employee = provider.getEmployeeByID(widget.employeeId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        widget.employeeId == "dVaqI5nCKQZnlqhiqNQyXAERJbG3"
            ? "Admin"
            : employee!.name,
        style: TextStyle(
          fontSize: 11,
          color: Colors.blue.shade700,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
