// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class CreditDaysManager extends StatefulWidget {
//   final List<int> initialCreditDays;
//   final Future<void> Function(List<int>) onCreditDaysUpdated;
//   final bool enableEditing;
//   final String? title;

//   const CreditDaysManager({
//     Key? key,
//     required this.initialCreditDays,
//     required this.onCreditDaysUpdated,
//     this.enableEditing = true,
//     this.title = 'Credit Terms Configuration',
//   }) : super(key: key);

//   @override
//   _CreditDaysManagerState createState() => _CreditDaysManagerState();
// }

// class _CreditDaysManagerState extends State<CreditDaysManager> {
//   late List<int> _creditDays;
//   final TextEditingController _newDaysController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _creditDays = List.from(widget.initialCreditDays);
//     _sortCreditDays();
//   }

//   void _sortCreditDays() {
//     _creditDays.sort((a, b) => a.compareTo(b));
//   }

//   Future<void> _addCreditDays() async {
//     if (!_formKey.currentState!.validate()) return;

//     final days = int.tryParse(_newDaysController.text);
//     if (days == null || _creditDays.contains(days)) return;

//     setState(() => _isLoading = true);

//     try {
//       final updatedDays = List<int>.from(_creditDays)..add(days);
//       updatedDays.sort();

//       await widget.onCreditDaysUpdated(updatedDays);

//       setState(() {
//         _creditDays = updatedDays;
//         _newDaysController.clear();
//       });
//     } catch (e) {
//       _showErrorDialog('Failed to add credit days: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _updateCreditDay(int oldValue, int newValue) async {
//     if (_creditDays.contains(newValue)) return;

//     setState(() => _isLoading = true);

//     try {
//       final updatedDays = List<int>.from(_creditDays)
//         ..remove(oldValue)
//         ..add(newValue);
//       updatedDays.sort();

//       await widget.onCreditDaysUpdated(updatedDays);

//       setState(() {
//         _creditDays = updatedDays;
//       });
//     } catch (e) {
//       _showErrorDialog('Failed to update credit days: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _removeCreditDay(int days) async {
//     setState(() => _isLoading = true);

//     try {
//       final updatedDays = List<int>.from(_creditDays)..remove(days);
//       await widget.onCreditDaysUpdated(updatedDays);

//       setState(() {
//         _creditDays = updatedDays;
//       });
//     } catch (e) {
//       _showErrorDialog('Failed to remove credit days: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => EnterpriseDialog(
//         title: 'Operation Failed',
//         content: Text(message),
//         primaryAction: 'OK',
//         onPrimaryAction: () => Navigator.of(context).pop(),
//       ),
//     );
//   }

//   String? _validateDays(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Credit days value is required';
//     }

//     final days = int.tryParse(value);
//     if (days == null) {
//       return 'Enter a valid number';
//     }

//     if (days < 0) return 'Value cannot be negative';
//     if (days > 365) return 'Maximum 365 days allowed';
//     if (_creditDays.contains(days)) return 'Term already exists';

//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 16,
//             offset: const Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: Colors.grey.shade200, width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Header Section
//           _buildHeader(),

//           // Add Form Section
//           if (widget.enableEditing) _buildAddForm(),

