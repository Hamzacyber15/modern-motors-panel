// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:practice_erp/view/unit/extensions.dart';
// import 'package:practice_erp/widgets/profile_widget_for_datatable.dart';
// import 'package:practice_erp/widgets/search_box.dart';

// import '../core/app_theme.dart';
// import '../utils/helper.dart';

// class DynamicDataTable<T> extends StatefulWidget {
//   final List<T> data;
//   final List<String> columns;
//   final List<String Function(T)> valueGetters;
//   final void Function(T)? onEdit;
//   final void Function(T)? onView;
//   final void Function(T)? onStatus;
//   final Set<dynamic> selectedIds;
//   final dynamic Function(T) getId;
//   final void Function(bool?, T)? onSelectChanged;
//   final void Function(bool?)? onSelectAll;
//   final void Function(double lat, double lng)? onLocationTap; // NEW
//   final void Function(T item)? onAddExpensesPressed; // NEW
//   final bool isWithImage;
//   final Function(String)? onSearch;
//   final String Function(T item)? statusTextGetter;
//   final int combineImageWithTextIndex;
//   final int createByIndex;
//   final String? userId;
//   final bool isCheckbox;
//   final Widget? dropDownWidget;

//   const DynamicDataTable({
//     super.key,
//     required this.data,
//     required this.columns,
//     required this.valueGetters,
//     required this.getId,
//     required this.selectedIds,
//     this.onSelectChanged,
//     this.isWithImage = false,
//     this.isCheckbox = true,
//     this.combineImageWithTextIndex = -1,
//     this.createByIndex = -1,
//     this.onEdit,
//     this.onView,
//     this.onStatus,
//     this.onSelectAll,
//     this.onSearch,
//     this.dropDownWidget,
//     this.statusTextGetter,
//     this.onLocationTap,
//     this.onAddExpensesPressed,
//     this.userId,
//   });

//   @override
//   State<DynamicDataTable<T>> createState() => _DynamicDataTableState<T>();
// }

// class _DynamicDataTableState<T> extends State<DynamicDataTable<T>>
//     with TickerProviderStateMixin {
//   final ScrollController _horizontalScrollController = ScrollController();
//   int? _sortColumnIndex;
//   bool _sortAscending = true;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.1),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _horizontalScrollController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return FadeTransition(
//           opacity: _fadeAnimation,
//           child: SlideTransition(
//             position: _slideAnimation,
//             child: Padding(
//               padding:
//                   widget.onSearch == null
//                       ? EdgeInsets.zero
//                       : const EdgeInsets.all(20.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: AppTheme.whiteColor,
//                   borderRadius: BorderRadius.circular(
//                     widget.onSearch == null ? 0 : 16,
//                   ),
//                   border: Border.all(
//                     color: AppTheme.borderColor.withValues(alpha: 0.3),
//                     width: 1,
//                   ),
//                   boxShadow: [
//                     if (widget.onSearch != null) ...[
//                       BoxShadow(
//                         color: Colors.black.withValues(alpha: 0.04),
//                         blurRadius: 24,
//                         offset: const Offset(0, 8),
//                         spreadRadius: 0,
//                       ),
//                       BoxShadow(
//                         color: Colors.black.withValues(alpha: 0.02),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                         spreadRadius: 0,
//                       ),
//                     ],
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Enhanced Header Section
//                     if (widget.onSearch != null)
//                       Container(
//                         padding:
//                             widget.onSearch == null
//                                 ? EdgeInsets.zero
//                                 : const EdgeInsets.all(24.0),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               AppTheme.whiteColor,
//                               AppTheme.whiteColor.withValues(alpha: 0.8),
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(16),
//                             topRight: Radius.circular(16),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             // Enhanced Search Box
//                             Expanded(
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: AppTheme.whiteColor,
//                                   borderRadius: BorderRadius.circular(
//                                     widget.onSearch == null ? 0 : 12,
//                                   ),
//                                   border: Border.all(
//                                     color: AppTheme.borderColor.withValues(
//                                       alpha: 0.2,
//                                     ),
//                                     width: 1,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withValues(
//                                         alpha: 0.02,
//                                       ),
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: SearchBox(onChanged: widget.onSearch!),
//                               ),
//                             ),
//                             16.w,
//                             widget.dropDownWidget ?? Container(),
//                             16.w,
//                             // Data count indicator
//                             Container(
//                               padding:
//                                   widget.onSearch == null
//                                       ? EdgeInsets.zero
//                                       : const EdgeInsets.symmetric(
//                                         horizontal: 16,
//                                         vertical: 8,
//                                       ),
//                               decoration: BoxDecoration(
//                                 color: AppTheme.tableHeaderColor.withValues(
//                                   alpha: 0.1,
//                                 ),
//                                 borderRadius: BorderRadius.circular(
//                                   widget.onSearch == null ? 0 : 20,
//                                 ),
//                                 border: Border.all(
//                                   color: AppTheme.tableHeaderColor.withValues(
//                                     alpha: 0.2,
//                                   ),
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.table_rows_rounded,
//                                     size: 16,
//                                     color: AppTheme.tableHeaderTextColor,
//                                   ),
//                                   8.w,
//                                   Text(
//                                     '${widget.data.length} items',
//                                     style: AppTheme.getCurrentTheme()
//                                         .textTheme
//                                         .bodySmall
//                                         ?.copyWith(
//                                           color: AppTheme.tableHeaderTextColor,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     // Enhanced Divider
//                     Container(
//                       height: 1,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.transparent,
//                             AppTheme.borderColor.withValues(alpha: 0.3),
//                             Colors.transparent,
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Enhanced Table Section
//                     Padding(
//                       padding:
//                           widget.onSearch == null
//                               ? EdgeInsets.zero
//                               : const EdgeInsets.all(24.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(
//                             widget.onSearch == null ? 0 : 12,
//                           ),
//                           border: Border.all(
//                             color: AppTheme.borderColor.withValues(alpha: 0.2),
//                             width: 1,
//                           ),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(
//                             widget.onSearch == null ? 0 : 12,
//                           ),
//                           child: Scrollbar(
//                             controller: _horizontalScrollController,
//                             thumbVisibility: true,
//                             trackVisibility: true,
//                             interactive: true,
//                             thickness: 8,
//                             radius: const Radius.circular(4),
//                             child: SingleChildScrollView(
//                               controller: _horizontalScrollController,
//                               scrollDirection: Axis.horizontal,
//                               child: IntrinsicWidth(
//                                 child: DataTable(
//                                   dividerThickness: 0.5,
//                                   sortColumnIndex: _sortColumnIndex,
//                                   sortAscending: _sortAscending,
//                                   showCheckboxColumn:
//                                       !widget.isCheckbox ||
//                                       widget.onSearch != null,
//                                   showBottomBorder: false,
//                                   columnSpacing: 32,
//                                   horizontalMargin: 16,
//                                   headingRowHeight: 56,
//                                   dataRowMinHeight: 52,
//                                   dataRowMaxHeight: 64,
//                                   headingRowColor: WidgetStatePropertyAll(
//                                     AppTheme.tableHeaderColor.withValues(
//                                       alpha: 0.05,
//                                     ),
//                                   ),
//                                   headingTextStyle: AppTheme.getCurrentTheme()
//                                       .textTheme
//                                       .bodyMedium
//                                       ?.copyWith(
//                                         color: AppTheme.tableHeaderTextColor,
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14,
//                                       ),
//                                   dataTextStyle: AppTheme.getCurrentTheme()
//                                       .textTheme
//                                       .bodyMedium
//                                       ?.copyWith(
//                                         color: AppTheme.black,
//                                         fontWeight: FontWeight.w400,
//                                         fontSize: 14,
//                                       ),
//                                   onSelectAll:
//                                       widget.onSelectAll == null
//                                           ? null
//                                           : (value) {
//                                             for (var item in widget.data) {
//                                               widget.onSelectChanged!(
//                                                 value,
//                                                 item,
//                                               );
//                                             }
//                                             widget.onSelectAll!(value);
//                                           },
//                                   columns: [
//                                     ...List.generate(widget.columns.length, (
//                                       index,
//                                     ) {
//                                       final col = widget.columns[index];

