import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/hr_models/designation_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';

class DesignationHelper {
  static Future<Map<String, dynamic>?> showDesignationListPopup(
    BuildContext context, {
    String? alreadyAssignedId,
  }) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('mmDesignation')
        .get();

    if (snapshot.docs.isEmpty) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Designations".tr()),
          content: Text("No designations found".tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK".tr()),
            ),
          ],
        ),
      );
      return null;
    }

    final designations = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'title': data['title'] ?? "Unknown".tr(),
        'arabicTitle': data['arabicTitle'] ?? "",
        'salary': data['salary'] ?? 0,
        'contractSalary': data['contractSalary'] ?? 0,
      };
    }).toList();

    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          String? assignedId = alreadyAssignedId;

          return Dialog(
            backgroundColor: AppTheme.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Assign Designations".tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: designations.length,
                        itemBuilder: (_, index) {
                          final d = designations[index];
                          final isAssigned = assignedId == d['id'];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.purple,
                                    child: Icon(
                                      Icons.work,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              d['title'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            10.w,
                                            if (d['arabicTitle'] != "")
                                              Text(
                                                d['arabicTitle'],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "Salary: ${d['salary']} OMR",
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        Text(
                                          "Contract Salary: ${d['contractSalary']} OMR",
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: isAssigned
                                        ? null
                                        : () {
                                            setState(() {
                                              assignedId = d['id'];
                                            });
                                            Navigator.pop(context, d);
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isAssigned
                                          ? Colors.grey
                                          : AppTheme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      isAssigned
                                          ? "Assigned".tr()
                                          : "Assign".tr(),
                                      style: TextStyle(
                                        color: AppTheme.whiteColor,
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
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 200,
                        child: CustomButton(
                          onPressed: () => Navigator.pop(context),
                          text: 'Close',
                          buttonType: ButtonType.Filled,
                          backgroundColor: AppTheme.blackColor,
                          textColor: AppTheme.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Future<void> assignDesignationToEmployees({
    required BuildContext context,
    required Set<String> selectedEmployeeIds,
    required VoidCallback onSuccess,
  }) async {
    if (selectedEmployeeIds.isEmpty) return;

    try {
      final firstEmployeeDoc = await FirebaseFirestore.instance
          .collection('mmEmployees')
          .doc(selectedEmployeeIds.first)
          .get();

      String? alreadyAssignedId;
      if (firstEmployeeDoc.exists) {
        alreadyAssignedId = firstEmployeeDoc
            .data()?['hrInfo']?['hrDesignationId'];
      }

      final selectedDesignation = await showDesignationListPopup(
        context,
        alreadyAssignedId: alreadyAssignedId,
      );

      if (selectedDesignation == null) return;

      final designationDoc = await FirebaseFirestore.instance
          .collection('mmDesignation')
          .doc(selectedDesignation['id'])
          .get();

      //final designationModel = DesignationModel.fromDoc(designationDoc);
      final designationModel = DesignationModel.fromSnapshot(designationDoc);

      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var empId in selectedEmployeeIds) {
        final empRef = FirebaseFirestore.instance
            .collection('mmEmployees')
            .doc(empId);

        final profileRef = FirebaseFirestore.instance
            .collection('mmProfile')
            .doc(empId);

        // final updateData = {
        //   "hrInfo": {
        //     "hrDesignationId": designationModel,
        //     "hrDesignationEnglish": designationModel.designation,
        //     "hrDesignationArabic": designationModel.arabicDesignation,
        //     "salary": designationModel.salary,
        //     "contractedSalary": designationModel.contractedSalary,
        //     "allotedAllowance": designationModel.allowances
        //         .map((e) => e.toMapForAdd())
        //         .toList(),
        //     "allotedLeave": designationModel.leavesTypeList
        //         .map((e) => e.toMapForAdd())
        //         .toList(),
        //   },
        //   "adminAccess": designationModel.adminAccess ?? [],
        // };

        // batch.set(empRef, updateData, SetOptions(merge: true));
        // batch.set(profileRef, updateData, SetOptions(merge: true));
      }

      await batch.commit();

      onSuccess();
    } catch (e, st) {
      debugPrint("❌ Error assigning designation: $e");
      print(st);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to assign designation")));
    }
  }
}