//           // List Section
//           _buildCreditDaysList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Colors.grey.shade100, width: 1),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//               ),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Icon(
//               Icons.credit_score,
//               color: Colors.white,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.title!,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   'Manage payment terms and credit periods',
//                   style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade50,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Text(
//               '${_creditDays.length}',
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF2B6CB0),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAddForm() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Colors.grey.shade100, width: 1),
//         ),
//       ),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'ADD NEW CREDIT TERM',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey.shade500,
//                 letterSpacing: 0.5,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _newDaysController,
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     decoration: InputDecoration(
//                       labelText: 'Credit Days',
//                       hintText: 'Enter number of days',
//                       prefixIcon: const Icon(Icons.calendar_today, size: 20),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 14,
//                       ),
//                     ),
//                     style: const TextStyle(fontSize: 14),
//                     validator: _validateDays,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   child: _isLoading
//                       ? const SizedBox(
//                           width: 48,
//                           height: 48,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : ElevatedButton(
//                           onPressed: _addCreditDays,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF667eea),
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 14,
//                             ),
//                             elevation: 0,
//                             shadowColor: Colors.transparent,
//                           ),
//                           child: const Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(Icons.add, size: 18),
//                               SizedBox(width: 6),
//                               Text(
//                                 'Add Term',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                             ],
//                           ),
//                         ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCreditDaysList() {
//     return ConstrainedBox(
//       constraints: const BoxConstraints(maxHeight: 400),
//       child: _creditDays.isEmpty ? _buildEmptyState() : _buildListContent(),
//     );
//   }

//   Widget _buildListContent() {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           decoration: BoxDecoration(
//             border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
//             color: Colors.grey.shade50,
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: Text(
//                   'TERM',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey.shade600,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 3,
//                 child: Text(
//                   'DESCRIPTION',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey.shade600,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//               ),
//               if (widget.enableEditing)
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'ACTIONS',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey.shade600,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             physics: const ClampingScrollPhysics(),
//             itemCount: _creditDays.length,
//             itemBuilder: (context, index) =>
//                 _buildCreditDayItem(_creditDays[index], index),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCreditDayItem(int days, int index) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Colors.grey.shade50, width: 1),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 2,
//               child: Row(
//                 children: [
//                   Container(
//                     width: 32,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       color: _getColorForIndex(index).withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.access_time,
//                       size: 16,
//                       color: _getColorForIndex(index),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     '$days',
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF2D3748),
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     'days',
//                     style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 3,
//               child: Text(
//                 _getCreditPeriodDescription(days),
//                 style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
//               ),
//             ),
//             if (widget.enableEditing)
//               Expanded(
//                 flex: 2,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     _buildActionButton(
//                       icon: Icons.edit_outlined,
//                       color: Colors.blue.shade600,
//                       onPressed: () => _showEditDialog(days),
//                     ),
//                     const SizedBox(width: 8),
//                     _buildActionButton(
//                       icon: Icons.delete_outline,
//                       color: Colors.red.shade600,
//                       onPressed: () => _showDeleteDialog(days),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return Container(
//       width: 32,
//       height: 32,
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         shape: BoxShape.circle,
//       ),
//       child: IconButton(
//         icon: Icon(icon, size: 16),
//         color: color,
//         onPressed: onPressed,
//         padding: EdgeInsets.zero,
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 60),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade50,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.credit_score_outlined,
//               size: 32,
//               color: Colors.grey.shade400,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'No Credit Terms',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Text(
//               'Add your first credit term to get started with payment period configurations',
//               style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getColorForIndex(int index) {
//     final colors = [
//       const Color(0xFF667eea),
//       const Color(0xFF764ba2),
//       const Color(0xFFf093fb),
//       const Color(0xFF4facfe),
//     ];
//     return colors[index % colors.length];
//   }

//   String _getCreditPeriodDescription(int days) {
//     final descriptions = {
//       0: 'Due on Receipt - Payment immediately upon invoice receipt',
//       1: 'Next Day - Payment due the following business day',
//       7: 'Net 7 - Payment due within 7 days',
//       14: 'Net 14 - Payment due within 14 days',
//       15: 'Half Month - Payment due in 15 days',
//       30: 'Net 30 - Payment due within 30 days',
//       45: 'Net 45 - Payment due within 45 days',
//       60: 'Net 60 - Payment due within 60 days',
//       90: 'Net 90 - Payment due within 90 days',
//     };

//     return descriptions[days] ?? 'Net $days - Payment due within $days days';
//   }

//   void _showEditDialog(int currentDays) {
//     final controller = TextEditingController(text: currentDays.toString());

//     showDialog(
//       context: context,
//       builder: (context) => EnterpriseDialog(
//         title: 'Edit Credit Term',
//         content: Form(
//           child: TextFormField(
//             controller: controller,
//             keyboardType: TextInputType.number,
//             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//             decoration: const InputDecoration(
//               labelText: 'Credit Days',
//               border: OutlineInputBorder(),
//             ),
//             validator: _validateDays,
//             autofocus: true,
//           ),
//         ),
//         primaryAction: 'Update',
//         secondaryAction: 'Cancel',
//         onPrimaryAction: () {
//           if (_formKey.currentState!.validate()) {
//             final newDays = int.tryParse(controller.text);
//             if (newDays != null) {
//               _updateCreditDay(currentDays, newDays);
//             }
//           }
//         },
//       ),
//     );
//   }

//   void _showDeleteDialog(int days) {
//     showDialog(
//       context: context,
//       builder: (context) => EnterpriseDialog(
//         title: 'Delete Credit Term',
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Are you sure you want to delete the "$days Days" credit term?',
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'This action cannot be undone.',
//               style: TextStyle(color: Colors.red.shade600, fontSize: 13),
//             ),
//           ],
//         ),
//         primaryAction: 'Delete',
//         secondaryAction: 'Cancel',
//         primaryActionColor: Colors.red,
//         onPrimaryAction: () => _removeCreditDay(days),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _newDaysController.dispose();
//     super.dispose();
//   }
// }

