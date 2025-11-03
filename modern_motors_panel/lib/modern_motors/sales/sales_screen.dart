// ignore_for_file: deprecated_member_use
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/model/admin_model/brands_model.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/payment_data.dart';
import 'package:modern_motors_panel/model/product_models/product_category_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/product_models/product_sub_category_model.dart';
import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
import 'package:modern_motors_panel/modern_motors/invoices/invoice_logs_timeline.dart';
import 'package:modern_motors_panel/modern_motors/products/DataTableProductCell.dart';
import 'package:modern_motors_panel/modern_motors/products/product_details_dialogue.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/services_maintenance/create_booking_main_page.dart';
import 'package:modern_motors_panel/modern_motors/trucks/manage_trucks_page.dart';
import 'package:modern_motors_panel/modern_motors/widgets/customer_name_tile.dart';
import 'package:modern_motors_panel/modern_motors/widgets/employees/mm_employee_info_tile.dart';
import 'package:modern_motors_panel/modern_motors/widgets/image_gallery_dialogue.dart';
import 'package:modern_motors_panel/modern_motors/widgets/payment_details_dialog.dart';
import 'package:modern_motors_panel/modern_motors/widgets/sales_invoice_dropdown_view.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

import 'sale_payment_page.dart';

// Mock models - replace with your actual models
// class SaleModel {
//   final String? id;
//   final String? saleNumber;
//   final String? customerName;
//   final String? categoryId;
//   final String? subCategoryId;
//   final String? brandId;
//   final double? totalAmount;
//   final double? paidAmount;
//   final double? remainingAmount;
//   final String? status;
//   final DateTime? saleDate;
//   final String? createdBy;
//   final String? description;
//   final String? paymentMethod;
//   final int? itemCount;

//   SaleModel({
//     this.id,
//     this.saleNumber,
//     this.customerName,
//     this.categoryId,
//     this.subCategoryId,
//     this.brandId,
//     this.totalAmount,
//     this.paidAmount,
//     this.remainingAmount,
//     this.status,
//     this.saleDate,
//     this.createdBy,
//     this.description,
//     this.paymentMethod,
//     this.itemCount,
//   });
//   factory SaleModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;

//     return SaleModel(
//       id: doc.id,
//       batchAllocations: (data['batchAllocations'] as List<dynamic>?)
//               ?.map((e) => BatchAllocation.fromMap(e as Map<String, dynamic>))
//               .toList() ??
//           [],
//       batchesUsed: (data['batchesUsed'] as List<dynamic>?)
//               ?.map((e) => BatchUsed.fromMap(e as Map<String, dynamic>))
//               .toList() ??
//           [],
//       createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
//       customerName: data['customerName'] as String? ?? '',
//       items: (data['items'] as List<dynamic>?)
//               ?.map((e) => SaleItem.fromMap(e as Map<String, dynamic>))
//               .toList() ??
//           [],
//       productsUpdated: (data['productsUpdated'] as List<dynamic>?)
//               ?.map((e) => ProductModel.fromMap1(e as Map<String, dynamic>))
//               .toList() ??
//           [],
//       invoiceId: data['invoiceId'] as String? ?? '',
//     );
//   }
//}

// Enum for dropdown actions
enum SaleAction { view, edit, duplicate, payment, clone, refund, delete, logs }

// Filter class for managing all filter states
class SalesFilter {
  String? categoryId;
  String? subCategoryId;
  String? brandId;
  String? customerId;
  DateTimeRange? dateRange;
  RangeValues? amountRange;
  String? status;
  String? paymentMethod;
  String? createdBy;
  String? searchQuery;
  bool? hasDeposit;
  bool? isPaid;
  String? invoiceStatus;

  SalesFilter({
    this.categoryId,
    this.subCategoryId,
    this.brandId,
    this.customerId,
    this.dateRange,
    this.amountRange,
    this.status,
    this.paymentMethod,
    this.createdBy,
    this.searchQuery,
    this.hasDeposit,
    this.isPaid,
    this.invoiceStatus,
  });

  bool get hasActiveFilters {
    return categoryId != null ||
        subCategoryId != null ||
        brandId != null ||
        customerId != null ||
        dateRange != null ||
        amountRange != null ||
        status != null ||
        paymentMethod != null ||
        createdBy != null ||
        hasDeposit != null ||
        isPaid != null ||
        invoiceStatus != null ||
        (searchQuery?.isNotEmpty ?? false);
  }

  void clear() {
    categoryId = null;
    subCategoryId = null;
    brandId = null;
    customerId = null;
    dateRange = null;
    amountRange = null;
    status = null;
    paymentMethod = null;
    createdBy = null;
    searchQuery = null;
    hasDeposit = null;
    isPaid = null;
    invoiceStatus = null;
  }

  SalesFilter copyWith({
    String? categoryId,
    String? subCategoryId,
    String? brandId,
    String? customerId,
    DateTimeRange? dateRange,
    RangeValues? amountRange,
    String? status,
    String? paymentMethod,
    String? createdBy,
    String? searchQuery,
    bool? hasDeposit,
    bool? isPaid,
    String? invoiceStatus,
  }) {
    return SalesFilter(
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      brandId: brandId ?? this.brandId,
      customerId: customerId ?? this.customerId,
      dateRange: dateRange ?? this.dateRange,
      amountRange: amountRange ?? this.amountRange,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdBy: createdBy ?? this.createdBy,
      searchQuery: searchQuery ?? this.searchQuery,
      hasDeposit: hasDeposit ?? this.hasDeposit,
      isPaid: isPaid ?? this.isPaid,
      invoiceStatus: invoiceStatus ?? this.invoiceStatus,
    );
  }
}

class SaleCard extends StatelessWidget {
  final SaleModel sale;
  final String type;
  final ProductCategoryModel category;
  final ProductSubCategoryModel subCategory;
  final BrandModel brand;
  final bool isSelected;
  final VoidCallback? onTap;
  final Function(SaleAction)? onActionSelected;
  final Function(bool?)? onSelectChanged;