//                                       return DataColumn(
//                                         label: Material(
//                                           color: Colors.transparent,
//                                           child: InkWell(
//                                             onTap: () {
//                                               setState(() {
//                                                 _sortColumnIndex = index;
//                                                 _sortAscending =
//                                                     !_sortAscending;

//                                                 widget.data.sort((a, b) {
//                                                   final aValue = widget
//                                                       .valueGetters[index](a);
//                                                   final bValue = widget
//                                                       .valueGetters[index](b);
//                                                   return _sortAscending
//                                                       ? aValue.compareTo(bValue)
//                                                       : bValue.compareTo(
//                                                         aValue,
//                                                       );
//                                                 });
//                                               });
//                                             },
//                                             borderRadius: BorderRadius.circular(
//                                               widget.onSearch == null ? 0 : 8,
//                                             ),
//                                             child: Container(
//                                               padding:
//                                                   widget.onSearch == null
//                                                       ? EdgeInsets.zero
//                                                       : const EdgeInsets.symmetric(
//                                                         horizontal: 8,
//                                                         vertical: 4,
//                                                       ),
//                                               child: Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Text(col),
//                                                   8.w,
//                                                   AnimatedSwitcher(
//                                                     duration: const Duration(
//                                                       milliseconds: 200,
//                                                     ),
//                                                     child: Icon(
//                                                       _sortColumnIndex == index
//                                                           ? (_sortAscending
//                                                               ? Icons
//                                                                   .keyboard_arrow_up_rounded
//                                                               : Icons
//                                                                   .keyboard_arrow_down_rounded)
//                                                           : Icons
//                                                               .unfold_more_rounded,
//                                                       key: ValueKey(
//                                                         '$_sortColumnIndex-$_sortAscending',
//                                                       ),
//                                                       size: 18,
//                                                       color:
//                                                           _sortColumnIndex ==
//                                                                   index
//                                                               ? AppTheme
//                                                                   .tableHeaderTextColor
//                                                               : AppTheme
//                                                                   .tableHeaderTextColor
//                                                                   .withValues(
//                                                                     alpha: 0.5,
//                                                                   ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     }),

//                                     if (widget.onStatus != null)
//                                       DataColumn(
//                                         label: Material(
//                                           color: Colors.transparent,
//                                           child: InkWell(
//                                             onTap: () {
//                                               setState(() {
//                                                 _sortColumnIndex =
//                                                     widget.columns.length + 1;
//                                                 _sortAscending =
//                                                     !_sortAscending;

//                                                 widget.data.sort((a, b) {
//                                                   final aStatus =
//                                                       widget.statusTextGetter
//                                                           ?.call(a) ??
//                                                       'Inactive';
//                                                   final bStatus =
//                                                       widget.statusTextGetter
//                                                           ?.call(b) ??
//                                                       'Inactive';
//                                                   int aValue =
//                                                       aStatus == 'Active'
//                                                           ? 1
//                                                           : 0;
//                                                   int bValue =
//                                                       bStatus == 'Active'
//                                                           ? 1
//                                                           : 0;

//                                                   return _sortAscending
//                                                       ? aValue.compareTo(bValue)
//                                                       : bValue.compareTo(
//                                                         aValue,
//                                                       );
//                                                 });
//                                               });
//                                             },
//                                             borderRadius: BorderRadius.circular(
//                                               widget.onSearch == null ? 0 : 8,
//                                             ),
//                                             child: Container(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                     horizontal: 8,
//                                                     vertical: 4,
//                                                   ),
//                                               child: Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Text('Status'.tr()),
//                                                   8.w,
//                                                   AnimatedSwitcher(
//                                                     duration: const Duration(
//                                                       milliseconds: 200,
//                                                     ),
//                                                     child: Icon(
//                                                       _sortColumnIndex ==
//                                                               widget
//                                                                       .columns
//                                                                       .length +
//                                                                   1
//                                                           ? (_sortAscending
//                                                               ? Icons
//                                                                   .keyboard_arrow_up_rounded
//                                                               : Icons
//                                                                   .keyboard_arrow_down_rounded)
//                                                           : Icons
//                                                               .unfold_more_rounded,
//                                                       key: ValueKey(
//                                                         'status-$_sortColumnIndex-$_sortAscending',
//                                                       ),
//                                                       size: 18,
//                                                       color:
//                                                           _sortColumnIndex ==
//                                                                   widget
//                                                                           .columns
//                                                                           .length +
//                                                                       1
//                                                               ? AppTheme
//                                                                   .tableHeaderTextColor
//                                                               : AppTheme
//                                                                   .tableHeaderTextColor
//                                                                   .withValues(
//                                                                     alpha: 0.5,
//                                                                   ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     if (widget.onEdit != null)
//                                       DataColumn(
//                                         label: Container(
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 8,
//                                             vertical: 4,
//                                           ),
//                                           child: Text(
//                                             "Actions".tr(),
//                                             style: AppTheme.getCurrentTheme()
//                                                 .textTheme
//                                                 .bodyMedium
//                                                 ?.copyWith(
//                                                   color:
//                                                       AppTheme
//                                                           .tableHeaderTextColor,
//                                                   fontWeight: FontWeight.w600,
//                                                   fontSize: 14,
//                                                 ),
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                   rows:
//                                       widget.data.asMap().entries.map((entry) {
//                                         final index = entry.key;
//                                         final item = entry.value;
//                                         final status =
//                                             widget.statusTextGetter?.call(
//                                               item,
//                                             ) ??
//                                             'inactive';
//                                         final id = widget.getId(item);
//                                         final isSelected = widget.selectedIds
//                                             .contains(id);