// class EnterpriseDialog extends StatelessWidget {
//   final String title;
//   final Widget content;
//   final String primaryAction;
//   final String? secondaryAction;
//   final VoidCallback? onPrimaryAction;
//   final VoidCallback? onSecondaryAction;
//   final Color? primaryActionColor;

//   const EnterpriseDialog({
//     Key? key,
//     required this.title,
//     required this.content,
//     required this.primaryAction,
//     this.secondaryAction,
//     this.onPrimaryAction,
//     this.onSecondaryAction,
//     this.primaryActionColor,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 0,
//       backgroundColor: Colors.white,
//       child: Container(
//         padding: const EdgeInsets.all(24),
//         width: 400,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF2D3748),
//               ),
//             ),
//             const SizedBox(height: 20),
//             content,
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 if (secondaryAction != null)
//                   TextButton(
//                     onPressed:
//                         onSecondaryAction ?? () => Navigator.of(context).pop(),
//                     child: Text(secondaryAction!),
//                   ),
//                 const SizedBox(width: 12),
//                 ElevatedButton(
//                   onPressed:
//                       onPrimaryAction ?? () => Navigator.of(context).pop(),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         primaryActionColor ?? const Color(0xFF667eea),
//                     foregroundColor: Colors.white,
//                   ),
//                   child: Text(primaryAction),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// enterprise_credit_days_manager.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/firebase_services/data_upload_service.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';

class CreditDaysManager extends StatefulWidget {
  final bool enableEditing;

  const CreditDaysManager({super.key, this.enableEditing = true});

  @override
  CreditDaysManagerState createState() => CreditDaysManagerState();
}