  const SaleCard({
    super.key,
    required this.sale,
    required this.category,
    required this.type,
    required this.subCategory,
    required this.brand,
    this.isSelected = false,
    this.onTap,
    this.onActionSelected,
    this.onSelectChanged,
  });

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Container(
      height: 105,
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Row(
            children: [
              // Checkbox
              if (onSelectChanged != null) ...[
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: onSelectChanged,
                    activeColor: Theme.of(context).primaryColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Sale Number Badge
              sale.status == "estimate"
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.7),
                            Theme.of(context).primaryColor.withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${"Est"}-${sale.invoice}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : sale.status == "estimateDraft"
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).secondaryHeaderColor,
                            Theme.of(context).primaryColor.withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${"EDraft"}-${sale.invoice}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: sale.status == "draft"
                          ? Text(
                              '${"Draft"}-${sale.invoice}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Text(
                              '${"MM"}-${sale.invoice}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),

              const SizedBox(width: 20),

              // Sale Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey.shade100,
                ),
                child: Icon(
                  Icons.point_of_sale,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              // Customer Name & Description
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomerNameTile(customerId: sale.customerName),
                    const SizedBox(height: 2),
                    // Text(
                    //   sale.paymentMethod,
                    //   style: TextStyle(
                    //     fontSize: 11,
                    //     color: Colors.grey.shade600,
                    //     fontStyle: FontStyle.italic,
                    //   ),
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    // const SizedBox(height: 2),
                    MmEmployeeInfoTile(employeeId: sale.createBy),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: sale.items.length > 1
                      ? () => ProductDetailsDialog.show(context, sale)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                  hoverColor: Colors.grey.withOpacity(0.05),
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.12),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Product Icon
                        // Container(
                        //   width: 32,
                        //   height: 32,
                        //   decoration: BoxDecoration(
                        //     gradient: const LinearGradient(
                        //       colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        //       begin: Alignment.topLeft,
                        //       end: Alignment.bottomRight,
                        //     ),
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: const Icon(
                        //     Icons.inventory_2_rounded,
                        //     color: Colors.white,
                        //     size: 16,
                        //   ),
                        // ),
                        const SizedBox(width: 8),

                        // Main Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Product Details
                              if (sale.items.isNotEmpty)
                                Expanded(
                                  child: DataTableProductCell(
                                    productId: sale.items[0].productId,
                                    // saleDetails: sale,
                                    saleItem: sale.items[0],
                                  ),
                                ),
                              _buildPaymentDepositSummary(sale),

                              // Bottom Row
                              Row(
                                children: [
                                  // More Items Badge
                                  if (sale.items.length > 1) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF4F46E5,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: const Color(
                                            0xFF4F46E5,
                                          ).withOpacity(0.3),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.add_rounded,
                                            size: 10,
                                            color: Color(0xFF4F46E5),
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            '${sale.items.length - 1}',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF4F46E5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],

                                  const Spacer(),

                                  // Sale Summary - Compact
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF1F2937),
                                          Color(0xFF374151),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Item: ${sale.items.length}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Container(
                                          width: 1,
                                          height: 10,
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          Constants.formatPrice(
                                            sale.items.fold(
                                              0,
                                              (sum, invoice) =>
                                                  sum! + invoice.totalPrice,
                                            ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Amount Info
              // Expanded(
              //   flex: 1,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         'OMR ${sale.totalRevenue.toStringAsFixed(2) ?? '0.00'}',
              //         style: const TextStyle(
              //           fontSize: 13,
              //           fontWeight: FontWeight.w600,
              //           color: Color(0xFF059669),
              //         ),
              //       ),
              //       // const SizedBox(height: 2),
              //       // if (sale.totalRevenue != null && sale.totalRevenue > 0)
              //       //   Text(
              //       //     'Due: \$${sale.totalRevenue.toStringAsFixed(2)}',
              //       //     style: TextStyle(
              //       //       fontSize: 11,
              //       //       color: Colors.orange.shade700,
              //       //       fontWeight: FontWeight.w500,
              //       //     ),
              //       //   ),
              //       const SizedBox(height: 2),
              //       Text(
              //         sale.paymentMethod ?? 'Cash',
              //         style: TextStyle(
              //           fontSize: 10,
              //           color: Colors.grey.shade500,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Total Revenue
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       sale.paymentData.remainingAmount.toStringAsFixed(2),
                    //       style: const TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w600,
                    //         color: Color(0xFF059669),
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 2,
                    //     ),
                    //   ],
                    // ),

                    // Payment Status with Deposit Indicator (NEW)
                    if (sale.deposit.requireDeposit)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              size: 10,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'Deposit',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 2),

                    // Payment Method with Paid Status (NEW)

                    // Remaining Amount if not fully paid (NEW)
                    // if (sale.paymentData.isAlreadyPaid &&
                    //     sale.paymentData.remainingAmount > 0)
                    Text(
                      'Disc: ${sale.discount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.redColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Total: ${sale.total!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Paid: ${sale.paymentData.totalPaid.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.greenColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Due: ${sale.paymentData.remainingAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.redColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        sale.status, //.isAlreadyPaid ? "paid" : "pending",
                        style: TextStyle(
                          color: _getStatusColor(),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Payment Status
              // Expanded(
              //   flex: 1,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         'OMR ${sale.totalRevenue.toStringAsFixed(2)}',
              //         style: const TextStyle(
              //           fontSize: 13,
              //           fontWeight: FontWeight.w600,
              //           color: Color(0xFF059669),
              //         ),
              //       ),
              //       const SizedBox(height: 2),
              //       Container(
              //         padding: const EdgeInsets.symmetric(
              //             horizontal: 4, vertical: 1),
              //         decoration: BoxDecoration(
              //           color: _getStatusColor().withOpacity(0.1),
              //           borderRadius: BorderRadius.circular(3),
              //         ),
              //         child: Text(
              //           (sale.status).toUpperCase(),
              //           style: TextStyle(
              //             color: _getStatusColor(),
              //             fontSize: 10,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //const SizedBox(height: 4),
                    // Total Paid Amount (NEW)
                    if (sale.paymentData.isAlreadyPaid)
                      IconButton(
                        icon: Icon(
                          Icons.payment,
                          size: 16,
                          color: Colors.green.shade600,
                        ),
                        onPressed: () => PaymentDetailsDialog.show(
                          context,
                          sale.paymentData,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                        tooltip: 'View payment details',
                      ),
                    // Batch Allocation Indicator (NEW)
                    if (sale.batchAllocations.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inventory,
                              size: 12,
                              color: Colors.purple,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'Batch: ${sale.batchAllocations.length}',
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            if (sale.url != null && sale.url!.isNotEmpty)
                              IconButton(
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => ImageGalleryDialog(
                                    imageUrls: sale.url!,
                                    thumbnailSize: 40.0,
                                    spacing: 6.0,
                                  ),
                                ),
                                icon: Icon(Icons.preview_sharp),
                              ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 2),
                    Text(
                      'Paid: ${sale.paymentData.totalPaid.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: sale.paymentData.isAlreadyPaid
                            ? Colors.green.shade700
                            : Colors.blue.shade700,
                      ),
                    ),

                    const SizedBox(height: 4),
                    Text(
                      getPaymentMethodNames(sale.paymentData),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Status Badge

                    // Tax Amount (NEW)
                    // if (sale.taxAmount > 0)
                    //   Text(
                    //     'Tax: OMR ${sale.taxAmount.toStringAsFixed(2)}',
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //       color: Colors.grey.shade600,
                    //     ),
                    //   ),
                  ],
                ),
              ),

              // Sale Date & Created By
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MMM dd, yy').format(sale.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      DateFormat('yyyy-MM-dd hh:mm a').format(sale.createdAt),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    // const SizedBox(height: 1),
                    // Text(
                    //   'By: ${sale.createdBy}',
                    //   style: TextStyle(
                    //     fontSize: 10,
                    //     color: Colors.grey.shade500,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Action Dropdown Menu
              Consumer<MmResourceProvider>(
                builder: (context, resource, child) {
                  final permissions =
                      resource.employeeModel?.profileAccessKey ?? [];
                  String edit = type == 'estimation'
                      ? 'Edit Estimates'
                      : 'Edit Invoices';
                  String refund = 'Process Refund';
                  String payment = 'Add Payment';
                  String delete = type == 'estimation'
                      ? 'Delete Estimates'
                      : 'Delete Invoices';
                  return PopupMenuButton<SaleAction>(
                    onSelected: (SaleAction action) {
                      if (onActionSelected != null) {
                        onActionSelected!(action);
                      }
                    },
                    icon: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 0),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<SaleAction>(
                        value: SaleAction.view,
                        child: Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 18,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Text('View Invoice'),
                          ],
                        ),
                      ),
                      if (permissions.contains(payment) ||
                          user!.uid == Constants.adminId)
                        PopupMenuItem<SaleAction>(
                          value: SaleAction.payment,
                          child: Row(
                            children: [
                              Icon(
                                Icons.payment,
                                size: 18,
                                color: Colors.purple,
                              ),
                              const SizedBox(width: 8),
                              Text('Add Payment'),
                            ],
                          ),
                        ),
                      PopupMenuItem<SaleAction>(
                        value: SaleAction.clone,
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_card_sharp,
                              size: 18,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Text('Clone'),
                          ],
                        ),
                      ),
                      if (permissions.contains(edit) ||
                          user!.uid == Constants.adminId)
                        PopupMenuItem<SaleAction>(
                          value: SaleAction.edit,
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18, color: Colors.orange),
                              const SizedBox(width: 8),
                              Text('Edit Sale'),
                            ],
                          ),
                        ),
                      if (permissions.contains(refund) ||
                          user!.uid == Constants.adminId) ...[
                        PopupMenuItem<SaleAction>(
                          value: SaleAction.refund,
                          child: Row(
                            children: [
                              Icon(Icons.undo, size: 18, color: Colors.amber),
                              const SizedBox(width: 8),
                              Text('Process Refund'),
                            ],
                          ),
                        ),
                      ],
                      if (permissions.contains(delete) ||
                          user!.uid == Constants.adminId) ...[
                        const PopupMenuDivider(),
                        PopupMenuItem<SaleAction>(
                          value: SaleAction.delete,
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 16, color: Colors.red),
                              const SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (permissions.contains(delete) ||
                          user!.uid == Constants.adminId) ...[
                        const PopupMenuDivider(),
                        PopupMenuItem<SaleAction>(
                          value: SaleAction.logs,
                          child: Row(
                            children: [
                              Icon(
                                Icons.timeline,
                                size: 16,
                                color: Colors.deepOrange,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'View Logs',
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getPaymentMethodNames(PaymentData paymentData) {
    if (!paymentData.isAlreadyPaid) {
      return ''; // Return empty string if not paid
    }

    if (paymentData.paymentMethods.isEmpty) {
      return 'No payment methods'; // Fallback if no methods
    }

    // Extract method names and join with commas
    return paymentData.paymentMethods
        .map((method) => method.methodName)
        .where((name) => name.isNotEmpty) // Filter out empty names
        .join(', ');
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return Icons.money;
      case 'card':
        return Icons.credit_card;
      case 'transfer':
        return Icons.account_balance;
      case 'cheque':
        return Icons.description;
      case 'multiple':
        return Icons.payment;
      default:
        return Icons.payment;
    }
  }

  Color _getStatusColor() {
    switch (sale.status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.red;
      case 'cancelled':
        return Colors.orange;
      case 'refunded':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

Widget _buildPaymentDepositSummary(SaleModel sale) {
  if (!sale.deposit.requireDeposit && sale.paymentData.isAlreadyPaid) {
    return const SizedBox.shrink();
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 4),
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (sale.deposit.requireDeposit)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_balance_wallet, size: 10, color: Colors.blue),
              const SizedBox(width: 2),
              Text(
                'Dep: OMR ${sale.deposit.depositAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        if (!sale.paymentData.isAlreadyPaid)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.pending_actions, size: 10, color: Colors.orange),
              const SizedBox(width: 2),
              Text(
                'Due: OMR ${sale.paymentData.remainingAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
      ],
    ),
  );
}

// Filter Dialog
// Updated SalesFilterDialog class with all the requested filters
class SalesFilterDialog extends StatefulWidget {
  final SalesFilter currentFilter;
  final List<ProductCategoryModel> categories;
  final List<ProductSubCategoryModel> subCategories;
  final List<BrandModel> brands;
  final List<String> createdByUsers;
  final List<CustomerModel> customers;
  final Function(SalesFilter) onApplyFilter;

  const SalesFilterDialog({
    super.key,
    required this.currentFilter,
    required this.categories,
    required this.subCategories,
    required this.brands,
    required this.createdByUsers,
    required this.customers,
    required this.onApplyFilter,
  });

  @override
  State<SalesFilterDialog> createState() => _SalesFilterDialogState();
}

class _SalesFilterDialogState extends State<SalesFilterDialog> {
  late SalesFilter _filter;
  final TextEditingController _customerSearchController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<CustomerModel> _filteredCustomers = [];
  CustomerModel? _selectedCustomer;

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter.copyWith();
    _searchController.text = widget.currentFilter.searchQuery ?? '';
    _filteredCustomers = widget.customers;

    if (_filter.customerId != null) {
      _selectedCustomer = widget.customers.firstWhere(
        (customer) => customer.id == _filter.customerId,
      );
      _customerSearchController.text = _selectedCustomer?.customerName ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Sales',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Colors.grey.shade600),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Filter Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Search Query
                    _buildFilterSection(
                      title: 'Search Query',
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search in sales...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          _filter = _filter.copyWith(
                            searchQuery: value.isEmpty ? null : value,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Customer Filter with Searchable Dropdown
                    _buildFilterSection(
                      title: 'Customer',
                      child: Column(
                        children: [
                          TextField(
                            controller: _customerSearchController,
                            decoration: InputDecoration(
                              hintText: 'Type customer name...',
                              prefixIcon: Icon(
                                Icons.person_search,
                                color: Colors.grey.shade600,
                              ),
                              suffixIcon: _selectedCustomer != null
                                  ? IconButton(
                                      icon: Icon(Icons.clear, size: 18),
                                      onPressed: _clearCustomerSelection,
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: _filterCustomers,
                          ),
                          if (_customerSearchController.text.isNotEmpty &&
                              _filteredCustomers.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              constraints: const BoxConstraints(maxHeight: 150),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _filteredCustomers.length,
                                itemBuilder: (context, index) {
                                  final customer = _filteredCustomers[index];
                                  return ListTile(
                                    dense: true,
                                    leading: Icon(
                                      Icons.person_outline,
                                      size: 20,
                                    ),
                                    title: Text(
                                      customer.customerName,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedCustomer = customer;
                                        _customerSearchController.text =
                                            customer.customerName;
                                        _filter = _filter.copyWith(
                                          customerId: customer.id,
                                        );
                                        _filteredCustomers = [];
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Category Filter
                    _buildFilterSection(
                      title: 'Category',
                      child: DropdownButtonFormField<String>(
                        value: _filter.categoryId,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Categories'),
                          ),
                          ...widget.categories.map((category) {
                            return DropdownMenuItem(
                              value: category.id,
                              child: Text(category.productName),
                            );
                          }),
                        ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _filter = _filter.copyWith(categoryId: value);
                            // Reset subcategory when category changes
                            if (value == null) {
                              _filter = _filter.copyWith(subCategoryId: null);
                            }
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // SubCategory Filter
                    _buildFilterSection(
                      title: 'Sub Category',
                      child: DropdownButtonFormField<String>(
                        value: _filter.subCategoryId,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Sub Categories'),
                          ),
                          ...widget.subCategories
                              .where(
                                (subCategory) =>
                                    _filter.categoryId == null ||
                                    subCategory.id == _filter.categoryId,
                              )
                              .map((subCategory) {
                                return DropdownMenuItem(
                                  value: subCategory.id,
                                  child: Text(subCategory.name),
                                );
                              }),
                        ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _filter = _filter.copyWith(subCategoryId: value);
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Invoice Status Filter
                    _buildFilterSection(
                      title: 'Invoice Status',
                      child: DropdownButtonFormField<String>(
                        value: _filter.invoiceStatus,
                        items: const [
                          DropdownMenuItem(
                            value: null,
                            child: Text('All Invoices'),
                          ),
                          DropdownMenuItem(
                            value: 'overdue',
                            child: Text('Overdue'),
                          ),
                          DropdownMenuItem(value: 'due', child: Text('Due')),
                          DropdownMenuItem(
                            value: 'unpaid',
                            child: Text('Unpaid'),
                          ),
                          DropdownMenuItem(
                            value: 'draft',
                            child: Text('Draft'),
                          ),
                          DropdownMenuItem(
                            value: 'overpaid',
                            child: Text('Overpaid'),
                          ),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _filter = _filter.copyWith(invoiceStatus: value);
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Created By Filter
                    _buildFilterSection(
                      title: 'Created By',
                      child: DropdownButtonFormField<String>(
                        value: _filter.createdBy,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Users'),
                          ),
                          ...widget.createdByUsers.map((user) {
                            return DropdownMenuItem(
                              value: user,
                              child: Text(user),
                            );
                          }),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _filter = _filter.copyWith(createdBy: value);
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Status Filter (Old - you might want to remove this or keep for backward compatibility)
                    _buildFilterSection(
                      title: 'Status (Legacy)',
                      child: DropdownButtonFormField<String>(
                        value: _filter.status,
                        items: const [
                          DropdownMenuItem(
                            value: null,
                            child: Text('All Status'),
                          ),
                          DropdownMenuItem(value: 'paid', child: Text('Paid')),
                          DropdownMenuItem(
                            value: 'pending',
                            child: Text('Pending'),
                          ),
                          DropdownMenuItem(value: 'due', child: Text('Due')),
                          DropdownMenuItem(
                            value: 'overdue',
                            child: Text('Overdue'),
                          ),
                          DropdownMenuItem(
                            value: 'draft',
                            child: Text('Draft'),
                          ),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _filter = _filter.copyWith(status: value);
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Payment Status
                    _buildFilterSection(
                      title: 'Payment Status',
                      child: DropdownButtonFormField<bool>(
                        value: _filter.isPaid,
                        items: const [
                          DropdownMenuItem(
                            value: null,
                            child: Text('All Payments'),
                          ),
                          DropdownMenuItem(value: true, child: Text('Paid')),
                          DropdownMenuItem(
                            value: false,
                            child: Text('Not Paid'),
                          ),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _filter = _filter.copyWith(isPaid: value);
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Deposit Filter
                    _buildFilterSection(
                      title: 'Deposit',
                      child: DropdownButtonFormField<bool>(
                        value: _filter.hasDeposit,
                        items: const [
                          DropdownMenuItem(
                            value: null,
                            child: Text('All Sales'),
                          ),
                          DropdownMenuItem(
                            value: true,
                            child: Text('With Deposit'),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text('Without Deposit'),
                          ),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _filter = _filter.copyWith(hasDeposit: value);
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Payment Method
                    _buildFilterSection(
                      title: 'Payment Method',
                      child: DropdownButtonFormField<String>(
                        value: _filter.paymentMethod,
                        items: const [
                          DropdownMenuItem(
                            value: null,
                            child: Text('All Methods'),
                          ),
                          DropdownMenuItem(value: 'cash', child: Text('Cash')),
                          DropdownMenuItem(value: 'card', child: Text('Card')),
                          DropdownMenuItem(
                            value: 'transfer',
                            child: Text('Transfer'),
                          ),
                          DropdownMenuItem(
                            value: 'cheque',
                            child: Text('Cheque'),
                          ),
                          DropdownMenuItem(
                            value: 'credit',
                            child: Text('Credit'),
                          ),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _filter = _filter.copyWith(paymentMethod: value);
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Date Range
                    _buildFilterSection(
                      title: 'Date Range',
                      child: InkWell(
                        onTap: _selectDateRange,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _filter.dateRange == null
                                      ? 'Select Date Range'
                                      : '${DateFormat('MMM dd, yyyy').format(_filter.dateRange!.start)} - ${DateFormat('MMM dd, yyyy').format(_filter.dateRange!.end)}',
                                  style: TextStyle(
                                    color: _filter.dateRange == null
                                        ? Colors.grey.shade600
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              if (_filter.dateRange != null)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _filter = _filter.copyWith(
                                        dateRange: null,
                                      );
                                    });
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    size: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 24,
                                    minHeight: 24,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Amount Range
                    _buildFilterSection(
                      title:
                          'Amount Range (OMR ${_filter.amountRange?.start.round() ?? 0} - OMR ${_filter.amountRange?.end.round() ?? 10000})',
                      child: RangeSlider(
                        values:
                            _filter.amountRange ?? const RangeValues(0, 10000),
                        min: 0,
                        max: 10000,
                        divisions: 20,
                        labels: RangeLabels(
                          'OMR ${(_filter.amountRange?.start ?? 0).round()}',
                          'OMR ${(_filter.amountRange?.end ?? 10000).round()}',
                        ),
                        onChanged: (values) {
                          setState(() {
                            _filter = _filter.copyWith(amountRange: values);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _filter = SalesFilter();
                        _customerSearchController.clear();
                        _searchController.clear();
                        _selectedCustomer = null;
                        _filteredCustomers = widget.customers;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Clear All',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApplyFilter(_filter);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _filterCustomers(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredCustomers = widget.customers;
        _selectedCustomer = null;
        _filter = _filter.copyWith(customerId: null);
      });
      return;
    }

    setState(() {
      _filteredCustomers = widget.customers
          .where(
            (customer) => customer.customerName.toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    });
  }

  void _clearCustomerSelection() {
    setState(() {
      _selectedCustomer = null;
      _customerSearchController.clear();
      _filter = _filter.copyWith(customerId: null);
      _filteredCustomers = widget.customers;
    });
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _filter.dateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _filter = _filter.copyWith(dateRange: picked);
      });
    }
  }
}

// Main Sales List View
class SalesListView extends StatefulWidget {
  final String? type;
  //  final List<SaleModel> sales;
  final Set<String> selectedIds;
  final Function(bool?, SaleModel) onSelectChanged;
  final bool enableSearch;

  const SalesListView({
    super.key,
    this.type,
    //required this.sales,
    required this.selectedIds,
    required this.onSelectChanged,
    this.enableSearch = true,
  });

  @override
  State<SalesListView> createState() => _SalesListViewState();
}

class _SalesListViewState extends State<SalesListView> {
  final TextEditingController _searchController = TextEditingController();
  List<SaleModel> _filteredSales = [];
  String _searchQuery = '';
  SalesFilter _currentFilter = SalesFilter();
  List<ProductCategoryModel> _categories = [];
  List<ProductSubCategoryModel> _subCategories = [];
  List<BrandModel> _brands = [];
  List<String> _createdByUsers = [];
  List<CustomerModel> _customers = [];
  List<SaleModel> salesList = [];

  @override
  void initState() {
    super.initState();
    getList();
    _searchController.addListener(_onSearchChanged);
    _loadCustomers();
    _loadFilterData();
  }

  Future<void> getList() async {
    if (widget.type == "estimation") {
      salesList = await DataFetchService.fetchEstimates();
    } else if (widget.type == "purchase") {
      // salesList = await DataFetchService.fetchPurchase();
    } else {
      salesList = await DataFetchService.fetchSales();
    }

    setState(() {
      _filteredSales = salesList;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _loadCustomers() async {
    _customers = context.read<MmResourceProvider>().customersList;
    if (mounted) setState(() {});
  }

  void _loadFilterData() async {
    _categories = await DataFetchService.fetchProduct();
    _subCategories = await DataFetchService.fetchSubCategories();
    _brands = await DataFetchService.fetchBrands();

    // Extract unique createdBy users
    _createdByUsers = salesList
        .map((sale) => sale.createdBy)
        .where((user) => user.isNotEmpty)
        .toSet()
        .toList();

    if (mounted) {
      setState(() {});
    }
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {
        _searchQuery = _searchController.text;
        _applyCombinedFilters();
      });
    }
  }

  List<SaleModel> filterSalesByInvoiceStatus(
    List<SaleModel> sales,
    String? invoiceStatus,
  ) {
    if (invoiceStatus == null) {
      return sales; // Return all if no filter selected
    }

    final now = DateTime.now();

    return sales.where((sale) {
      switch (invoiceStatus) {
        case 'overdue':
          // Today's date is after sale.dueDate
          return sale.dueDate != null && now.isAfter(sale.dueDate!);

        case 'due':
          // Today's date is before sale.dueDate
          return sale.dueDate != null && now.isBefore(sale.dueDate!);

        case 'unpaid':
          // sale.status == "pending"
          return sale.status == "pending";

        case 'draft':
          // sale.status == "draft"
          return sale.status == "draft";

        case 'overpaid':
          // sale.total < paymentData.totalPaid
          final totalPaid = sale.paymentData?.totalPaid ?? 0;
          return sale.total! < totalPaid;

        default:
          return true;
      }
    }).toList();
  }

  void _applyCombinedFilters() {
    List<SaleModel> filtered = salesList;

    // Apply search query filter
    if (_currentFilter.searchQuery?.isNotEmpty ?? false) {
      final query = _currentFilter.searchQuery!.toLowerCase();
      filtered = filtered.where((sale) {
        return sale.customerName.toLowerCase().contains(query) ||
            sale.invoice.toLowerCase().contains(query) ||
            sale.id.toLowerCase().contains(query) ||
            sale.createdBy.toLowerCase().contains(query) ||
            sale.items.any(
              (item) => item.productName.toLowerCase().contains(query),
            ) ||
            (sale.draft?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (_currentFilter.customerId != null) {
      filtered = filtered
          .where((sale) => sale.customerName == _currentFilter.customerId)
          .toList();
    }

    if (_currentFilter.categoryId != null) {
      filtered = filtered.where((sale) {
        List<ProductModel> filteredProducts = context
            .read<MmResourceProvider>()
            .productsList
            .where((product) => product.categoryId == _currentFilter.categoryId)
            .toList();
        List<String?> filteredProductIds = filteredProducts
            .map((p) => p.id)
            .toList();
        return sale.items.any(
          (item) => filteredProductIds.contains(item.productId),
        );
      }).toList();
    }

    // Apply subcategory filter (NEW)
    if (_currentFilter.subCategoryId != null) {
      filtered = filtered.where((sale) {
        List<ProductModel> filteredProducts = context
            .read<MmResourceProvider>()
            .productsList
            .where(
              (product) =>
                  product.subCategoryId == _currentFilter.subCategoryId,
            )
            .toList();
        List<String?> filteredProductIds = filteredProducts
            .map((p) => p.id)
            .toList();
        // return sale.items.any(
        //   (item) => filteredProductIds.contains(item.productId),
        // );
        return sale.items.any(
          (item) => filteredProductIds.contains(item.productId),
        );
      }).toList();
    }

    // Apply created by filter (NEW)
    if (_currentFilter.createdBy != null) {
      filtered = filtered
          .where((sale) => sale.createdBy == _currentFilter.createdBy)
          .toList();
    }

    // Apply customer filter
    if (_currentFilter.customerId != null) {
      filtered = filtered
          .where(
            (sale) => sale.customerName.toLowerCase().contains(
              _currentFilter.customerId!.toLowerCase(),
            ),
          )
          .toList();
    }

    // Apply status filter
    if (_currentFilter.invoiceStatus != null) {
      DateTime now = DateTime.now();
      // filtered = filtered
      //     .where(
      //       (sale) =>
      //           sale.status.toLowerCase() ==
      //           _currentFilter.status!.toLowerCase(),
      //     )
      //     .toList();
      if (_currentFilter.invoiceStatus == "draft") {
        filtered = filtered
            .where((item) => item.status.toLowerCase() == "draft")
            .toList();
      } else if (_currentFilter.invoiceStatus == "overdue") {
        filtered = filtered
            .where((sale) => sale.dueDate != null && now.isAfter(sale.dueDate!))
            .toList();
      } else if (_currentFilter.invoiceStatus == "due") {
        filtered = filtered
            .where(
              (sale) => sale.dueDate != null && now.isBefore(sale.dueDate!),
            )
            .toList();
      } else if (_currentFilter.invoiceStatus == "unpaid") {
        filtered = filtered.where((sale) => sale.status == "pending").toList();
      } else if (_currentFilter.invoiceStatus == "overpaid") {
        filtered = filtered
            .where((sale) => sale.total! < sale.paymentData.totalPaid)
            .toList();
      }

      // case 'overpaid':
      //   // sale.total < paymentData.totalPaid
      //   final totalPaid = sale.paymentData?.totalPaid ?? 0;
      //   return sale.total! < totalPaid;

      //filterSalesByInvoiceStatus(filtered, _currentFilter.status);
    }

    // Apply payment status filter
    if (_currentFilter.isPaid != null) {
      filtered = filtered
          .where(
            (sale) => sale.paymentData.isAlreadyPaid == _currentFilter.isPaid,
          )
          .toList();
    }

    // Apply deposit filter
    if (_currentFilter.hasDeposit != null) {
      filtered = filtered
          .where(
            (sale) => sale.deposit.requireDeposit == _currentFilter.hasDeposit,
          )
          .toList();
    }

    // Apply payment method filter
    if (_currentFilter.paymentMethod != null) {
      filtered = filtered
          .where(
            (sale) =>
                sale.paymentMethod.toLowerCase() ==
                _currentFilter.paymentMethod!.toLowerCase(),
          )
          .toList();
    }

    // Apply created by filter
    if (_currentFilter.createdBy != null) {
      filtered = filtered
          .where((sale) => sale.createdBy == _currentFilter.createdBy)
          .toList();
    }

    // Apply date range filter
    if (_currentFilter.dateRange != null) {
      filtered = filtered
          .where(
            (sale) =>
                sale.createdAt.isAfter(_currentFilter.dateRange!.start) &&
                sale.createdAt.isBefore(
                  _currentFilter.dateRange!.end.add(const Duration(days: 1)),
                ),
          )
          .toList();
    }

    // Apply amount range filter
    if (_currentFilter.amountRange != null) {
      filtered = filtered
          .where(
            (sale) =>
                sale.totalRevenue >= _currentFilter.amountRange!.start &&
                sale.totalRevenue <= _currentFilter.amountRange!.end,
          )
          .toList();
    }

    if (mounted) {
      setState(() {
        _filteredSales = filtered;
      });
    }
  }

  // @override
  // void didUpdateWidget(SalesListView oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.sales != widget.sales) {
  //     _applyCombinedFilters();
  //   }
  // }

  void change(SaleModel s) {
    // widget.onSelectChanged(true, s);
    //  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
    // return
    // CreateBookingMainPage()
  }

  void _handleActionSelected(SaleModel sale, SaleAction action) async {
    switch (action) {
      case SaleAction.view:
        // Navigate to sale details
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return SalesInvoiceDropdownView(type: "sale", sale: sale);
            },
          ),
        );

        debugPrint('View sale: ${sale.id}');
        break;
      case SaleAction.clone:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return CreateBookingMainPage(
                sale: sale,
                tapped: () {},
                type: "clone",
              );
            },
          ),
        );
        debugPrint('Print receipt: ${sale.createdAt}');
        break;
      case SaleAction.duplicate:
        // Duplicate sale
        debugPrint('Add Payment : ${sale.createdBy}');
        break;
      case SaleAction.payment:
        Navigator.of(context).push<bool>(
          MaterialPageRoute(builder: (context) => PaymentPage(sale: sale)),
        );
        getList();
      // if (result == true) {
      //   // Payment was successful, refresh the sale data or update UI
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Payment processed successfully!'),
      //       backgroundColor: Colors.green,
      //     ),
      //   );
      // }
      case SaleAction.edit:
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return CreateBookingMainPage(
                sale: sale,
                type: "edit",
                tapped: () {},
              );
            },
          ),
        );
        await getList();
        debugPrint('Edit sale: ${sale.createdBy}');
        break;
      case SaleAction.logs:
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvoiceLogsTimeline(saleId: sale.id),
          ),
        );
      case SaleAction.refund:
        // Process refund
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return CreateBookingMainPage(
                type: "refund",
                sale: sale,
                tapped: () {},
              );
            },
          ),
        );
        await getList();
        debugPrint('Edit sale: ${sale.createdBy}');
        break;
      case SaleAction.delete:
        _showDeleteConfirmation(sale);
        break;
    }
  }

  void _showRefundConfirmation(SaleModel sale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Process Refund'),
        content: Text(
          'Are you sure you want to process a refund for sale "${sale.id}"?\n\nAmount: \${sale.totalAmount?.toStringAsFixed(2) ?? }',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Process refund logic
              debugPrint('Refunded sale: ${sale.id}');
            },
            child: Text(
              'Process Refund',
              style: TextStyle(color: Colors.amber.shade700),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(SaleModel sale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Sale'),
        content: Text(
          'Are you sure you want to delete sale "${sale.id}"?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Delete sale logic
              debugPrint('Deleted sale: ${sale.id}');
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => SalesFilterDialog(
        currentFilter: _currentFilter,
        categories: _categories,
        subCategories: _subCategories,
        brands: _brands,
        createdByUsers: _createdByUsers,
        customers: _customers, // Add your customers list here
        onApplyFilter: (filter) {
          if (mounted) {
            setState(() {
              _currentFilter = filter;
              debugPrint("${"filter"}${_currentFilter.toString()}");
              _applyCombinedFilters();
            });
          }
        },
      ),
    );
  }

  // void navMaintenanceBooking() {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
  //     return CreateBookingMainPage(

  //     );
  //   }));
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar and Filter Button
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Search Bar
              if (widget.enableSearch)
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText:
                            'Search by customer, sale number, description, created by...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.grey.shade400,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 20,
                                  color: Colors.grey.shade400,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(width: 12),

              // Filter Button
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _showFilterDialog,
                  icon: Icon(
                    Icons.filter_list,
                    size: 20,
                    color: _currentFilter.hasActiveFilters
                        ? Colors.white
                        : Colors.grey.shade700,
                  ),
                  label: Text(
                    'Filter${_currentFilter.hasActiveFilters ? ' (${_getActiveFilterCount()})' : ''}',
                    style: TextStyle(
                      color: _currentFilter.hasActiveFilters
                          ? Colors.white
                          : Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentFilter.hasActiveFilters
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade100,
                    elevation: _currentFilter.hasActiveFilters ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: _currentFilter.hasActiveFilters
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
              ),
              // const SizedBox(width: 12),
              // SizedBox(
              //   height: 50,
              //   width: 200,
              //   child: CustomButton(
              //     text: "Create Invoice",
              //     onPressed: navMaintenanceBooking,
              //     iconAsset: 'assets/images/add-circle.png',
              //     iconColor: AppTheme.whiteColor,
              //     buttonType: ButtonType.IconAndText,
              //     backgroundColor: AppTheme.primaryColor,
              //     textColor: AppTheme.whiteColor,
              //   ),
              // ),
            ],
          ),
        ),

        // Active Filters Display
        if (_currentFilter.hasActiveFilters)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _buildActiveFilterChips(),
            ),
          ),

        // Results count
        if (widget.enableSearch &&
            (_searchQuery.isNotEmpty || _currentFilter.hasActiveFilters))
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  'Found ${_filteredSales.length} sale${_filteredSales.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_searchQuery.isNotEmpty) ...[
                  Text(
                    ' for "$_searchQuery"',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),

        // Header Row
        Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              if (widget.selectedIds.isNotEmpty) const SizedBox(width: 32),
              const SizedBox(width: 100), // Sale number space
              const SizedBox(width: 55), // Icon space
              Expanded(
                flex: 1,
                child: Text('Customer & Description', style: _headerStyle()),
              ),
              Expanded(flex: 2, child: Text('Items', style: _headerStyle())),
              //Expanded(flex: 2, child: Text('Services', style: _headerStyle())),
              Expanded(
                flex: 1,
                child: Text(
                  'Total (OMR)',
                  style: _headerStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Payment (OMR)',
                  style: _headerStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Date',
                  style: _headerStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 30), // Actions space
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Sales List
        Expanded(
          child: _filteredSales.isEmpty
              ? _buildEmptyState()
              :
                // ListView.builder(
                //     padding: const EdgeInsets.symmetric(horizontal: 16),
                //     itemCount: _filteredSales.length,
                //     itemBuilder: (context, index) {
                //       final sale = _filteredSales[index];
                //       final category = _categories
                //           .firstWhere((c) => c.id == sale.id //sale.categoryId,
                //               // orElse: () => ProductProductCategoryModel.,
                //               );
                //       final subCategory = _subCategories.firstWhere(
                //         (s) => s.id == sale.id, //sale.subCategoryId,
                //         // orElse: () =>
                //         //     SubProductCategoryModel(name: 'Unknown Sub Category'),
                //       );
                //       final brand = _brands.firstWhere(
                //         (b) => b.id == sale.id, //sale.brandId,
                //         orElse: () => BrandModel(name: 'Unknown Brand'),
                //       );
                //       return SaleCard(
                //         sale: sale,
                //         category: category,
                //         subCategory: subCategory,
                //         brand: brand,
                //         isSelected: widget.selectedIds.contains(sale.id),
                //         onActionSelected: (action) =>
                //             _handleActionSelected(sale, action),
                //         onSelectChanged: (value) =>
                //             widget.onSelectChanged(value, sale),
                //       );
                //     },
                //   ),
                ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredSales.length,
                  itemBuilder: (context, index) {
                    final sale = _filteredSales[index];

                    // Use safe methods to find categories, subcategories, and brands
                    final category = _categories.firstWhere(
                      (c) => c.id == sale.id,
                      orElse: () => ProductCategoryModel(
                        id: '',
                        productName: 'Unknown Category',
                      ),
                    );

                    final subCategory = _subCategories.firstWhere(
                      (s) => s.id == sale.id,
                      orElse: () => ProductSubCategoryModel(
                        id: '',
                        name: 'Unknown Sub Category',
                      ),
                    );

                    final brand = _brands.firstWhere(
                      (b) => b.id == sale.id,
                      orElse: () => BrandModel(id: '', name: 'Unknown Brand'),
                    );

                    return SaleCard(
                      key: UniqueKey(),
                      sale: sale,
                      category: category,
                      type: widget.type ?? 'invoice',
                      subCategory: subCategory,
                      brand: brand,
                      isSelected: widget.selectedIds.contains(sale.id),
                      onActionSelected: (action) =>
                          _handleActionSelected(sale, action),
                      onSelectChanged: (value) =>
                          widget.onSelectChanged(value, sale),
                    );
                  },
                ),
        ),
      ],
    );
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_currentFilter.categoryId != null) count++;
    if (_currentFilter.subCategoryId != null) count++;
    if (_currentFilter.brandId != null) count++;
    if (_currentFilter.customerId != null) count++;
    if (_currentFilter.dateRange != null) count++;
    if (_currentFilter.amountRange != null) count++;
    if (_currentFilter.status != null) count++;
    if (_currentFilter.paymentMethod != null) count++;
    return count;
  }

  List<Widget> _buildActiveFilterChips() {
    List<Widget> chips = [];

    if (_currentFilter.categoryId != null) {
      final category = _categories.firstWhere(
        (c) => c.id == _currentFilter.categoryId,
        //orElse: () => ProductCategoryModel(name: 'Unknown'),
      );
      chips.add(
        _buildFilterChip('Category: ${category.productName}', () {
          setState(() {
            _currentFilter.categoryId = null;
            _currentFilter.subCategoryId = null; // Reset subcategory too
            _applyCombinedFilters();
          });
        }),
      );
    }

    if (_currentFilter.customerId != null) {
      final customer = _customers.firstWhere(
        (c) => c.id == _currentFilter.customerId,
        // orElse: () => CustomerModel(id: '', name: 'Unknown Customer'),
      );
      chips.add(
        _buildFilterChip('Customer: ${customer.customerName}', () {
          setState(() {
            _currentFilter.customerId = null;
            _applyCombinedFilters();
          });
        }),
      );
    }

    if (_currentFilter.categoryId != null) {
      final category = _categories.firstWhere(
        (c) => c.id == _currentFilter.categoryId,
        orElse: () =>
            ProductCategoryModel(id: '', productName: 'Unknown Category'),
      );
      chips.add(
        _buildFilterChip('Category: ${category.productName}', () {
          setState(() {
            _currentFilter.categoryId = null;
            _currentFilter.subCategoryId = null; // Reset subcategory too
            _applyCombinedFilters();
          });
        }),
      );
    }

    if (_currentFilter.subCategoryId != null) {
      final subCategory = _subCategories.firstWhere(
        (s) => s.id == _currentFilter.subCategoryId,
        orElse: () =>
            ProductSubCategoryModel(id: '', name: 'Unknown Sub Category'),
      );
      chips.add(
        _buildFilterChip('Sub Category: ${subCategory.name}', () {
          setState(() {
            _currentFilter.subCategoryId = null;
            _applyCombinedFilters();
          });
        }),
      );
    }

    if (_currentFilter.subCategoryId != null) {
      final subCategory = _subCategories.firstWhere(
        (s) => s.id == _currentFilter.subCategoryId,
        orElse: () => ProductSubCategoryModel(name: 'Unknown'),
      );
      chips.add(
        _buildFilterChip('Sub Category: ${subCategory.name}', () {
          setState(() {
            _currentFilter.subCategoryId = null;
            _applyCombinedFilters();
          });
        }),
      );
    }

    if (_currentFilter.createdBy != null) {
      chips.add(
        _buildFilterChip('Created By: ${_currentFilter.createdBy}', () {
          setState(() {
            _currentFilter.createdBy = null;
            _applyCombinedFilters();
          });
        }),
      );
    }

    if (_currentFilter.brandId != null) {
      final brand = _brands.firstWhere(
        (b) => b.id == _currentFilter.brandId,
        orElse: () => BrandModel(name: 'Unknown'),
      );
      chips.add(
        _buildFilterChip('Brand: ${brand.name}', () {
          setState(() {
            _currentFilter.brandId = null;
            _applyCombinedFilters();
          });
        }),
      );
    }

    if (_currentFilter.customerId != null) {
      chips.add(
        _buildFilterChip('Customer: ${_currentFilter.customerId}', () {
          setState(() {
            _currentFilter.customerId = null;
            _applyCombinedFilters();
          });
        }),
      );
    }

    if (_currentFilter.dateRange != null) {
      chips.add(
        _buildFilterChip(
          'Date: ${DateFormat('MMM dd').format(_currentFilter.dateRange!.start)} - ${DateFormat('MMM dd').format(_currentFilter.dateRange!.end)}',
          () {
            setState(() {
              _currentFilter.dateRange = null;
              _applyCombinedFilters();
            });
          },
        ),
      );
    }

    if (_currentFilter.amountRange != null) {
      chips.add(
        _buildFilterChip(
          'Amount: \${_currentFilter.amountRange!.start.round()} - \${_currentFilter.amountRange!.end.round()}',
          () {
            setState(() {
              _currentFilter.amountRange = null;
              _applyCombinedFilters();
            });
          },
        ),
      );
    }

    if (_currentFilter.status != null) {
      chips.add(
        _buildFilterChip('Status: ${_currentFilter.status!.toUpperCase()}', () {
          setState(() {
            _currentFilter.status = null;
            _applyCombinedFilters();
          });
        }),
      );
    }

    if (_currentFilter.paymentMethod != null) {
      chips.add(
        _buildFilterChip(
          'Payment: ${_currentFilter.paymentMethod!.toUpperCase()}',
          () {
            setState(() {
              _currentFilter.paymentMethod = null;
              _applyCombinedFilters();
            });
          },
        ),
      );
    }
    if (_currentFilter.invoiceStatus != null) {
      chips.add(
        _buildFilterChip(
          'status: ${_currentFilter.invoiceStatus!.toUpperCase()}',
          () {
            setState(() {
              _currentFilter.invoiceStatus = null;
              _applyCombinedFilters();
            });
          },
        ),
      );
    }

    // Clear All chip
    if (chips.isNotEmpty) {
      chips.add(
        _buildFilterChip('Clear All', () {
          setState(() {
            _currentFilter.clear();
            _applyCombinedFilters();
          });
        }, isClearAll: true),
      );
    }

    // if (chips.isNotEmpty) {
    //   chips.add(
    //     _buildFilterChip('Clear All', () {
    //       setState(() {
    //         _currentFilter.clear();
    //         _applyCombinedFilters();
    //       });
    //     }, isClearAll: true),
    //   );
    // }

    return chips;
  }

  Widget _buildFilterChip(
    String label,
    VoidCallback onRemove, {
    bool isClearAll = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isClearAll
            ? Colors.red.shade50
            : Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isClearAll
              ? Colors.red.shade300
              : Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      child: InkWell(
        onTap: onRemove,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isClearAll
                      ? Colors.red.shade700
                      : Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.close,
                size: 14,
                color: isClearAll
                    ? Colors.red.shade700
                    : Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isNotEmpty || _currentFilter.hasActiveFilters
                ? Icons.search_off
                : Icons.point_of_sale_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty || _currentFilter.hasActiveFilters
                ? 'No sales found'
                : 'No sales available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _currentFilter.hasActiveFilters
                ? 'Try adjusting your search or filters'
                : 'Start making sales to see them here',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade700,
    );
  }
}