//                                         return DataRow(
//                                           selected: isSelected,
//                                           onSelectChanged:
//                                               (value) =>
//                                                   widget.onSelectChanged!(
//                                                     value,
//                                                     item,
//                                                   ),
//                                           color:
//                                               WidgetStateProperty.resolveWith<
//                                                 Color?
//                                               >((states) {
//                                                 if (states.contains(
//                                                   WidgetState.selected,
//                                                 )) {
//                                                   return AppTheme
//                                                       .tableHeaderColor
//                                                       .withValues(alpha: 0.08);
//                                                 }
//                                                 if (index.isEven) {
//                                                   return AppTheme.whiteColor;
//                                                 }
//                                                 return AppTheme.tableHeaderColor
//                                                     .withValues(alpha: 0.02);
//                                               }),
//                                           cells: [
//                                             ...List.generate(widget.valueGetters.length, (
//                                               cellIndex,
//                                             ) {
//                                               // Special handling for Pick/Drop Location
//                                               final cellValue = widget
//                                                   .valueGetters[cellIndex](
//                                                 item,
//                                               );
//                                               final colName =
//                                                   widget.columns[cellIndex]
//                                                       .toLowerCase();

//                                               // If value is "Pick Location" or "Drop Location" column
//                                               if ((colName.contains(
//                                                         "pickup location",
//                                                       ) ||
//                                                       colName.contains(
//                                                         "drop location",
//                                                       )) &&
//                                                   widget.onLocationTap !=
//                                                       null) {
//                                                 // New format: "location | lat | lng"
//                                                 // final parts = value.split('|');
//                                                 final parts = cellValue.split(
//                                                   '|',
//                                                 );

//                                                 final locationName =
//                                                     parts.isNotEmpty
//                                                         ? parts[0].trim()
//                                                         : '';
//                                                 double? lat, lng;
//                                                 if (parts.length >= 3) {
//                                                   lat = double.tryParse(
//                                                     parts[1].trim(),
//                                                   );
//                                                   lng = double.tryParse(
//                                                     parts[2].trim(),
//                                                   );
//                                                 }
//                                                 return DataCell(
//                                                   GestureDetector(
//                                                     onTap:
//                                                         (lat != null &&
//                                                                 lng != null)
//                                                             ? () => widget
//                                                                 .onLocationTap!(
//                                                               lat!,
//                                                               lng!,
//                                                             )
//                                                             : null,
//                                                     child: Text(
//                                                       locationName,
//                                                       style: const TextStyle(
//                                                         color: Colors.blue,
//                                                         decoration:
//                                                             TextDecoration
//                                                                 .underline,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               }

//                                               // Special handling for Add Expenses column
//                                               if (colName.contains(
//                                                     "add expenses",
//                                                   ) &&
//                                                   widget.onAddExpensesPressed !=
//                                                       null) {
//                                                 return DataCell(
//                                                   ElevatedButton.icon(
//                                                     icon: const Icon(
//                                                       Icons.attach_money,
//                                                       size: 16,
//                                                     ),
//                                                     label: const Text(
//                                                       "Add Expense",
//                                                     ),
//                                                     style: ElevatedButton.styleFrom(
//                                                       padding:
//                                                           const EdgeInsets.symmetric(
//                                                             horizontal: 8,
//                                                             vertical: 4,
//                                                           ),
//                                                       backgroundColor: AppTheme
//                                                           .primaryColor
//                                                           .withValues(
//                                                             alpha: 0.1,
//                                                           ),
//                                                       foregroundColor:
//                                                           AppTheme.primaryColor,
//                                                       elevation: 0,
//                                                       shape: RoundedRectangleBorder(
//                                                         borderRadius:
//                                                             BorderRadius.circular(
//                                                               20,
//                                                             ),
//                                                       ),
//                                                       textStyle:
//                                                           const TextStyle(
//                                                             fontSize: 12,
//                                                             fontWeight:
//                                                                 FontWeight.w600,
//                                                           ),
//                                                     ),
//                                                     onPressed:
//                                                         () => widget
//                                                             .onAddExpensesPressed!(
//                                                           item,
//                                                         ),
//                                                   ),
//                                                 );
//                                               }

//                                               final value = widget
//                                                   .valueGetters[cellIndex](
//                                                 item,
//                                               );
//                                               final parts = value.split(',');
//                                               final productName =
//                                                   parts[0].trim();
//                                               final imageUrl =
//                                                   parts.length > 1
//                                                       ? parts[1].trim()
//                                                       : null;

