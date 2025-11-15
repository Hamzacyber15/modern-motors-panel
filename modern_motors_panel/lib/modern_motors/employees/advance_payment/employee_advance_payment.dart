import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/hr_models/employees/advance_payment_employee_model.dart';
import 'package:modern_motors_panel/modern_motors/employees/advance_payment/add_edit_adv_emp_payment.dart';
import 'package:modern_motors_panel/modern_motors/employees/advance_payment/employee_advance_payment_card_list_view.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/pagination_widget.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';
import 'package:provider/provider.dart';

class EmployeeAdvancePaymentPage extends StatefulWidget {
  final void Function(String page)? onNavigate;

  const EmployeeAdvancePaymentPage({super.key, this.onNavigate});

  @override
  State<EmployeeAdvancePaymentPage> createState() => _AssetsState();
}

class _AssetsState extends State<EmployeeAdvancePaymentPage> {
  bool showCategoryList = true;
  bool isLoading = false;

  int currentPage = 0;
  int itemsPerPage = 10;
  Set<String> selectedPaymentId = {};
  List<AdvanceEmployeePaymentModel> payment = [];
  Set<String> selectedCategoryIds = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MmResourceProvider>(
      builder: (context, resource, child) {
        payment = resource.advanceEmployeePaymentList;
        if (resource.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            PageHeaderWidget(
              title: "Employee Advance Payment".tr(),
              buttonText: "Add Payment".tr(),
              subTitle: "Manage Employees Advance Payments".tr(),
              requiredPermission: 'Add Employee Advance Payment',
              buttonWidth: 0.26,
              selectedItems: selectedPaymentId.toList(),
              onCreate: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEditAdvEmpPay()),
                );
              },
              onDelete: () async {},
              onExelImport: () async {},
              onPdfImport: () async {},
            ),

            payment.isEmpty
                ? EmptyWidget(
                    text: "Advance Payment has not been added yet.".tr(),
                  )
                : Expanded(
                    child: EmployeeAdvancePaymentCardListView(
                      paymentList: payment,
                      selectedIds: selectedCategoryIds,
                    ),
                  ),
            Align(
              alignment: Alignment.topRight,
              child: PaginationWidget(
                currentPage: currentPage,
                totalItems: payment.length,
                itemsPerPage: itemsPerPage,
                onPageChanged: (newPage) {
                  setState(() {
                    currentPage = newPage;
                  });
                },
                onItemsPerPageChanged: (newLimit) {
                  setState(() {
                    itemsPerPage = newLimit;
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