class CreditDaysManagerState extends State<CreditDaysManager> {
  late List<int> _creditDays;
  final TextEditingController _newDaysController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isInitializing = true;
  User? user;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final creditDaysDoc = await DataFetchService.getCreditDays();
      setState(() {
        _creditDays = creditDaysDoc.creditDays;
        _isInitializing = false;
      });
    } catch (e) {
      _showErrorDialog(
        'Initialization Error',
        'Failed to load credit days: $e',
      );
      setState(() {
        _isInitializing = false;
        _creditDays = [];
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    try {
      final creditDaysDoc = await DataFetchService.getCreditDays();
      setState(() {
        _creditDays = creditDaysDoc.creditDays;
      });
      _showSuccessSnackbar('Data refreshed successfully');
    } catch (e) {
      _showErrorDialog('Refresh Error', 'Failed to refresh credit days: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addCreditDays() async {
    if (!_formKey.currentState!.validate()) return;

    final days = int.tryParse(_newDaysController.text);
    if (days == null || _creditDays.contains(days)) return;

    setState(() => _isLoading = true);

    try {
      final updatedDays = List<int>.from(_creditDays)..add(days);
      updatedDays.sort();

      await DataUploadService.updateCreditDays(
        updatedDays,
        updatedBy: user!.uid,
      );

      setState(() {
        _creditDays = updatedDays;
        _newDaysController.clear();
      });

      _showSuccessSnackbar('Credit term added successfully');
    } catch (e) {
      _showErrorDialog('Update Failed', 'Failed to add credit days: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateCreditDay(int oldValue, int newValue) async {
    if (_creditDays.contains(newValue)) return;

    setState(() => _isLoading = true);

    try {
      final updatedDays = List<int>.from(_creditDays)
        ..remove(oldValue)
        ..add(newValue);
      updatedDays.sort();

      await DataUploadService.updateCreditDays(
        updatedDays,
        updatedBy: user!.uid,
      );

      setState(() {
        _creditDays = updatedDays;
      });

      _showSuccessSnackbar('Credit term updated successfully');
    } catch (e) {
      _showErrorDialog('Update Failed', 'Failed to update credit days: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeCreditDay(int days) async {
    setState(() => _isLoading = true);

    try {
      final updatedDays = List<int>.from(_creditDays)..remove(days);
      await DataUploadService.updateCreditDays(
        updatedDays,
        updatedBy: user!.uid,
      );

      setState(() {
        _creditDays = updatedDays;
      });

      _showSuccessSnackbar('Credit term deleted successfully');
    } catch (e) {
      _showErrorDialog('Delete Failed', 'Failed to remove credit days: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => EnterpriseDialog(
        title: title,
        content: Text(message),
        primaryAction: 'OK',
        onPrimaryAction: () => Navigator.of(context).pop(),
      ),
    );
  }

  String? _validateDays(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit days value is required';
    }

    final days = int.tryParse(value);
    if (days == null) {
      return 'Enter a valid number';
    }

    if (days < 0) return 'Value cannot be negative';
    if (days > 365) return 'Maximum 365 days allowed';
    if (_creditDays.contains(days)) return 'Term already exists';

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return _buildLoadingState();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          if (widget.enableEditing) _buildAddForm(),
          _isLoading ? _buildProgressIndicator() : _buildCreditDaysList(),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 120),
          Center(child: CircularProgressIndicator()),
          SizedBox(height: 16),
          Text(
            'Loading Credit Terms...',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Updating...',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.credit_score,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Credit Terms Configuration',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Manage payment terms and credit periods',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.grey.shade600, size: 20),
            onPressed: _isLoading ? null : _refreshData,
            tooltip: 'Refresh data',
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${_creditDays.length}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2B6CB0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ADD NEW CREDIT TERM',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _newDaysController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Credit Days',
                      hintText: 'Enter number of days',
                      prefixIcon: const Icon(Icons.calendar_today, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                    validator: _validateDays,
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: _isLoading
                      ? const SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : ElevatedButton(
                          onPressed: _addCreditDays,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667eea),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Add Term',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditDaysList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 400),
      child: _creditDays.isEmpty ? _buildEmptyState() : _buildListContent(),
    );
  }

  Widget _buildListContent() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            color: Colors.grey.shade50,
          ),
          child: const Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'TERM',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'DESCRIPTION',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'ACTIONS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: _creditDays.length,
            itemBuilder: (context, index) =>
                _buildCreditDayItem(_creditDays[index], index),
          ),
        ),
      ],
    );
  }

  Widget _buildCreditDayItem(int days, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade50, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _getColorForIndex(index).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.access_time,
                      size: 16,
                      color: _getColorForIndex(index),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$days',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'days',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                _getCreditPeriodDescription(days),
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    icon: Icons.edit_outlined,
                    color: Colors.blue.shade600,
                    onPressed: () => _showEditDialog(days),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: Icons.delete_outline,
                    color: Colors.red.shade600,
                    onPressed: () => _showDeleteDialog(days),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: 16),
        color: color,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.credit_score_outlined,
              size: 32,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No Credit Terms',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Add your first credit term to get started with payment period configurations',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      const Color(0xFF667eea),
      const Color(0xFF764ba2),
      const Color(0xFFf093fb),
      const Color(0xFF4facfe),
    ];
    return colors[index % colors.length];
  }

  String _getCreditPeriodDescription(int days) {
    final descriptions = {
      0: 'Due on Receipt - Payment immediately upon invoice receipt',
      1: 'Next Day - Payment due the following business day',
      7: 'Net 7 - Payment due within 7 days',
      14: 'Net 14 - Payment due within 14 days',
      15: 'Half Month - Payment due in 15 days',
      30: 'Net 30 - Payment due within 30 days',
      45: 'Net 45 - Payment due within 45 days',
      60: 'Net 60 - Payment due within 60 days',
      90: 'Net 90 - Payment due within 90 days',
    };

    return descriptions[days] ?? 'Net $days - Payment due within $days days';
  }

  void _showEditDialog(int currentDays) {
    final controller = TextEditingController(text: currentDays.toString());

    showDialog(
      context: context,
      builder: (context) => EnterpriseDialog(
        title: 'Edit Credit Term',
        content: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Credit Days',
            border: OutlineInputBorder(),
          ),
          validator: _validateDays,
          autofocus: true,
        ),
        primaryAction: 'Update',
        secondaryAction: 'Cancel',
        onPrimaryAction: () {
          //if (_formKey.currentState!.validate()) {
          final newDays = int.tryParse(controller.text);
          if (newDays != null) {
            _updateCreditDay(currentDays, newDays);
            Navigator.of(context).pop();
            // }
          }
        },
        onSecondaryAction: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showDeleteDialog(int days) {
    showDialog(
      context: context,
      builder: (context) => EnterpriseDialog(
        title: 'Delete Credit Term',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete the "$days Days" credit term?',
            ),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone.',
              style: TextStyle(color: Colors.red.shade600, fontSize: 13),
            ),
          ],
        ),
        primaryAction: 'Delete',
        secondaryAction: 'Cancel',
        primaryActionColor: Colors.red,
        onPrimaryAction: () {
          _removeCreditDay(days);
          Navigator.of(context).pop();
        },
        onSecondaryAction: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  void dispose() {
    _newDaysController.dispose();
    super.dispose();
  }
}

class EnterpriseDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String primaryAction;
  final String? secondaryAction;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final Color? primaryActionColor;

  const EnterpriseDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.primaryAction,
    this.secondaryAction,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.primaryActionColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 20),
            content,
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (secondaryAction != null)
                  TextButton(
                    onPressed: onSecondaryAction,
                    child: Text(secondaryAction!),
                  ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onPrimaryAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        primaryActionColor ?? const Color(0xFF667eea),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(primaryAction),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