//                                               return DataCell(
//                                                 Container(
//                                                   padding:
//                                                       const EdgeInsets.symmetric(
//                                                         vertical: 8,
//                                                       ),
//                                                   child:
//                                                       imageUrl == null &&
//                                                               cellIndex ==
//                                                                   widget
//                                                                       .combineImageWithTextIndex
//                                                           ? Container(
//                                                             padding:
//                                                                 const EdgeInsets.all(
//                                                                   8,
//                                                                 ),
//                                                             decoration: BoxDecoration(
//                                                               color: AppTheme
//                                                                   .borderColor
//                                                                   .withValues(
//                                                                     alpha: 0.1,
//                                                                   ),
//                                                               borderRadius:
//                                                                   BorderRadius.circular(
//                                                                     8,
//                                                                   ),
//                                                             ),
//                                                             child: const Icon(
//                                                               Icons
//                                                                   .broken_image_rounded,
//                                                               color:
//                                                                   Colors.grey,
//                                                               size: 20,
//                                                             ),
//                                                           )
//                                                           : widget.isWithImage &&
//                                                               cellIndex ==
//                                                                   widget
//                                                                       .combineImageWithTextIndex
//                                                           ? Row(
//                                                             children: [
//                                                               Container(
//                                                                 padding:
//                                                                     const EdgeInsets.all(
//                                                                       4,
//                                                                     ),
//                                                                 decoration: BoxDecoration(
//                                                                   color: AppTheme
//                                                                       .bgColor
//                                                                       .withValues(
//                                                                         alpha:
//                                                                             0.5,
//                                                                       ),
//                                                                   borderRadius:
//                                                                       BorderRadius.circular(
//                                                                         8,
//                                                                       ),
//                                                                   border: Border.all(
//                                                                     color: AppTheme
//                                                                         .borderColor
//                                                                         .withValues(
//                                                                           alpha:
//                                                                               0.2,
//                                                                         ),
//                                                                   ),
//                                                                 ),
//                                                                 child: ClipRRect(
//                                                                   borderRadius:
//                                                                       BorderRadius.circular(
//                                                                         6,
//                                                                       ),
//                                                                   child: Image.network(
//                                                                     imageUrl!,
//                                                                     height: 32,
//                                                                     width: 32,
//                                                                     fit:
//                                                                         BoxFit
//                                                                             .cover,
//                                                                     errorBuilder:
//                                                                         (
//                                                                           _,
//                                                                           __,
//                                                                           ___,
//                                                                         ) => Container(
//                                                                           height:
//                                                                               32,
//                                                                           width:
//                                                                               32,
//                                                                           decoration: BoxDecoration(
//                                                                             color: AppTheme.borderColor.withValues(
//                                                                               alpha:
//                                                                                   0.1,
//                                                                             ),
//                                                                             borderRadius: BorderRadius.circular(
//                                                                               6,
//                                                                             ),
//                                                                           ),
//                                                                           child: const Icon(
//                                                                             Icons.broken_image_rounded,
//                                                                             color:
//                                                                                 Colors.grey,
//                                                                             size:
//                                                                                 16,
//                                                                           ),
//                                                                         ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               12.w,
//                                                               Expanded(
//                                                                 child: Text(
//                                                                   productName,
//                                                                   style: AppTheme.getCurrentTheme()
//                                                                       .textTheme
//                                                                       .bodyMedium!
//                                                                       .copyWith(
//                                                                         fontWeight:
//                                                                             FontWeight.w500,
//                                                                         fontSize:
//                                                                             14,
//                                                                         color:
//                                                                             AppTheme.black,
//                                                                       ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           )
//                                                           : widget.createByIndex !=
//                                                                   -1 &&
//                                                               cellIndex ==
//                                                                   widget
//                                                                       .createByIndex
//                                                           ? ProfileWidgetForDatatable(
//                                                             key: ValueKey(
//                                                               value,
//                                                             ),
//                                                             userId: value,
//                                                           )
//                                                           : Text(
//                                                             value,
//                                                             style: AppTheme.getCurrentTheme()
//                                                                 .textTheme
//                                                                 .bodyMedium!
//                                                                 .copyWith(
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w400,
//                                                                   color:
//                                                                       AppTheme
//                                                                           .black,
//                                                                 ),
//                                                           ),
//                                                 ),
//                                               );
//                                             }),
//                                             if (widget.onStatus != null) ...[
//                                               DataCell(
//                                                 Container(
//                                                   padding:
//                                                       const EdgeInsets.symmetric(
//                                                         vertical: 8,
//                                                       ),
//                                                   child: Material(
//                                                     color: Colors.transparent,
//                                                     child: InkWell(
//                                                       onTap:
//                                                           () => widget
//                                                               .onStatus!(item),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                             20,
//                                                           ),
//                                                       child: Container(
//                                                         height: 32,
//                                                         width: 80,
//                                                         decoration: BoxDecoration(
//                                                           color: getStatusColor(
//                                                             status,
//                                                           ).withValues(
//                                                             alpha: 0.1,
//                                                           ),
//                                                           borderRadius:
//                                                               BorderRadius.circular(
//                                                                 20,
//                                                               ),
//                                                           border: Border.all(
//                                                             color:
//                                                                 getStatusColor(
//                                                                   status,
//                                                                 ).withValues(
//                                                                   alpha: 0.3,
//                                                                 ),
//                                                             width: 1,
//                                                           ),
//                                                         ),
//                                                         child: Center(
//                                                           child: Text(
//                                                             status.tr(),
//                                                             style: AppTheme.getCurrentTheme()
//                                                                 .textTheme
//                                                                 .bodySmall
//                                                                 ?.copyWith(
//                                                                   color:
//                                                                       getStatusColor(
//                                                                         status,
//                                                                       ),
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500,
//                                                                   fontSize: 12,
//                                                                 ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                             if (widget.onEdit != null)
//                                               DataCell(
//                                                 Container(
//                                                   padding:
//                                                       const EdgeInsets.symmetric(
//                                                         vertical: 8,
//                                                       ),
//                                                   child: Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.min,
//                                                     children: [
//                                                       if (widget.onView !=
//                                                           null) ...[
//                                                         Material(
//                                                           color:
//                                                               Colors
//                                                                   .transparent,
//                                                           child: InkWell(
//                                                             onTap:
//                                                                 () => widget
//                                                                     .onView!(
//                                                                   item,
//                                                                 ),
//                                                             borderRadius:
//                                                                 BorderRadius.circular(
//                                                                   8,
//                                                                 ),
//                                                             child: Container(
//                                                               padding:
//                                                                   const EdgeInsets.all(
//                                                                     8,
//                                                                   ),
//                                                               decoration: BoxDecoration(
//                                                                 color: AppTheme
//                                                                     .tableHeaderColor
//                                                                     .withValues(
//                                                                       alpha:
//                                                                           0.05,
//                                                                     ),
//                                                                 borderRadius:
//                                                                     BorderRadius.circular(
//                                                                       8,
//                                                                     ),
//                                                               ),
//                                                               child: Icon(
//                                                                 Icons
//                                                                     .visibility_rounded,
//                                                                 size: 16,
//                                                                 color:
//                                                                     AppTheme
//                                                                         .tableHeaderTextColor,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         8.w,
//                                                       ],
//                                                       Material(
//                                                         color:
//                                                             Colors.transparent,
//                                                         child: InkWell(
//                                                           onTap:
//                                                               () => widget
//                                                                   .onEdit!(
//                                                                 item,
//                                                               ),
//                                                           borderRadius:
//                                                               BorderRadius.circular(
//                                                                 8,
//                                                               ),
//                                                           child: Container(
//                                                             padding:
//                                                                 const EdgeInsets.all(
//                                                                   8,
//                                                                 ),
//                                                             decoration: BoxDecoration(
//                                                               color: AppTheme
//                                                                   .tableHeaderColor
//                                                                   .withValues(
//                                                                     alpha: 0.05,
//                                                                   ),
//                                                               borderRadius:
//                                                                   BorderRadius.circular(
//                                                                     8,
//                                                                   ),
//                                                             ),
//                                                             child: Icon(
//                                                               Icons
//                                                                   .edit_rounded,
//                                                               size: 16,
//                                                               color:
//                                                                   AppTheme
//                                                                       .tableHeaderTextColor,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                           ],
//                                         );
//                                       }).toList(),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dynamic_data_table_buttons.dart';
import 'package:modern_motors_panel/modern_motors/widgets/profile_widget_for_datatable.dart';
import 'package:modern_motors_panel/modern_motors/widgets/search_box.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class DynamicDataTable<T> extends StatefulWidget {
  final List<T> data;
  final List<String> columns;
  final List<String Function(T)> valueGetters;
  final void Function(T)? onEdit;
  final void Function(T)? onDelete;
  final void Function(T)? onView;
  final void Function(T)? onStatus;
  final Set<dynamic> selectedIds;
  final dynamic Function(T) getId;
  final String? hintText;
  final void Function(bool?, T)? onSelectChanged;
  final void Function(bool?)? onSelectAll;
  final void Function(double lat, double lng)? onLocationTap;
  final void Function(T item)? onAddExpensesPressed;
  final void Function(T item)? onServices;
  final void Function(T item)? onProducts;
  final bool isWithImage;
  final Function(String)? onSearch;
  final String Function(T item)? statusTextGetter;
  final int combineImageWithTextIndex;
  final int createByIndex;
  final String? userId;
  final String? editProfileAccessKey;
  final String? deleteProfileAccessKey;
  final bool isCheckbox;
  final Widget? dropDownWidget;
  final bool showRowNumbers;
  final void Function(T)? onEmail;

  const DynamicDataTable({
    super.key,
    required this.data,
    required this.columns,
    required this.valueGetters,
    required this.getId,
    required this.selectedIds,
    this.onSelectChanged,
    this.isWithImage = false,
    this.isCheckbox = true,
    this.showRowNumbers = true,
    this.combineImageWithTextIndex = -1,
    this.createByIndex = -1,
    this.onEdit,
    this.onDelete,
    this.onEmail,
    this.onView,
    this.onStatus,
    this.onSelectAll,
    this.onSearch,
    this.dropDownWidget,
    this.statusTextGetter,
    this.onLocationTap,
    this.onAddExpensesPressed,
    this.onServices,
    this.onProducts,
    this.userId,
    this.hintText,
    this.editProfileAccessKey,
    this.deleteProfileAccessKey,
  });

  @override
  State<DynamicDataTable<T>> createState() => _DynamicDataTableState<T>();
}

