import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/hr_models/employees/commissions_model/employees_commision_model.dart';
import 'package:modern_motors_panel/model/hr_models/employees/emlpoyee_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dots_loader.dart';
import 'package:modern_motors_panel/modern_motors/widgets/two_col_widget.dart';

class EmployeeCommissionWidget extends StatelessWidget {
  final EmployeeCommissionModel model;
  final VoidCallback? onTap;
  const EmployeeCommissionWidget({super.key, required this.model, this.onTap});

  Future<EmployeeModel?> _loadEmployee(String? id) async {
    if (id == null || id.isEmpty) return null;

    final snap = await FirebaseFirestore.instance
        .collection('employees')
        .doc(id)
        .get();

    if (!snap.exists) return null;

    return EmployeeModel.fromMap(snap); // ✅ pass DocumentSnapshot directly
  }

  @override
  Widget build(BuildContext context) {
    final isPercent = !(model.isAmount);
    final valueText = isPercent
        ? '${(model.value).toStringAsFixed(2)} %'
        : (model.value).toStringAsFixed(2);

    return FutureBuilder<EmployeeModel?>(
      future: _loadEmployee(model.employeeId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ThreeDotsLoader(),
          );
        }

        final empName = snap.data?.name ?? 'Unknown Employee';
        final leftLabel = '$empName (${isPercent ? 'Percent' : 'Amount'})';
        return InkWell(onTap: onTap, child: twoCol(leftLabel, valueText));
      },
    );
  }
}