class _DynamicDataTableState<T> extends State<DynamicDataTable<T>>
    with TickerProviderStateMixin {
  final ScrollController _horizontalScrollController = ScrollController();
  int? _sortColumnIndex;
  bool _sortAscending = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildEnhancedHeader({
    required String title,
    required int index,
    bool isActionColumn = false,
    bool isStatusColumn = false,
    bool isRowNumber = false,
  }) {
    final isSelected = _sortColumnIndex == index;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isRowNumber
              ? [
                  const Color(0xFF6366F1).withOpacity(0.1),
                  const Color(0xFF8B5CF6).withOpacity(0.1),
                ]
              : isActionColumn
              ? [
                  const Color(0xFFEC4899).withOpacity(0.1),
                  const Color(0xFFF59E0B).withOpacity(0.1),
                ]
              : isStatusColumn
              ? [
                  const Color(0xFF10B981).withOpacity(0.1),
                  const Color(0xFF06B6D4).withOpacity(0.1),
                ]
              : isSelected
              ? [
                  const Color(0xFF3B82F6).withOpacity(0.2),
                  const Color(0xFF6366F1).withOpacity(0.15),
                ]
              : [
                  const Color(0xFFF8FAFC),
                  const Color(0xFFE2E8F0).withOpacity(0.5),
                ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isRowNumber
              ? const Color(0xFF6366F1).withOpacity(0.3)
              : isActionColumn
              ? const Color(0xFFEC4899).withOpacity(0.3)
              : isStatusColumn
              ? const Color(0xFF10B981).withOpacity(0.3)
              : isSelected
              ? const Color(0xFF3B82F6).withOpacity(0.4)
              : const Color(0xFFE2E8F0).withOpacity(0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? const Color(0xFF3B82F6).withOpacity(0.1)
                : Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isActionColumn || isRowNumber
              ? null
              : () {
                  setState(() {
                    _sortColumnIndex = index;
                    _sortAscending = _sortColumnIndex == index
                        ? !_sortAscending
                        : true;

                    if (isStatusColumn) {
                      widget.data.sort((a, b) {
                        final aStatus =
                            widget.statusTextGetter?.call(a) ?? 'Inactive';
                        final bStatus =
                            widget.statusTextGetter?.call(b) ?? 'Inactive';
                        int aValue = aStatus == 'Active' ? 1 : 0;
                        int bValue = bStatus == 'Active' ? 1 : 0;
                        return _sortAscending
                            ? aValue.compareTo(bValue)
                            : bValue.compareTo(aValue);
                      });
                    } else if (index < widget.valueGetters.length) {
                      widget.data.sort((a, b) {
                        final aValue = widget.valueGetters[index](a);
                        final bValue = widget.valueGetters[index](b);
                        return _sortAscending
                            ? aValue.compareTo(bValue)
                            : bValue.compareTo(aValue);
                      });
                    }
                  });
                },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isRowNumber) ...[
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.format_list_numbered,
                    size: 14,
                    color: const Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(width: 6),
              ] else if (isActionColumn) ...[
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEC4899).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.settings,
                    size: 14,
                    color: const Color(0xFFEC4899),
                  ),
                ),
                const SizedBox(width: 6),
              ] else if (isStatusColumn) ...[
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.toggle_on,
                    size: 14,
                    color: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isRowNumber
                        ? const Color(0xFF6366F1)
                        : isActionColumn
                        ? const Color(0xFFEC4899)
                        : isStatusColumn
                        ? const Color(0xFF10B981)
                        : isSelected
                        ? const Color(0xFF1E40AF)
                        : const Color(0xFF374151),
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!isActionColumn && !isRowNumber) ...[
                const SizedBox(width: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      isSelected
                          ? (_sortAscending
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded)
                          : Icons.unfold_more_rounded,
                      key: ValueKey('$index-$isSelected-$_sortAscending'),
                      size: 16,
                      color: isSelected
                          ? const Color(0xFF1E40AF)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowNumber(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF6366F1).withOpacity(0.1),
              const Color(0xFF8B5CF6).withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6366F1),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: widget.onSearch == null
                  ? EdgeInsets.zero
                  : const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, const Color(0xFFF8FAFC)],
                  ),
                  borderRadius: BorderRadius.circular(
                    widget.onSearch == null ? 0 : 20,
                  ),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                  boxShadow: [
                    if (widget.onSearch != null) ...[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                        spreadRadius: -4,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                        spreadRadius: -2,
                      ),
                    ],
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced Header Section
                    if (widget.onSearch != null)
                      Container(
                        padding: const EdgeInsets.all(28.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [const Color(0xFFF8FAFC), Colors.white],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF3B82F6),
                                        Color(0xFF6366F1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF3B82F6,
                                        ).withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.table_view_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Data Table',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1F2937),
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    Text(
                                      'Manage and view your data efficiently',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: const Color(0xFF6B7280),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                // Enhanced Search Box
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(0xFFE2E8F0),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: SearchBox(
                                      onChanged: widget.onSearch!,
                                      hintText: widget.hintText,
                                    ),
                                  ),
                                ),
                                16.w,
                                widget.dropDownWidget ?? Container(),
                                16.w,
                                // Enhanced data count indicator
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(
                                          0xFF10B981,
                                        ).withOpacity(0.1),
                                        const Color(
                                          0xFF059669,
                                        ).withOpacity(0.1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF10B981,
                                      ).withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF10B981,
                                        ).withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF10B981,
                                          ).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.dataset_rounded,
                                          size: 14,
                                          color: const Color(0xFF065F46),
                                        ),
                                      ),
                                      8.w,
                                      Text(
                                        '${widget.data.length}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF065F46),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'items',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF047857),
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

                    // Enhanced Divider
                    if (widget.onSearch != null)
                      Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              const Color(0xFFE2E8F0).withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                    // Enhanced Table Section
                    Padding(
                      padding: widget.onSearch == null
                          ? EdgeInsets.zero
                          : const EdgeInsets.all(28.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            widget.onSearch == null ? 0 : 16,
                          ),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            widget.onSearch == null ? 0 : 16,
                          ),
                          child: Column(
                            children: [
                              // Custom Header Row
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFFF8FAFC),
                                      Colors.white,
                                    ],
                                  ),
                                ),
                                child: Scrollbar(
                                  controller: _horizontalScrollController,
                                  thumbVisibility: true,
                                  trackVisibility: true,
                                  child: SingleChildScrollView(
                                    controller: _horizontalScrollController,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        // Checkbox column
                                        if (widget.onSelectAll != null)
                                          Container(
                                            width: 60,
                                            padding: const EdgeInsets.only(
                                              right: 16,
                                            ),
                                            child: Checkbox(
                                              value:
                                                  widget
                                                      .selectedIds
                                                      .isNotEmpty &&
                                                  widget.selectedIds.length ==
                                                      widget.data.length,
                                              onChanged: widget.onSelectAll,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),

                                        // Row numbers header
                                        if (widget.showRowNumbers)
                                          Container(
                                            width: 80,
                                            padding: const EdgeInsets.only(
                                              right: 16,
                                            ),
                                            child: _buildEnhancedHeader(
                                              title: "#",
                                              index: -1,
                                              isRowNumber: true,
                                            ),
                                          ),

                                        // Data columns
                                        ...List.generate(
                                          widget.columns.length,
                                          (index) {
                                            return Container(
                                              width: 150,
                                              padding: const EdgeInsets.only(
                                                right: 16,
                                              ),
                                              child: _buildEnhancedHeader(
                                                title: widget.columns[index],
                                                index: index,
                                              ),
                                            );
                                          },
                                        ),

                                        // Status column
                                        if (widget.onStatus != null)
                                          Container(
                                            width: 120,
                                            padding: const EdgeInsets.only(
                                              right: 16,
                                            ),
                                            child: _buildEnhancedHeader(
                                              title: "Status".tr(),
                                              index: widget.columns.length,
                                              isStatusColumn: true,
                                            ),
                                          ),

                                        // Actions column
                                        if (widget.onEdit != null)
                                          SizedBox(
                                            width: 120,
                                            child: _buildEnhancedHeader(
                                              title: "Actions".tr(),
                                              index: widget.columns.length + 1,
                                              isActionColumn: true,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Table Body
                              Scrollbar(
                                controller: _horizontalScrollController,
                                child: SingleChildScrollView(
                                  controller: _horizontalScrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    dividerThickness: 0,
                                    showCheckboxColumn: false,
                                    // We'll handle this manually
                                    showBottomBorder: false,
                                    columnSpacing: 0,
                                    horizontalMargin: 0,
                                    headingRowHeight: 0,
                                    // Hide default header
                                    dataRowMinHeight: 60,
                                    dataRowMaxHeight: 72,
                                    columns: [
                                      // Hidden columns since we're using custom headers
                                      if (widget.onSelectAll != null)
                                        const DataColumn(
                                          label: SizedBox.shrink(),
                                        ),
                                      if (widget.showRowNumbers)
                                        const DataColumn(
                                          label: SizedBox.shrink(),
                                        ),
                                      ...List.generate(
                                        widget.columns.length,
                                        (index) => const DataColumn(
                                          label: SizedBox.shrink(),
                                        ),
                                      ),
                                      if (widget.onStatus != null)
                                        const DataColumn(
                                          label: SizedBox.shrink(),
                                        ),
                                      if (widget.onEdit != null)
                                        const DataColumn(
                                          label: SizedBox.shrink(),
                                        ),
                                    ],
                                    rows: widget.data.asMap().entries.map((
                                      entry,
                                    ) {
                                      final index = entry.key;
                                      final item = entry.value;
                                      final status =
                                          widget.statusTextGetter?.call(item) ??
                                          'inactive';
                                      final id = widget.getId(item);
                                      final isSelected = widget.selectedIds
                                          .contains(id);

                                      return DataRow(
                                        color:
                                            WidgetStateProperty.resolveWith<
                                              Color?
                                            >((states) {
                                              if (states.contains(
                                                    WidgetState.selected,
                                                  ) ||
                                                  isSelected) {
                                                return const Color(
                                                  0xFF3B82F6,
                                                ).withOpacity(0.08);
                                              }
                                              if (index.isEven) {
                                                return Colors.white;
                                              }
                                              return const Color(0xFFF8FAFC);
                                            }),
                                        cells: [
                                          // Checkbox cell
                                          if (widget.onSelectAll != null)
                                            DataCell(
                                              Container(
                                                width: 60,
                                                padding: const EdgeInsets.only(
                                                  right: 16,
                                                ),
                                                child: Checkbox(
                                                  value: isSelected,
                                                  onChanged: (value) =>
                                                      widget.onSelectChanged!(
                                                        value,
                                                        item,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                          // Row number cell
                                          if (widget.showRowNumbers)
                                            DataCell(
                                              Container(
                                                width: 80,
                                                padding: const EdgeInsets.only(
                                                  right: 16,
                                                ),
                                                child: _buildRowNumber(index),
                                              ),
                                            ),

                                          // Data cells
                                          ...List.generate(widget.valueGetters.length, (
                                            cellIndex,
                                          ) {
                                            final cellValue = widget
                                                .valueGetters[cellIndex](item);
                                            final colName = widget
                                                .columns[cellIndex]
                                                .toLowerCase();

                                            // Handle special columns (location, expenses, etc.)
                                            if ((colName.contains(
                                                      "pickup location",
                                                    ) ||
                                                    colName.contains(
                                                      "drop location",
                                                    )) &&
                                                widget.onLocationTap != null) {
                                              final parts = cellValue.split(
                                                '|',
                                              );
                                              final locationName =
                                                  parts.isNotEmpty
                                                  ? parts[0].trim()
                                                  : '';
                                              double? lat, lng;
                                              if (parts.length >= 3) {
                                                lat = double.tryParse(
                                                  parts[1].trim(),
                                                );
                                                lng = double.tryParse(
                                                  parts[2].trim(),
                                                );
                                              }
                                              return DataCell(
                                                Container(
                                                  width: 150,
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 16,
                                                        top: 8,
                                                        bottom: 8,
                                                      ),
                                                  child: GestureDetector(
                                                    onTap:
                                                        (lat != null &&
                                                            lng != null)
                                                        ? () =>
                                                              widget
                                                                  .onLocationTap!(
                                                                lat!,
                                                                lng!,
                                                              )
                                                        : null,
                                                    child: Text(
                                                      locationName,
                                                      style: const TextStyle(
                                                        color: Colors.blue,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }

                                            if (colName.contains(
                                                  "add expenses",
                                                ) &&
                                                widget.onAddExpensesPressed !=
                                                    null) {
                                              return DataCell(
                                                Container(
                                                  width: 150,
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 16,
                                                        top: 8,
                                                        bottom: 8,
                                                      ),
                                                  child: ElevatedButton.icon(
                                                    icon: const Icon(
                                                      Icons.attach_money,
                                                      size: 16,
                                                    ),
                                                    label: const Text(
                                                      "Add Expense",
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 8,
                                                          ),
                                                      backgroundColor:
                                                          const Color(
                                                            0xFF059669,
                                                          ).withOpacity(0.1),
                                                      foregroundColor:
                                                          const Color(
                                                            0xFF059669,
                                                          ),
                                                      elevation: 0,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                    onPressed: () =>
                                                        widget
                                                            .onAddExpensesPressed!(
                                                          item,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            }

                                            if (colName.contains("logo")) {
                                              return DataCell(
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 16,
                                                        top: 8,
                                                        bottom: 8,
                                                      ),
                                                  child: Container(
                                                    width: 150,
                                                    height: 80,
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                      border: Border.all(
                                                        color: AppTheme
                                                            .borderColor,
                                                      ),
                                                    ),
                                                    child: cellValue.isNotEmpty
                                                        ? ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  6,
                                                                ),
                                                            child: Image.network(
                                                              cellValue,
                                                              fit: BoxFit.cover,
                                                              errorBuilder:
                                                                  (
                                                                    _,
                                                                    __,
                                                                    ___,
                                                                  ) => Image.asset(
                                                                    'assets/icons/broken image.png',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                            ),
                                                          )
                                                        : Image.asset(
                                                            'assets/images/logo1.png',
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                ),
                                              );
                                            }

                                            if (colName.contains("services") &&
                                                widget.onServices != null) {
                                              return buildDataCellButton(
                                                title: "Show",
                                                onPress: () =>
                                                    widget.onServices!(item),
                                              );
                                            }
                                            if (colName.contains("products") &&
                                                widget.onProducts != null) {
                                              return buildDataCellButton(
                                                title: "Show",
                                                onPress: () =>
                                                    widget.onProducts!(item),
                                              );
                                            }

                                            return DataCell(
                                              Container(
                                                width: 150,
                                                padding: const EdgeInsets.only(
                                                  right: 16,
                                                  top: 8,
                                                  bottom: 8,
                                                ),
                                                child: _buildCellContent(
                                                  cellValue,
                                                  cellIndex,
                                                  item,
                                                ),
                                              ),
                                            );
                                          }),

                                          // Status cell
                                          if (widget.onStatus != null)
                                            DataCell(
                                              Container(
                                                width: 120,
                                                padding: const EdgeInsets.only(
                                                  right: 16,
                                                  top: 8,
                                                  bottom: 8,
                                                ),
                                                child: _buildStatusChip(
                                                  status,
                                                  item,
                                                ),
                                              ),
                                            ),

                                          // Actions cell
                                          if (widget.onEdit != null ||
                                              widget.onView != null ||
                                              widget.onEmail != null)
                                            DataCell(
                                              Container(
                                                width: 120,
                                                // you can reduce to ~56 if only menu/edit icon
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                alignment: Alignment.center,
                                                child: Consumer<MmResourceProvider>(
                                                  builder: (context, resource, child) {
                                                    debugPrint(
                                                      'resource: ${resource.employeeModel!.profileAccessKey}',
                                                    );
                                                    return _buildActionArea(
                                                      item,
                                                      resource,
                                                      widget
                                                          .editProfileAccessKey,
                                                      widget
                                                          .deleteProfileAccessKey,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),

                                          // if (widget.onEdit != null)
                                          //   DataCell(
                                          //     Container(
                                          //       width: 120,
                                          //       padding:
                                          //           const EdgeInsets.symmetric(
                                          //             vertical: 8,
                                          //           ),
                                          //       child: _buildActionButtons(
                                          //         item,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // if (widget.onEmail != null)
                                          //   DataCell(
                                          //     Container(
                                          //       width: 120,
                                          //       padding:
                                          //           const EdgeInsets.symmetric(
                                          //             vertical: 8,
                                          //           ),
                                          //       child: _buildActionButtons(
                                          //         item,
                                          //       ),
                                          //     ),
                                          //   ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCellContent(String value, int cellIndex, T item) {
    if (widget.isWithImage && cellIndex == widget.combineImageWithTextIndex) {
      final parts = value.split(',');
      final productName = parts[0].trim();
      final imageUrl = parts.length > 1 ? parts[1].trim() : null;

      if (imageUrl == null) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.broken_image_rounded,
                  color: Color(0xFF64748B),
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  imageUrl,
                  height: 32,
                  width: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.broken_image_rounded,
                      color: Color(0xFF64748B),
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF1F2937),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (widget.createByIndex != -1 && cellIndex == widget.createByIndex) {
      return ProfileWidgetForDatatable(key: ValueKey(value), userId: value);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
          color: Color(0xFF374151),
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStatusChip(String status, T item) {
    final isActive = status.toLowerCase() == 'active';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onStatus!(item),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isActive
                  ? [
                      const Color(0xFF10B981).withOpacity(0.1),
                      const Color(0xFF059669).withOpacity(0.15),
                    ]
                  : [
                      const Color(0xFFF59E0B).withOpacity(0.1),
                      const Color(0xFFEF4444).withOpacity(0.1),
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive
                  ? const Color(0xFF10B981).withOpacity(0.4)
                  : const Color(0xFFF59E0B).withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? const Color(0xFF10B981).withOpacity(0.1)
                    : const Color(0xFFF59E0B).withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (isActive
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFF59E0B))
                              .withOpacity(0.4),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                status.tr(),
                style: TextStyle(
                  color: isActive
                      ? const Color(0xFF065F46)
                      : const Color(0xFF92400E),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(T item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.onView != null) ...[
          buildActionButton(
            icon: Icons.visibility_rounded,
            color: const Color(0xFF3B82F6),
            onTap: () => widget.onView!(item),
            tooltip: 'View',
          ),
          const SizedBox(width: 8),
        ],
        if (widget.onEmail != null) ...[
          buildActionButton(
            icon: Icons.email_rounded,
            color: const Color(0xFF8F11DA),
            onTap: () => widget.onView!(item),
            tooltip: 'Email',
          ),
          const SizedBox(width: 8),
        ],
        buildActionButton(
          icon: Icons.edit_rounded,
          color: const Color(0xFF059669),
          onTap: () => widget.onEdit!(item),
          tooltip: 'Edit',
        ),
      ],
    );
  }

  Widget _buildActionArea(
    T item,
    MmResourceProvider resource,
    String? permissionAccessKey,
    String? deletePermission,
  ) {
    final hasView = widget.onView != null;
    final hasEmail = widget.onEmail != null;
    final hasEdit = widget.onEdit != null;
    final hasDelete = widget.onDelete != null;

    // If only edit exists → show a single edit button (no menu)
    if (hasEdit && !hasView && !hasEmail && !hasDelete) {
      return buildActionButton(
        icon: Icons.edit_rounded,
        color: const Color(0xFF059669),
        onTap: () => widget.onEdit!(item),
        tooltip: 'Edit',
      );
    }

    // Else show a compact 3-dots popup menu
    return PopupMenuButton<RowAction>(
      tooltip: 'Menu',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF059669).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Color(0xFF059669).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.more_horiz_rounded,
          size: 16,
          color: Color(0xFF059669),
        ),
      ),

      // buildActionButton(
      //   icon:
      //   color: const ,
      //   onTap: () {}, // ignored by PopupMenuButton
      //   tooltip: 'Menu',
      // ),
      onSelected: (action) {
        switch (action) {
          case RowAction.view:
            widget.onView?.call(item);
            break;
          case RowAction.email:
            widget.onEmail?.call(item); // ✅ email callback
            break;
          case RowAction.edit:
            widget.onEdit?.call(item);
            break;
          case RowAction.delete:
            widget.onDelete?.call(item);
            break;
        }
      },
      itemBuilder: (context) {
        final entries = <PopupMenuEntry<RowAction>>[];
        if (hasView) {
          entries.add(
            PopupMenuItem(
              value: RowAction.view,
              child: menuItem(
                Icons.visibility_rounded,
                const Color(0xFF3B82F6),
                'View',
              ),
            ),
          );
        }
        if (hasEmail) {
          entries.add(
            PopupMenuItem(
              value: RowAction.email,
              child: menuItem(
                Icons.email_rounded,
                const Color(0xFF8F11DA),
                'Email',
              ),
            ),
          );
        }
        bool canEdit(String? permissionAccessKey) {
          User? user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return false;
          } else if (user.uid == Constants.adminId) {
            return hasEdit && true;
          }
          debugPrint("hasEdit: $hasEdit, key: $permissionAccessKey");
          if (permissionAccessKey == null || permissionAccessKey.isEmpty) {
            return hasEdit;
          }
          final keys = resource.employeeModel!.profileAccessKey ?? [];
          final allowed = keys.contains(permissionAccessKey);
          return hasEdit && allowed;
        }

        bool canDelete(String? deletePermission) {
          if (deletePermission == null || deletePermission.isEmpty) {
            return hasDelete;
          }
          final keys = resource.employeeModel!.profileAccessKey ?? [];
          final allowed = keys.contains(deletePermission);
          return hasDelete && allowed;
        }

        //
        // if (hasEdit &&
        //     resource.employeeModel!.editProfileAccessKey!.contains(
        //       permissionAccessKey,
        //     ))
        if (canEdit(permissionAccessKey)) {
          entries.add(
            PopupMenuItem(
              value: RowAction.edit,
              child: menuItem(
                Icons.edit_rounded,
                const Color(0xFF059669),
                'Edit',
              ),
            ),
          );
        }
        if (canDelete(deletePermission)) {
          entries.add(
            PopupMenuItem(
              value: RowAction.delete,
              child: menuItem(Icons.delete, const Color(0xFFDA1414), 'Delete'),
            ),
          );
        }
        return entries;
      },
    );
  }
}
