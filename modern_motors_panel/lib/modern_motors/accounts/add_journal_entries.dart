// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:modern_motors_panel/model/chartoAccounts_model.dart';
// // import 'package:modern_motors_panel/modern_motors/chart_of_account_service.dart';

// // class JournalEntryLine {
// //   String? accountId;
// //   String? accountName;
// //   String description;
// //   double debit;
// //   double credit;

// //   JournalEntryLine({
// //     this.accountId,
// //     this.accountName,
// //     this.description = '',
// //     this.debit = 0.0,
// //     this.credit = 0.0,
// //   });

// //   bool get isValid => accountId != null && (debit > 0 || credit > 0);
// // }

// // class AddJournalEntry extends StatefulWidget {
// //   final String branchId;
// //   final Function(List<JournalEntryLine>)? onSave;

// //   const AddJournalEntry({Key? key, required this.branchId, this.onSave})
// //     : super(key: key);

// //   @override
// //   State<AddJournalEntry> createState() => _AddJournalEntryState();
// // }

// // class _AddJournalEntryState extends State<AddJournalEntry> {
// //   final ChartAccountService _accountService = ChartAccountService();
// //   final List<JournalEntryLine> _entries = [];
// //   List<ChartAccount> _allAccounts = [];
// //   bool _isLoadingAccounts = true;
// //   final _formKey = GlobalKey<FormState>();
// //   DateTime _selectedDate = DateTime.now();
// //   final _referenceController = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadAccounts();
// //     _addNewLine();
// //   }

// //   // Future<void> _loadAccounts() async {
// //   //   try {
// //   //     // final accounts = await _accountService.getAllAccountsForBranch(
// //   //     //   widget.branchId,
// //   //     // );
// //   //     // setState(() {
// //   //     //   _allAccounts = accounts;
// //   //     //   _isLoadingAccounts = false;
// //   //     // });
// //   //        final subscription = _accountService.watchAllAccounts().listen(
// //   //       (accountsData) {
// //   //         if (mounted) {
// //   //           final allAccounts = _flattenAllAccounts(accountsData);
// //   //           setState(() {
// //   //             _allAccounts = allAccounts;
// //   //             _isLoadingAccounts = false;
// //   //           });
// //   //         }
// //   //       },
// //   //   } catch (e) {
// //   //     setState(() {
// //   //       _isLoadingAccounts = false;
// //   //     });
// //   //     if (mounted) {
// //   //       ScaffoldMessenger.of(context).showSnackBar(
// //   //         SnackBar(
// //   //           content: Text('Error loading accounts: $e'),
// //   //           backgroundColor: Colors.red,
// //   //         ),
// //   //       );
// //   //     }
// //   //   }
// //   // }

// //    Future<void> _loadAccounts() async {
// //     setState(() {
// //       _isLoadingAccounts = true;
// //       _errorLoadingAccounts = null;
// //     });

// //     try {
// //       final subscription = _accountService.watchAllAccounts().listen(
// //         (accountsData) {
// //           if (mounted) {
// //             final allAccounts = _flattenAllAccounts(accountsData);
// //             setState(() {
// //               _allAccounts = allAccounts;
// //               _isLoadingAccounts = false;
// //             });
// //           }
// //         },
// //         onError: (error) {
// //           if (mounted) {
// //             setState(() {
// //               _errorLoadingAccounts = error.toString();
// //               _isLoadingAccounts = false;
// //             });
// //           }
// //         },
// //       );

// //       await subscription.asFuture<void>();
// //       await subscription.cancel();
// //     } catch (e) {
// //       if (mounted) {
// //         setState(() {
// //           _errorLoadingAccounts = e.toString();
// //           _isLoadingAccounts = false;
// //         });
// //       }
// //     }
// //   }

// //   void _addNewLine() {
// //     setState(() {
// //       _entries.add(JournalEntryLine());
// //     });
// //   }

// //   void _removeLine(int index) {
// //     if (_entries.length > 1) {
// //       setState(() {
// //         _entries.removeAt(index);
// //       });
// //     }
// //   }

// //   void _moveLineUp(int index) {
// //     if (index > 0) {
// //       setState(() {
// //         final item = _entries.removeAt(index);
// //         _entries.insert(index - 1, item);
// //       });
// //     }
// //   }

// //   void _moveLineDown(int index) {
// //     if (index < _entries.length - 1) {
// //       setState(() {
// //         final item = _entries.removeAt(index);
// //         _entries.insert(index + 1, item);
// //       });
// //     }
// //   }

// //   double get _totalDebit {
// //     return _entries.fold(0.0, (sum, entry) => sum + entry.debit);
// //   }

// //   double get _totalCredit {
// //     return _entries.fold(0.0, (sum, entry) => sum + entry.credit);
// //   }

// //   bool get _isBalanced {
// //     return (_totalDebit - _totalCredit).abs() < 0.01;
// //   }

// //   double get _difference {
// //     return _totalDebit - _totalCredit;
// //   }

// //   void _saveEntry() {
// //     if (!_isBalanced) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Debit and Credit must be equal!'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }

// //     if (!_entries.any((e) => e.isValid)) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Please add at least one valid entry!'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }

// //     widget.onSave?.call(_entries.where((e) => e.isValid).toList());
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Add Journal Entry'),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.save),
// //             onPressed: _saveEntry,
// //             tooltip: 'Save Entry',
// //           ),
// //         ],
// //       ),
// //       body: _isLoadingAccounts
// //           ? Center(child: CircularProgressIndicator())
// //           : Column(
// //               children: [
// //                 _buildHeader(),
// //                 Expanded(
// //                   child: SingleChildScrollView(
// //                     child: Column(
// //                       children: [_buildEntriesTable(), _buildTotalsSection()],
// //                     ),
// //                   ),
// //                 ),
// //                 _buildFooter(),
// //               ],
// //             ),
// //     );
// //   }

// //   Widget _buildHeader() {
// //     return Container(
// //       padding: EdgeInsets.all(16),
// //       color: Colors.grey[100],
// //       child: Column(
// //         children: [
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: InkWell(
// //                   onTap: () => _selectDate(context),
// //                   child: InputDecorator(
// //                     decoration: InputDecoration(
// //                       labelText: 'Date',
// //                       border: OutlineInputBorder(),
// //                       suffixIcon: Icon(Icons.calendar_today),
// //                     ),
// //                     child: Text(
// //                       '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(width: 16),
// //               Expanded(
// //                 child: TextField(
// //                   controller: _referenceController,
// //                   decoration: InputDecoration(
// //                     labelText: 'Reference No.',
// //                     border: OutlineInputBorder(),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Future<void> _selectDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: _selectedDate,
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime(2030),
// //     );
// //     if (picked != null && picked != _selectedDate) {
// //       setState(() {
// //         _selectedDate = picked;
// //       });
// //     }
// //   }

// //   Widget _buildEntriesTable() {
// //     return Container(
// //       padding: EdgeInsets.all(16),
// //       child: Column(
// //         children: [
// //           _buildTableHeader(),
// //           ListView.builder(
// //             shrinkWrap: true,
// //             physics: NeverScrollableScrollPhysics(),
// //             itemCount: _entries.length,
// //             itemBuilder: (context, index) {
// //               return _buildEntryRow(index);
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTableHeader() {
// //     return Container(
// //       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
// //       decoration: BoxDecoration(
// //         color: Colors.blue[700],
// //         borderRadius: BorderRadius.only(
// //           topLeft: Radius.circular(8),
// //           topRight: Radius.circular(8),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           SizedBox(width: 80), // Space for controls
// //           Expanded(
// //             flex: 3,
// //             child: Text(
// //               'Account',
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ),
// //           SizedBox(width: 8),
// //           Expanded(
// //             flex: 3,
// //             child: Text(
// //               'Description',
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ),
// //           SizedBox(width: 8),
// //           Expanded(
// //             flex: 2,
// //             child: Text(
// //               'Debit',
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //               ),
// //               textAlign: TextAlign.right,
// //             ),
// //           ),
// //           SizedBox(width: 8),
// //           Expanded(
// //             flex: 2,
// //             child: Text(
// //               'Credit',
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //               ),
// //               textAlign: TextAlign.right,
// //             ),
// //           ),
// //           SizedBox(width: 48), // Space for delete button
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildEntryRow(int index) {
// //     final entry = _entries[index];

// //     return Container(
// //       margin: EdgeInsets.only(bottom: 8),
// //       padding: EdgeInsets.all(8),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         border: Border.all(color: Colors.grey[300]!),
// //         borderRadius: BorderRadius.circular(4),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 4,
// //             offset: Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Move up/down controls
// //           Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               IconButton(
// //                 icon: Icon(Icons.arrow_upward, size: 16),
// //                 onPressed: index > 0 ? () => _moveLineUp(index) : null,
// //                 padding: EdgeInsets.zero,
// //                 constraints: BoxConstraints(minWidth: 32, minHeight: 32),
// //               ),
// //               IconButton(
// //                 icon: Icon(Icons.arrow_downward, size: 16),
// //                 onPressed: index < _entries.length - 1
// //                     ? () => _moveLineDown(index)
// //                     : null,
// //                 padding: EdgeInsets.zero,
// //                 constraints: BoxConstraints(minWidth: 32, minHeight: 32),
// //               ),
// //             ],
// //           ),

// //           // Account dropdown
// //           Expanded(
// //             flex: 3,
// //             child: DropdownButtonFormField<String>(
// //               value: entry.accountId,
// //               decoration: InputDecoration(
// //                 border: OutlineInputBorder(),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   horizontal: 12,
// //                   vertical: 8,
// //                 ),
// //                 isDense: true,
// //               ),
// //               hint: Text('Select Account'),
// //               items: _allAccounts.map((account) {
// //                 return DropdownMenuItem(
// //                   value: account.id,
// //                   child: Text(
// //                     '${account.accountCode} - ${account.accountName}',
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 );
// //               }).toList(),
// //               onChanged: (value) {
// //                 setState(() {
// //                   entry.accountId = value;
// //                   entry.accountName = _allAccounts
// //                       .firstWhere((a) => a.id == value)
// //                       .accountName;
// //                 });
// //               },
// //             ),
// //           ),
// //           SizedBox(width: 8),

// //           // Description
// //           Expanded(
// //             flex: 3,
// //             child: TextField(
// //               decoration: InputDecoration(
// //                 border: OutlineInputBorder(),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   horizontal: 12,
// //                   vertical: 8,
// //                 ),
// //                 isDense: true,
// //               ),
// //               onChanged: (value) {
// //                 entry.description = value;
// //               },
// //             ),
// //           ),
// //           SizedBox(width: 8),

// //           // Debit
// //           Expanded(
// //             flex: 2,
// //             child: TextField(
// //               decoration: InputDecoration(
// //                 border: OutlineInputBorder(),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   horizontal: 12,
// //                   vertical: 8,
// //                 ),
// //                 isDense: true,
// //                 prefixText: 'OMR ',
// //               ),
// //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //               inputFormatters: [
// //                 FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
// //               ],
// //               textAlign: TextAlign.right,
// //               onChanged: (value) {
// //                 setState(() {
// //                   entry.debit = double.tryParse(value) ?? 0.0;
// //                   if (entry.debit > 0) entry.credit = 0.0;
// //                 });
// //               },
// //             ),
// //           ),
// //           SizedBox(width: 8),

// //           // Credit
// //           Expanded(
// //             flex: 2,
// //             child: TextField(
// //               decoration: InputDecoration(
// //                 border: OutlineInputBorder(),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   horizontal: 12,
// //                   vertical: 8,
// //                 ),
// //                 isDense: true,
// //                 prefixText: 'OMR ',
// //               ),
// //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //               inputFormatters: [
// //                 FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
// //               ],
// //               textAlign: TextAlign.right,
// //               onChanged: (value) {
// //                 setState(() {
// //                   entry.credit = double.tryParse(value) ?? 0.0;
// //                   if (entry.credit > 0) entry.debit = 0.0;
// //                 });
// //               },
// //             ),
// //           ),

// //           // Delete button
// //           IconButton(
// //             icon: Icon(Icons.delete_outline, color: Colors.red),
// //             onPressed: _entries.length > 1 ? () => _removeLine(index) : null,
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTotalsSection() {
// //     return Container(
// //       margin: EdgeInsets.symmetric(horizontal: 16),
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: _isBalanced ? Colors.green[50] : Colors.red[50],
// //         border: Border.all(
// //           color: _isBalanced ? Colors.green : Colors.red,
// //           width: 2,
// //         ),
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       child: Column(
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.end,
// //             children: [
// //               Text(
// //                 'Total Debit: ',
// //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //               ),
// //               SizedBox(width: 120),
// //               Container(
// //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                 decoration: BoxDecoration(
// //                   color: Colors.blue[100],
// //                   borderRadius: BorderRadius.circular(4),
// //                 ),
// //                 child: Text(
// //                   'OMR ${_totalDebit.toStringAsFixed(2)}',
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //                 ),
// //               ),
// //               SizedBox(width: 120),
// //             ],
// //           ),
// //           SizedBox(height: 8),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.end,
// //             children: [
// //               Text(
// //                 'Total Credit: ',
// //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //               ),
// //               SizedBox(width: 120),
// //               SizedBox(width: 120),
// //               Container(
// //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                 decoration: BoxDecoration(
// //                   color: Colors.orange[100],
// //                   borderRadius: BorderRadius.circular(4),
// //                 ),
// //                 child: Text(
// //                   'OMR ${_totalCredit.toStringAsFixed(2)}',
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //                 ),
// //               ),
// //               SizedBox(width: 48),
// //             ],
// //           ),
// //           SizedBox(height: 12),
// //           Divider(thickness: 2),
// //           SizedBox(height: 8),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(
// //                 _isBalanced ? Icons.check_circle : Icons.error,
// //                 color: _isBalanced ? Colors.green : Colors.red,
// //                 size: 24,
// //               ),
// //               SizedBox(width: 8),
// //               Text(
// //                 _isBalanced
// //                     ? 'Balanced ✓'
// //                     : 'Difference: OMR ${_difference.abs().toStringAsFixed(2)}',
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: 18,
// //                   color: _isBalanced ? Colors.green[700] : Colors.red[700],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildFooter() {
// //     return Container(
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.1),
// //             blurRadius: 4,
// //             offset: Offset(0, -2),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           ElevatedButton.icon(
// //             onPressed: _addNewLine,
// //             icon: Icon(Icons.add),
// //             label: Text('Add Line'),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.blue,
// //               foregroundColor: Colors.white,
// //             ),
// //           ),
// //           Spacer(),
// //           OutlinedButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: Text('Cancel'),
// //           ),
// //           SizedBox(width: 16),
// //           ElevatedButton.icon(
// //             onPressed: _isBalanced ? _saveEntry : null,
// //             icon: Icon(Icons.save),
// //             label: Text('Save Entry'),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: _isBalanced ? Colors.green : Colors.grey,
// //               foregroundColor: Colors.white,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _referenceController.dispose();
// //     super.dispose();
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:modern_motors_panel/model/chartoAccounts_model.dart';
// // import 'package:modern_motors_panel/modern_motors/chart_of_account_service.dart';

// // class JournalEntryLine {
// //   String? accountId;
// //   String? accountName;
// //   String description;
// //   double debit;
// //   double credit;

// //   JournalEntryLine({
// //     this.accountId,
// //     this.accountName,
// //     this.description = '',
// //     this.debit = 0.0,
// //     this.credit = 0.0,
// //   });

// //   bool get isValid => accountId != null && (debit > 0 || credit > 0);
// // }

// // class AddJournalEntryWidget extends StatefulWidget {
// //   final String branchId;
// //   final Function(List<JournalEntryLine>)? onSave;

// //   const AddJournalEntryWidget({Key? key, required this.branchId, this.onSave})
// //     : super(key: key);

// //   @override
// //   State<AddJournalEntryWidget> createState() => _AddJournalEntryWidgetState();
// // }

// // class _AddJournalEntryWidgetState extends State<AddJournalEntryWidget> {
// //   final ChartAccountService _accountService = ChartAccountService();
// //   final List<JournalEntryLine> _entries = [];
// //   List<ChartAccount> _allAccounts = [];
// //   bool _isLoadingAccounts = true;
// //   String? _errorLoadingAccounts;
// //   final _formKey = GlobalKey<FormState>();
// //   DateTime _selectedDate = DateTime.now();
// //   final _referenceController = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadChartOfAccounts();
// //     _addNewLine();
// //   }

// //   Future<void> _loadChartOfAccounts() async {
// //     setState(() {
// //       _isLoadingAccounts = true;
// //       _errorLoadingAccounts = null;
// //     });

// //     try {
// //       final subscription = _accountService.watchAllAccounts().listen(
// //         (accountsData) {
// //           if (mounted) {
// //             final allAccounts = _flattenAllAccounts(accountsData);
// //             setState(() {
// //               _allAccounts = allAccounts;
// //               _isLoadingAccounts = false;
// //             });
// //           }
// //         },
// //         onError: (error) {
// //           if (mounted) {
// //             setState(() {
// //               _errorLoadingAccounts = error.toString();
// //               _isLoadingAccounts = false;
// //             });
// //           }
// //         },
// //       );

// //       await subscription.asFuture<void>();
// //       await subscription.cancel();
// //     } catch (e) {
// //       if (mounted) {
// //         setState(() {
// //           _errorLoadingAccounts = e.toString();
// //           _isLoadingAccounts = false;
// //         });
// //       }
// //     }
// //   }

// //   List<ChartAccount> _flattenAllAccounts(
// //     Map<String, List<AccountTreeNode>> accountsData,
// //   ) {
// //     final List<ChartAccount> flatList = [];

// //     for (final branchAccounts in accountsData.values) {
// //       for (final node in branchAccounts) {
// //         _addAccountsRecursively(node, flatList);
// //       }
// //     }

// //     return flatList;
// //   }

// //   void _addAccountsRecursively(AccountTreeNode node, List<ChartAccount> list) {
// //     list.add(node.account);
// //     for (final child in node.children) {
// //       _addAccountsRecursively(child, list);
// //     }
// //   }

// //   void _addNewLine() {
// //     setState(() {
// //       _entries.add(JournalEntryLine());
// //     });
// //   }

// //   void _removeLine(int index) {
// //     if (_entries.length > 1) {
// //       setState(() {
// //         _entries.removeAt(index);
// //       });
// //     }
// //   }

// //   void _moveLineUp(int index) {
// //     if (index > 0) {
// //       setState(() {
// //         final item = _entries.removeAt(index);
// //         _entries.insert(index - 1, item);
// //       });
// //     }
// //   }

// //   void _moveLineDown(int index) {
// //     if (index < _entries.length - 1) {
// //       setState(() {
// //         final item = _entries.removeAt(index);
// //         _entries.insert(index + 1, item);
// //       });
// //     }
// //   }

// //   double get _totalDebit {
// //     return _entries.fold(0.0, (sum, entry) => sum + entry.debit);
// //   }

// //   double get _totalCredit {
// //     return _entries.fold(0.0, (sum, entry) => sum + entry.credit);
// //   }

// //   bool get _isBalanced {
// //     return (_totalDebit - _totalCredit).abs() < 0.01;
// //   }

// //   double get _difference {
// //     return _totalDebit - _totalCredit;
// //   }

// //   void _saveEntry() {
// //     if (!_isBalanced) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Debit and Credit must be equal!'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }

// //     if (!_entries.any((e) => e.isValid)) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Please add at least one valid entry!'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }

// //     widget.onSave?.call(_entries.where((e) => e.isValid).toList());
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Add Journal Entry'),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.save),
// //             onPressed: _saveEntry,
// //             tooltip: 'Save Entry',
// //           ),
// //         ],
// //       ),
// //       body: _isLoadingAccounts
// //           ? Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   CircularProgressIndicator(),
// //                   SizedBox(height: 16),
// //                   Text('Loading accounts...'),
// //                 ],
// //               ),
// //             )
// //           : _errorLoadingAccounts != null
// //           ? Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.error_outline, size: 48, color: Colors.red),
// //                   SizedBox(height: 16),
// //                   Text(
// //                     'Error loading accounts',
// //                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                   ),
// //                   SizedBox(height: 8),
// //                   Text(_errorLoadingAccounts!),
// //                   SizedBox(height: 16),
// //                   ElevatedButton(
// //                     onPressed: _loadChartOfAccounts,
// //                     child: Text('Retry'),
// //                   ),
// //                 ],
// //               ),
// //             )
// //           : Column(
// //               children: [
// //                 _buildHeader(),
// //                 Expanded(
// //                   child: SingleChildScrollView(
// //                     child: Column(
// //                       children: [_buildEntriesTable(), _buildTotalsSection()],
// //                     ),
// //                   ),
// //                 ),
// //                 _buildFooter(),
// //               ],
// //             ),
// //     );
// //   }

// //   Widget _buildHeader() {
// //     return Container(
// //       padding: EdgeInsets.all(16),
// //       color: Colors.grey[100],
// //       child: Column(
// //         children: [
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: InkWell(
// //                   onTap: () => _selectDate(context),
// //                   child: InputDecorator(
// //                     decoration: InputDecoration(
// //                       labelText: 'Date',
// //                       border: OutlineInputBorder(),
// //                       suffixIcon: Icon(Icons.calendar_today),
// //                     ),
// //                     child: Text(
// //                       '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(width: 16),
// //               Expanded(
// //                 child: TextField(
// //                   controller: _referenceController,
// //                   decoration: InputDecoration(
// //                     labelText: 'Reference No.',
// //                     border: OutlineInputBorder(),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Future<void> _selectDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: _selectedDate,
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime(2030),
// //     );
// //     if (picked != null && picked != _selectedDate) {
// //       setState(() {
// //         _selectedDate = picked;
// //       });
// //     }
// //   }

// //   Widget _buildEntriesTable() {
// //     return Container(
// //       padding: EdgeInsets.all(16),
// //       child: Column(
// //         children: [
// //           _buildTableHeader(),
// //           ListView.builder(
// //             shrinkWrap: true,
// //             physics: NeverScrollableScrollPhysics(),
// //             itemCount: _entries.length,
// //             itemBuilder: (context, index) {
// //               return _buildEntryRow(index);
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTableHeader() {
// //     return Container(
// //       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
// //       decoration: BoxDecoration(
// //         color: Colors.blue[700],
// //         borderRadius: BorderRadius.only(
// //           topLeft: Radius.circular(8),
// //           topRight: Radius.circular(8),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           SizedBox(width: 80), // Space for controls
// //           Expanded(
// //             flex: 3,
// //             child: Text(
// //               'Account',
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ),
// //           SizedBox(width: 8),
// //           Expanded(
// //             flex: 3,
// //             child: Text(
// //               'Description',
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ),
// //           SizedBox(width: 8),
// //           Expanded(
// //             flex: 2,
// //             child: Text(
// //               'Debit',
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //               ),
// //               textAlign: TextAlign.right,
// //             ),
// //           ),
// //           SizedBox(width: 8),
// //           Expanded(
// //             flex: 2,
// //             child: Text(
// //               'Credit',
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //               ),
// //               textAlign: TextAlign.right,
// //             ),
// //           ),
// //           SizedBox(width: 48), // Space for delete button
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildEntryRow(int index) {
// //     final entry = _entries[index];

// //     return Container(
// //       margin: EdgeInsets.only(bottom: 8),
// //       padding: EdgeInsets.all(8),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         border: Border.all(color: Colors.grey[300]!),
// //         borderRadius: BorderRadius.circular(4),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 4,
// //             offset: Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Move up/down controls
// //           Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               IconButton(
// //                 icon: Icon(Icons.arrow_upward, size: 16),
// //                 onPressed: index > 0 ? () => _moveLineUp(index) : null,
// //                 padding: EdgeInsets.zero,
// //                 constraints: BoxConstraints(minWidth: 32, minHeight: 32),
// //               ),
// //               IconButton(
// //                 icon: Icon(Icons.arrow_downward, size: 16),
// //                 onPressed: index < _entries.length - 1
// //                     ? () => _moveLineDown(index)
// //                     : null,
// //                 padding: EdgeInsets.zero,
// //                 constraints: BoxConstraints(minWidth: 32, minHeight: 32),
// //               ),
// //             ],
// //           ),

// //           // Account dropdown
// //           Expanded(
// //             flex: 3,
// //             child: DropdownButtonFormField<String>(
// //               value: entry.accountId,
// //               decoration: InputDecoration(
// //                 border: OutlineInputBorder(),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   horizontal: 12,
// //                   vertical: 8,
// //                 ),
// //                 isDense: true,
// //               ),
// //               hint: Text('Select Account'),
// //               items: _allAccounts.map((account) {
// //                 return DropdownMenuItem(
// //                   value: account.id,
// //                   child: Text(
// //                     '${account.accountCode} - ${account.accountName}',
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 );
// //               }).toList(),
// //               onChanged: (value) {
// //                 setState(() {
// //                   entry.accountId = value;
// //                   entry.accountName = _allAccounts
// //                       .firstWhere((a) => a.id == value)
// //                       .accountName;
// //                 });
// //               },
// //             ),
// //           ),
// //           SizedBox(width: 8),

// //           // Description
// //           Expanded(
// //             flex: 3,
// //             child: TextField(
// //               decoration: InputDecoration(
// //                 border: OutlineInputBorder(),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   horizontal: 12,
// //                   vertical: 8,
// //                 ),
// //                 isDense: true,
// //               ),
// //               onChanged: (value) {
// //                 entry.description = value;
// //               },
// //             ),
// //           ),
// //           SizedBox(width: 8),

// //           // Debit
// //           Expanded(
// //             flex: 2,
// //             child: TextField(
// //               decoration: InputDecoration(
// //                 border: OutlineInputBorder(),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   horizontal: 12,
// //                   vertical: 8,
// //                 ),
// //                 isDense: true,
// //                 prefixText: 'OMR ',
// //               ),
// //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //               inputFormatters: [
// //                 FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
// //               ],
// //               textAlign: TextAlign.right,
// //               onChanged: (value) {
// //                 setState(() {
// //                   entry.debit = double.tryParse(value) ?? 0.0;
// //                   if (entry.debit > 0) entry.credit = 0.0;
// //                 });
// //               },
// //             ),
// //           ),
// //           SizedBox(width: 8),

// //           // Credit
// //           Expanded(
// //             flex: 2,
// //             child: TextField(
// //               decoration: InputDecoration(
// //                 border: OutlineInputBorder(),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   horizontal: 12,
// //                   vertical: 8,
// //                 ),
// //                 isDense: true,
// //                 prefixText: 'OMR ',
// //               ),
// //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //               inputFormatters: [
// //                 FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
// //               ],
// //               textAlign: TextAlign.right,
// //               onChanged: (value) {
// //                 setState(() {
// //                   entry.credit = double.tryParse(value) ?? 0.0;
// //                   if (entry.credit > 0) entry.debit = 0.0;
// //                 });
// //               },
// //             ),
// //           ),

// //           // Delete button
// //           IconButton(
// //             icon: Icon(Icons.delete_outline, color: Colors.red),
// //             onPressed: _entries.length > 1 ? () => _removeLine(index) : null,
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTotalsSection() {
// //     return Container(
// //       margin: EdgeInsets.symmetric(horizontal: 16),
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: _isBalanced ? Colors.green[50] : Colors.red[50],
// //         border: Border.all(
// //           color: _isBalanced ? Colors.green : Colors.red,
// //           width: 2,
// //         ),
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       child: Column(
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.end,
// //             children: [
// //               Text(
// //                 'Total Debit: ',
// //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //               ),
// //               SizedBox(width: 120),
// //               Container(
// //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                 decoration: BoxDecoration(
// //                   color: Colors.blue[100],
// //                   borderRadius: BorderRadius.circular(4),
// //                 ),
// //                 child: Text(
// //                   'OMR ${_totalDebit.toStringAsFixed(2)}',
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //                 ),
// //               ),
// //               SizedBox(width: 120),
// //             ],
// //           ),
// //           SizedBox(height: 8),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.end,
// //             children: [
// //               Text(
// //                 'Total Credit: ',
// //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //               ),
// //               SizedBox(width: 120),
// //               SizedBox(width: 120),
// //               Container(
// //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                 decoration: BoxDecoration(
// //                   color: Colors.orange[100],
// //                   borderRadius: BorderRadius.circular(4),
// //                 ),
// //                 child: Text(
// //                   'OMR ${_totalCredit.toStringAsFixed(2)}',
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //                 ),
// //               ),
// //               SizedBox(width: 48),
// //             ],
// //           ),
// //           SizedBox(height: 12),
// //           Divider(thickness: 2),
// //           SizedBox(height: 8),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(
// //                 _isBalanced ? Icons.check_circle : Icons.error,
// //                 color: _isBalanced ? Colors.green : Colors.red,
// //                 size: 24,
// //               ),
// //               SizedBox(width: 8),
// //               Text(
// //                 _isBalanced
// //                     ? 'Balanced ✓'
// //                     : 'Difference: OMR ${_difference.abs().toStringAsFixed(2)}',
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: 18,
// //                   color: _isBalanced ? Colors.green[700] : Colors.red[700],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildFooter() {
// //     return Container(
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.1),
// //             blurRadius: 4,
// //             offset: Offset(0, -2),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           ElevatedButton.icon(
// //             onPressed: _addNewLine,
// //             icon: Icon(Icons.add),
// //             label: Text('Add Line'),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.blue,
// //               foregroundColor: Colors.white,
// //             ),
// //           ),
// //           Spacer(),
// //           OutlinedButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: Text('Cancel'),
// //           ),
// //           SizedBox(width: 16),
// //           ElevatedButton.icon(
// //             onPressed: _isBalanced ? _saveEntry : null,
// //             icon: Icon(Icons.save),
// //             label: Text('Save Entry'),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: _isBalanced ? Colors.green : Colors.grey,
// //               foregroundColor: Colors.white,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _referenceController.dispose();
// //     super.dispose();
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:modern_motors_panel/model/branches/branch_model.dart';
// // import 'package:modern_motors_panel/model/chartoAccounts_model.dart';
// // import 'package:modern_motors_panel/modern_motors/chart_of_account_service.dart';
// // import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
// // import 'package:provider/provider.dart';

// // class JournalEntryLine {
// //   String? accountId;
// //   String? accountName;
// //   String description;
// //   double debit;
// //   double credit;

// //   JournalEntryLine({
// //     this.accountId,
// //     this.accountName,
// //     this.description = '',
// //     this.debit = 0.0,
// //     this.credit = 0.0,
// //   });

// //   bool get isValid => accountId != null && (debit > 0 || credit > 0);
// // }

// // class AddJournalEntryWidget extends StatefulWidget {
// //   //  final String branchId;
// //   //final Function(List<JournalEntryLine>)? onSave;

// //   const AddJournalEntryWidget({
// //     Key? key,
// //     // required this.branchId,
// //     //this.onSave,
// //   }) : super(key: key);

// //   @override
// //   State<AddJournalEntryWidget> createState() => _AddJournalEntryWidgetState();
// // }

// // class _AddJournalEntryWidgetState extends State<AddJournalEntryWidget> {
// //   final ChartAccountService _accountService = ChartAccountService();
// //   final List<JournalEntryLine> _entries = [];
// //   Map<String, List<AccountTreeNode>> _allAccountsByBranch = {};
// //   List<ChartAccount> _filteredAccounts = [];
// //   bool _isLoadingAccounts = true;
// //   String? _errorLoadingAccounts;
// //   final _formKey = GlobalKey<FormState>();
// //   DateTime _selectedDate = DateTime.now();
// //   final _referenceController = TextEditingController();
// //   String? _selectedBranchId;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadChartOfAccounts();
// //     _addNewLine();
// //   }

// //   Future<void> _loadChartOfAccounts() async {
// //     setState(() {
// //       _isLoadingAccounts = true;
// //       _errorLoadingAccounts = null;
// //     });

// //     try {
// //       final subscription = _accountService.watchAllAccounts().listen(
// //         (accountsData) {
// //           if (mounted) {
// //             setState(() {
// //               _allAccountsByBranch = accountsData;
// //               _isLoadingAccounts = false;
// //               // Set initial branch selection
// //               if (_selectedBranchId == null && accountsData.isNotEmpty) {
// //                 _selectedBranchId = accountsData.keys.first;
// //                 _updateFilteredAccounts();
// //               }
// //             });
// //           }
// //         },
// //         onError: (error) {
// //           if (mounted) {
// //             setState(() {
// //               _errorLoadingAccounts = error.toString();
// //               _isLoadingAccounts = false;
// //             });
// //           }
// //         },
// //       );

// //       await subscription.asFuture<void>();
// //       await subscription.cancel();
// //     } catch (e) {
// //       if (mounted) {
// //         setState(() {
// //           _errorLoadingAccounts = e.toString();
// //           _isLoadingAccounts = false;
// //         });
// //       }
// //     }
// //   }

// //   void _updateFilteredAccounts() {
// //     if (_selectedBranchId != null &&
// //         _allAccountsByBranch.containsKey(_selectedBranchId)) {
// //       final branchAccounts = _allAccountsByBranch[_selectedBranchId]!;
// //       _filteredAccounts = _flattenAccounts(branchAccounts);
// //     } else {
// //       _filteredAccounts = [];
// //     }
// //     setState(() {});
// //   }

// //   List<ChartAccount> _flattenAccounts(List<AccountTreeNode> branchAccounts) {
// //     final List<ChartAccount> flatList = [];
// //     for (final node in branchAccounts) {
// //       _addAccountsRecursively(node, flatList);
// //     }
// //     return flatList;
// //   }

// //   void _addAccountsRecursively(AccountTreeNode node, List<ChartAccount> list) {
// //     list.add(node.account);
// //     for (final child in node.children) {
// //       _addAccountsRecursively(child, list);
// //     }
// //   }

// //   void _addNewLine() {
// //     setState(() {
// //       _entries.add(JournalEntryLine());
// //     });
// //   }

// //   void _removeLine(int index) {
// //     if (_entries.length > 1) {
// //       setState(() {
// //         _entries.removeAt(index);
// //       });
// //     }
// //   }

// //   void _moveLineUp(int index) {
// //     if (index > 0) {
// //       setState(() {
// //         final item = _entries.removeAt(index);
// //         _entries.insert(index - 1, item);
// //       });
// //     }
// //   }

// //   void _moveLineDown(int index) {
// //     if (index < _entries.length - 1) {
// //       setState(() {
// //         final item = _entries.removeAt(index);
// //         _entries.insert(index + 1, item);
// //       });
// //     }
// //   }

// //   double get _totalDebit {
// //     return _entries.fold(0.0, (sum, entry) => sum + entry.debit);
// //   }

// //   double get _totalCredit {
// //     return _entries.fold(0.0, (sum, entry) => sum + entry.credit);
// //   }

// //   bool get _isBalanced {
// //     return (_totalDebit - _totalCredit).abs() < 0.01;
// //   }

// //   double get _difference {
// //     return _totalDebit - _totalCredit;
// //   }

// //   void _saveEntry() {
// //     if (!_isBalanced) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Debit and Credit must be equal!'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }

// //     if (!_entries.any((e) => e.isValid)) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Please add at least one valid entry!'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }

// //     //  widget.onSave?.call(_entries.where((e) => e.isValid).toList());
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final branchProvider = Provider.of<MmResourceProvider>(context);
// //     final branches = branchProvider.branchesList;

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Add Journal Entry'),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.save),
// //             onPressed: _saveEntry,
// //             tooltip: 'Save Entry',
// //           ),
// //         ],
// //       ),
// //       body: _isLoadingAccounts
// //           ? Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   CircularProgressIndicator(),
// //                   SizedBox(height: 16),
// //                   Text('Loading accounts...'),
// //                 ],
// //               ),
// //             )
// //           : _errorLoadingAccounts != null
// //           ? Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.error_outline, size: 48, color: Colors.red),
// //                   SizedBox(height: 16),
// //                   Text(
// //                     'Error loading accounts',
// //                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                   ),
// //                   SizedBox(height: 8),
// //                   Text(_errorLoadingAccounts!),
// //                   SizedBox(height: 16),
// //                   ElevatedButton(
// //                     onPressed: _loadChartOfAccounts,
// //                     child: Text('Retry'),
// //                   ),
// //                 ],
// //               ),
// //             )
// //           : Column(
// //               children: [
// //                 _buildHeader(branches),
// //                 Expanded(
// //                   child: SingleChildScrollView(
// //                     child: Column(
// //                       children: [_buildEntriesTable(), _buildTotalsSection()],
// //                     ),
// //                   ),
// //                 ),
// //                 _buildFooter(),
// //               ],
// //             ),
// //     );
// //   }

// //   Widget _buildHeader(List<BranchModel> branches) {
// //     return Container(
// //       padding: EdgeInsets.all(16),
// //       color: Colors.grey[100],
// //       child: Column(
// //         children: [
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: InkWell(
// //                   onTap: () => _selectDate(context),
// //                   child: InputDecorator(
// //                     decoration: InputDecoration(
// //                       labelText: 'Date',
// //                       border: OutlineInputBorder(),
// //                       suffixIcon: Icon(Icons.calendar_today),
// //                     ),
// //                     child: Text(
// //                       '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(width: 16),
// //               Expanded(
// //                 child: TextField(
// //                   controller: _referenceController,
// //                   decoration: InputDecoration(
// //                     labelText: 'Reference No.',
// //                     border: OutlineInputBorder(),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 16),
// //           // Branch Selection Dropdown
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: DropdownButtonFormField<String>(
// //                   value: _selectedBranchId,
// //                   decoration: InputDecoration(
// //                     labelText: 'Branch',
// //                     border: OutlineInputBorder(),
// //                     filled: true,
// //                     fillColor: Colors.white,
// //                   ),
// //                   items: [
// //                     DropdownMenuItem(
// //                       value: null,
// //                       child: Text(
// //                         'Select Branch',
// //                         style: TextStyle(color: Colors.grey),
// //                       ),
// //                     ),
// //                     ..._allAccountsByBranch.keys.map((branchId) {
// //                       final branch = branches.firstWhere(
// //                         (b) => b.id == branchId,
// //                         orElse: () => BranchModel(
// //                           id: branchId,
// //                           branchName: 'Branch $branchId',
// //                           address: '',
// //                         ),
// //                       );
// //                       return DropdownMenuItem(
// //                         value: branchId,
// //                         child: Text(branch.branchName),
// //                       );
// //                     }).toList(),
// //                   ],
// //                   onChanged: (value) {
// //                     setState(() {
// //                       _selectedBranchId = value;
// //                       _updateFilteredAccounts();
// //                     });
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Future<void> _selectDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: _selectedDate,
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime(2030),
// //     );
// //     if (picked != null && picked != _selectedDate) {
// //       setState(() {
// //         _selectedDate = picked;
// //       });
// //     }
// //   }

// //   Widget _buildEntriesTable() {
// //     return Container(
// //       padding: EdgeInsets.all(16),
// //       child: Column(
// //         children: [
// //           _buildTableHeader(),
// //           ListView.builder(
// //             shrinkWrap: true,
// //             physics: NeverScrollableScrollPhysics(),
// //             itemCount: _entries.length,
// //             itemBuilder: (context, index) {
// //               return _buildEntryRow(index);
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTableHeader() {
// //     return Container(
// //       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
// //       decoration: BoxDecoration(
// //         color: Colors.blue[700],
// //         borderRadius: BorderRadius.only(
// //           topLeft: Radius.circular(8),
// //           topRight: Radius.circular(8),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           SizedBox(width: 80), // Space for controls
// //           Expanded(
// //             flex: 3,
// //             child: Text(
// //               'Account',
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ),
// //           SizedBox(width: 8),
// //           Expanded(
// //             flex: 3,
// //             child: Text(
// //               'Description',
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ),
// //           SizedBox(width: 8),
// //           Expanded(
// //             flex: 2,
// //             child: Text(
// //               'Debit',
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //               ),
// //               textAlign: TextAlign.right,
// //             ),
// //           ),
// //           SizedBox(width: 8),
// //           Expanded(
// //             flex: 2,
// //             child: Text(
// //               'Credit',
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //               ),
// //               textAlign: TextAlign.right,
// //             ),
// //           ),
// //           SizedBox(width: 48), // Space for delete button
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildEntryRow(int index) {
// //     final entry = _entries[index];

// //     return Container(
// //       margin: EdgeInsets.only(bottom: 8),
// //       padding: EdgeInsets.all(8),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         border: Border.all(color: Colors.grey[300]!),
// //         borderRadius: BorderRadius.circular(4),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 4,
// //             offset: Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Move up/down controls
// //           Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               IconButton(
// //                 icon: Icon(Icons.arrow_upward, size: 16),
// //                 onPressed: index > 0 ? () => _moveLineUp(index) : null,
// //                 padding: EdgeInsets.zero,
// //                 constraints: BoxConstraints(minWidth: 32, minHeight: 32),
// //               ),
// //               IconButton(
// //                 icon: Icon(Icons.arrow_downward, size: 16),
// //                 onPressed: index < _entries.length - 1
// //                     ? () => _moveLineDown(index)
// //                     : null,
// //                 padding: EdgeInsets.zero,
// //                 constraints: BoxConstraints(minWidth: 32, minHeight: 32),
// //               ),
// //             ],
// //           ),

// //           // Account dropdown
// //           Expanded(
// //             flex: 3,
// //             child: DropdownButtonFormField<String>(
// //               value: entry.accountId,
// //               decoration: InputDecoration(
// //                 border: OutlineInputBorder(),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   horizontal: 12,
// //                   vertical: 8,
// //                 ),
// //                 isDense: true,
// //               ),
// //               hint: Text(
// //                 _selectedBranchId == null
// //                     ? 'Select Branch First'
// //                     : 'Select Account',
// //               ),
// //               items: _filteredAccounts.map((account) {
// //                 return DropdownMenuItem(
// //                   value: account.id,
// //                   child: Text(
// //                     '${account.accountCode} - ${account.accountName}',
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 );
// //               }).toList(),
// //               onChanged: _selectedBranchId == null
// //                   ? null
// //                   : (value) {
// //                       setState(() {
// //                         entry.accountId = value;
// //                         entry.accountName = _filteredAccounts
// //                             .firstWhere((a) => a.id == value)
// //                             .accountName;
// //                       });
// //                     },
// //             ),
// //           ),
// //           SizedBox(width: 8),

// //           // Description
// //           Expanded(
// //             flex: 3,
// //             child: TextField(
// //               decoration: InputDecoration(
// //                 border: OutlineInputBorder(),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   horizontal: 12,
// //                   vertical: 8,
// //                 ),
// //                 isDense: true,
// //               ),
// //               onChanged: (value) {
// //                 entry.description = value;
// //               },
// //             ),
// //           ),
// //           SizedBox(width: 8),

// //           // Debit
// //           Expanded(
// //             flex: 2,
// //             child: TextField(
// //               decoration: InputDecoration(
// //                 border: OutlineInputBorder(),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   horizontal: 12,
// //                   vertical: 8,
// //                 ),
// //                 isDense: true,
// //                 prefixText: 'OMR ',
// //               ),
// //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //               inputFormatters: [
// //                 FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
// //               ],
// //               textAlign: TextAlign.right,
// //               onChanged: (value) {
// //                 setState(() {
// //                   entry.debit = double.tryParse(value) ?? 0.0;
// //                   if (entry.debit > 0) entry.credit = 0.0;
// //                 });
// //               },
// //             ),
// //           ),
// //           SizedBox(width: 8),

// //           // Credit
// //           Expanded(
// //             flex: 2,
// //             child: TextField(
// //               decoration: InputDecoration(
// //                 border: OutlineInputBorder(),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   horizontal: 12,
// //                   vertical: 8,
// //                 ),
// //                 isDense: true,
// //                 prefixText: 'OMR ',
// //               ),
// //               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //               inputFormatters: [
// //                 FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
// //               ],
// //               textAlign: TextAlign.right,
// //               onChanged: (value) {
// //                 setState(() {
// //                   entry.credit = double.tryParse(value) ?? 0.0;
// //                   if (entry.credit > 0) entry.debit = 0.0;
// //                 });
// //               },
// //             ),
// //           ),

// //           // Delete button
// //           IconButton(
// //             icon: Icon(Icons.delete_outline, color: Colors.red),
// //             onPressed: _entries.length > 1 ? () => _removeLine(index) : null,
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTotalsSection() {
// //     return Container(
// //       margin: EdgeInsets.symmetric(horizontal: 16),
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: _isBalanced ? Colors.green[50] : Colors.red[50],
// //         border: Border.all(
// //           color: _isBalanced ? Colors.green : Colors.red,
// //           width: 2,
// //         ),
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       child: Column(
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.end,
// //             children: [
// //               Text(
// //                 'Total Debit: ',
// //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //               ),
// //               SizedBox(width: 120),
// //               Container(
// //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                 decoration: BoxDecoration(
// //                   color: Colors.blue[100],
// //                   borderRadius: BorderRadius.circular(4),
// //                 ),
// //                 child: Text(
// //                   'OMR ${_totalDebit.toStringAsFixed(2)}',
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //                 ),
// //               ),
// //               SizedBox(width: 120),
// //             ],
// //           ),
// //           SizedBox(height: 8),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.end,
// //             children: [
// //               Text(
// //                 'Total Credit: ',
// //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //               ),
// //               SizedBox(width: 120),
// //               SizedBox(width: 120),
// //               Container(
// //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                 decoration: BoxDecoration(
// //                   color: Colors.orange[100],
// //                   borderRadius: BorderRadius.circular(4),
// //                 ),
// //                 child: Text(
// //                   'OMR ${_totalCredit.toStringAsFixed(2)}',
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //                 ),
// //               ),
// //               SizedBox(width: 48),
// //             ],
// //           ),
// //           SizedBox(height: 12),
// //           Divider(thickness: 2),
// //           SizedBox(height: 8),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(
// //                 _isBalanced ? Icons.check_circle : Icons.error,
// //                 color: _isBalanced ? Colors.green : Colors.red,
// //                 size: 24,
// //               ),
// //               SizedBox(width: 8),
// //               Text(
// //                 _isBalanced
// //                     ? 'Balanced ✓'
// //                     : 'Difference: OMR ${_difference.abs().toStringAsFixed(2)}',
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: 18,
// //                   color: _isBalanced ? Colors.green[700] : Colors.red[700],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildFooter() {
// //     return Container(
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.1),
// //             blurRadius: 4,
// //             offset: Offset(0, -2),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           ElevatedButton.icon(
// //             onPressed: _addNewLine,
// //             icon: Icon(Icons.add),
// //             label: Text('Add Line'),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.blue,
// //               foregroundColor: Colors.white,
// //             ),
// //           ),
// //           Spacer(),
// //           OutlinedButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: Text('Cancel'),
// //           ),
// //           SizedBox(width: 16),
// //           ElevatedButton.icon(
// //             onPressed: _isBalanced ? _saveEntry : null,
// //             icon: Icon(Icons.save),
// //             label: Text('Save Entry'),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: _isBalanced ? Colors.green : Colors.grey,
// //               foregroundColor: Colors.white,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _referenceController.dispose();
// //     super.dispose();
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:modern_motors_panel/model/branches/branch_model.dart';
// import 'package:modern_motors_panel/model/chartoAccounts_model.dart';
// import 'package:modern_motors_panel/modern_motors/chart_of_account_service.dart';
// import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
// import 'package:provider/provider.dart';

// class JournalEntryLine {
//   String? accountId;
//   String? accountName;
//   String description;
//   double debit;
//   double credit;

//   JournalEntryLine({
//     this.accountId,
//     this.accountName,
//     this.description = '',
//     this.debit = 0.0,
//     this.credit = 0.0,
//   });

//   bool get isValid => accountId != null && (debit > 0 || credit > 0);
// }

// class AddJournalEntryWidget extends StatefulWidget {
//   const AddJournalEntryWidget({Key? key}) : super(key: key);

//   @override
//   State<AddJournalEntryWidget> createState() => _AddJournalEntryWidgetState();
// }

// class _AddJournalEntryWidgetState extends State<AddJournalEntryWidget> {
//   final ChartAccountService _accountService = ChartAccountService();
//   final List<JournalEntryLine> _entries = [];
//   Map<String, List<AccountTreeNode>> _allAccountsByBranch = {};
//   List<ChartAccount> _filteredAccounts = [];
//   bool _isLoadingAccounts = true;
//   String? _errorLoadingAccounts;
//   DateTime _selectedDate = DateTime.now();
//   final _referenceController = TextEditingController();
//   final _memoController = TextEditingController();
//   String? _selectedBranchId;

//   @override
//   void initState() {
//     super.initState();
//     _loadChartOfAccounts();
//     _addNewLine();
//   }

//   Future<void> _loadChartOfAccounts() async {
//     setState(() {
//       _isLoadingAccounts = true;
//       _errorLoadingAccounts = null;
//     });

//     try {
//       final subscription = _accountService.watchAllAccounts().listen(
//         (accountsData) {
//           if (mounted) {
//             setState(() {
//               _allAccountsByBranch = accountsData;
//               _isLoadingAccounts = false;
//               if (_selectedBranchId == null && accountsData.isNotEmpty) {
//                 _selectedBranchId = accountsData.keys.first;
//                 _updateFilteredAccounts();
//               }
//             });
//           }
//         },
//         onError: (error) {
//           if (mounted) {
//             setState(() {
//               _errorLoadingAccounts = error.toString();
//               _isLoadingAccounts = false;
//             });
//           }
//         },
//       );

//       await subscription.asFuture<void>();
//       await subscription.cancel();
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _errorLoadingAccounts = e.toString();
//           _isLoadingAccounts = false;
//         });
//       }
//     }
//   }

//   void _updateFilteredAccounts() {
//     if (_selectedBranchId != null &&
//         _allAccountsByBranch.containsKey(_selectedBranchId)) {
//       final branchAccounts = _allAccountsByBranch[_selectedBranchId]!;
//       _filteredAccounts = _flattenAccounts(branchAccounts);
//     } else {
//       _filteredAccounts = [];
//     }
//     setState(() {});
//   }

//   List<ChartAccount> _flattenAccounts(List<AccountTreeNode> branchAccounts) {
//     final List<ChartAccount> flatList = [];
//     for (final node in branchAccounts) {
//       _addAccountsRecursively(node, flatList);
//     }
//     return flatList;
//   }

//   void _addAccountsRecursively(AccountTreeNode node, List<ChartAccount> list) {
//     list.add(node.account);
//     for (final child in node.children) {
//       _addAccountsRecursively(child, list);
//     }
//   }

//   void _addNewLine() {
//     setState(() {
//       _entries.add(JournalEntryLine());
//     });
//   }

//   void _removeLine(int index) {
//     if (_entries.length > 1) {
//       setState(() {
//         _entries.removeAt(index);
//       });
//     }
//   }

//   double get _totalDebit =>
//       _entries.fold(0.0, (sum, entry) => sum + entry.debit);
//   double get _totalCredit =>
//       _entries.fold(0.0, (sum, entry) => sum + entry.credit);
//   bool get _isBalanced => (_totalDebit - _totalCredit).abs() < 0.01;
//   double get _difference => _totalDebit - _totalCredit;

//   void _saveEntry() {
//     if (_selectedBranchId == null) {
//       _showErrorSnackBar('Please select a branch');
//       return;
//     }

//     if (!_isBalanced) {
//       _showErrorSnackBar('Journal entry must be balanced');
//       return;
//     }

//     if (!_entries.any((e) => e.isValid)) {
//       _showErrorSnackBar('Please add at least one valid entry line');
//       return;
//     }

//     // TODO: Implement save logic
//     _showSuccessSnackBar('Journal entry saved successfully');
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.error_outline, color: Colors.white),
//             SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Color(0xFFDC2626),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.check_circle_outline, color: Colors.white),
//             SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Color(0xFF059669),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final branchProvider = Provider.of<MmResourceProvider>(context);
//     final branches = branchProvider.branchesList;

//     return Scaffold(
//       backgroundColor: Color(0xFFF8FAFC),
//       appBar: _buildAppBar(),
//       body: _isLoadingAccounts
//           ? _buildLoadingState()
//           : _errorLoadingAccounts != null
//           ? _buildErrorState()
//           : _buildMainContent(branches),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.white,
//       foregroundColor: Color(0xFF1E293B),
//       title: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Color(0xFF3B82F6).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(Icons.receipt_long, color: Color(0xFF3B82F6), size: 20),
//           ),
//           SizedBox(width: 12),
//           Text(
//             'New Journal Entry',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1E293B),
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton.icon(
//           onPressed: () => Navigator.pop(context),
//           icon: Icon(Icons.close, size: 18),
//           label: Text('Cancel'),
//           style: TextButton.styleFrom(foregroundColor: Color(0xFF64748B)),
//         ),
//         SizedBox(width: 8),
//         ElevatedButton.icon(
//           onPressed: _isBalanced ? _saveEntry : null,
//           icon: Icon(Icons.save_outlined, size: 18),
//           label: Text('Save Entry'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Color(0xFF3B82F6),
//             foregroundColor: Colors.white,
//             elevation: 0,
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             disabledBackgroundColor: Color(0xFFE2E8F0),
//             disabledForegroundColor: Color(0xFF94A3B8),
//           ),
//         ),
//         SizedBox(width: 16),
//       ],
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF3B82F6)),
//           SizedBox(height: 24),
//           Text(
//             'Loading accounts...',
//             style: TextStyle(
//               fontSize: 16,
//               color: Color(0xFF64748B),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Container(
//         margin: EdgeInsets.all(32),
//         padding: EdgeInsets.all(32),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Color(0xFFE2E8F0)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Color(0xFFFEE2E2),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.error_outline,
//                 size: 48,
//                 color: Color(0xFFDC2626),
//               ),
//             ),
//             SizedBox(height: 24),
//             Text(
//               'Failed to Load Accounts',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1E293B),
//               ),
//             ),
//             SizedBox(height: 12),
//             Text(
//               _errorLoadingAccounts!,
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Color(0xFF64748B)),
//             ),
//             SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: _loadChartOfAccounts,
//               icon: Icon(Icons.refresh, size: 18),
//               label: Text('Retry'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF3B82F6),
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMainContent(List<BranchModel> branches) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           _buildHeaderSection(branches),
//           SizedBox(height: 24),
//           _buildEntriesSection(),
//           SizedBox(height: 24),
//           _buildTotalsCard(),
//           SizedBox(height: 24),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderSection(List<BranchModel> branches) {
//     return Container(
//       margin: EdgeInsets.all(24),
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Color(0xFFE2E8F0)),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF1E293B).withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Entry Details',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1E293B),
//             ),
//           ),
//           SizedBox(height: 20),
//           Row(
//             children: [
//               Expanded(child: _buildBranchDropdown(branches)),
//               SizedBox(width: 16),
//               Expanded(child: _buildDateField()),
//               SizedBox(width: 16),
//               Expanded(child: _buildReferenceField()),
//             ],
//           ),
//           SizedBox(height: 16),
//           _buildMemoField(),
//         ],
//       ),
//     );
//   }

//   Widget _buildBranchDropdown(List<BranchModel> branches) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Branch',
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 8),
//         DropdownButtonFormField<String>(
//           value: _selectedBranchId,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             filled: true,
//             fillColor: Color(0xFFF8FAFC),
//             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           ),
//           items: [
//             DropdownMenuItem(
//               value: null,
//               child: Text(
//                 'Select Branch',
//                 style: TextStyle(color: Color(0xFF94A3B8)),
//               ),
//             ),
//             ..._allAccountsByBranch.keys.map((branchId) {
//               final branch = branches.firstWhere(
//                 (b) => b.id == branchId,
//                 orElse: () => BranchModel(
//                   id: branchId,
//                   branchName: 'Branch $branchId',
//                   address: '',
//                 ),
//               );
//               return DropdownMenuItem(
//                 value: branchId,
//                 child: Text(branch.branchName),
//               );
//             }).toList(),
//           ],
//           onChanged: (value) {
//             setState(() {
//               _selectedBranchId = value;
//               _updateFilteredAccounts();
//             });
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildDateField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Date',
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 8),
//         InkWell(
//           onTap: () => _selectDate(context),
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               color: Color(0xFFF8FAFC),
//               border: Border.all(color: Color(0xFFE2E8F0)),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.calendar_today, size: 18, color: Color(0xFF64748B)),
//                 SizedBox(width: 12),
//                 Text(
//                   '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
//                   style: TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildReferenceField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Reference No.',
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 8),
//         TextField(
//           controller: _referenceController,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             filled: true,
//             fillColor: Color(0xFFF8FAFC),
//             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             hintText: 'Optional',
//             hintStyle: TextStyle(color: Color(0xFF94A3B8)),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMemoField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Memo',
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 8),
//         TextField(
//           controller: _memoController,
//           maxLines: 2,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             filled: true,
//             fillColor: Color(0xFFF8FAFC),
//             contentPadding: EdgeInsets.all(16),
//             hintText: 'Add notes or description for this entry...',
//             hintStyle: TextStyle(color: Color(0xFF94A3B8)),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEntriesSection() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Color(0xFFE2E8F0)),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF1E293B).withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildEntriesHeader(),
//           Divider(height: 1, color: Color(0xFFE2E8F0)),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             padding: EdgeInsets.all(16),
//             itemCount: _entries.length,
//             separatorBuilder: (context, index) => SizedBox(height: 12),
//             itemBuilder: (context, index) => _buildEntryRow(index),
//           ),
//           Divider(height: 1, color: Color(0xFFE2E8F0)),
//           _buildAddLineButton(),
//         ],
//       ),
//     );
//   }

//   Widget _buildEntriesHeader() {
//     return Container(
//       padding: EdgeInsets.all(20),
//       child: Row(
//         children: [
//           Text(
//             'Transaction Lines',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1E293B),
//             ),
//           ),
//           Spacer(),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Color(0xFFF1F5F9),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               '${_entries.length} ${_entries.length == 1 ? 'Line' : 'Lines'}',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF475569),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEntryRow(int index) {
//     final entry = _entries[index];

//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Color(0xFFE2E8F0)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(4),
//                   border: Border.all(color: Color(0xFFE2E8F0)),
//                 ),
//                 child: Text(
//                   '${index + 1}',
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF64748B),
//                   ),
//                 ),
//               ),
//               Spacer(),
//               if (_entries.length > 1)
//                 IconButton(
//                   icon: Icon(Icons.close, size: 18),
//                   onPressed: () => _removeLine(index),
//                   color: Color(0xFF64748B),
//                   tooltip: 'Remove line',
//                   padding: EdgeInsets.zero,
//                   constraints: BoxConstraints(minWidth: 32, minHeight: 32),
//                 ),
//             ],
//           ),
//           SizedBox(height: 16),
//           // Single row layout for account, description, debit, credit
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Account Dropdown - 35%
//               Expanded(flex: 35, child: _buildCompactAccountDropdown(entry)),
//               SizedBox(width: 12),
//               // Description - 30%
//               Expanded(flex: 30, child: _buildCompactDescriptionField(entry)),
//               SizedBox(width: 12),
//               // Debit - 15%
//               Expanded(flex: 15, child: _buildCompactDebitField(entry)),
//               SizedBox(width: 8),
//               // Credit - 15%
//               Expanded(flex: 15, child: _buildCompactCreditField(entry)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCompactAccountDropdown(JournalEntryLine entry) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Account',
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 6),
//         Container(
//           height: 40,
//           child: DropdownButtonFormField<String>(
//             value: entry.accountId,
//             isExpanded: true,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFF3B82F6), width: 1.5),
//               ),
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               isDense: true,
//             ),
//             hint: Text(
//               _selectedBranchId == null ? 'Select branch' : 'Select account',
//               style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
//             ),
//             items: _filteredAccounts.map((account) {
//               return DropdownMenuItem(
//                 value: account.id,
//                 child: Text(
//                   '${account.accountCode} - ${account.accountName}',
//                   style: TextStyle(fontSize: 12),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               );
//             }).toList(),
//             onChanged: _selectedBranchId == null
//                 ? null
//                 : (value) {
//                     setState(() {
//                       entry.accountId = value;
//                       entry.accountName = _filteredAccounts
//                           .firstWhere((a) => a.id == value)
//                           .accountName;
//                     });
//                   },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCompactDescriptionField(JournalEntryLine entry) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Description',
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 6),
//         Container(
//           height: 40,
//           child: TextField(
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFF3B82F6), width: 1.5),
//               ),
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               hintText: 'Description...',
//               hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
//               isDense: true,
//             ),
//             style: TextStyle(fontSize: 13),
//             onChanged: (value) {
//               entry.description = value;
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCompactDebitField(JournalEntryLine entry) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Debit',
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 6),
//         Container(
//           height: 40,
//           child: TextField(
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFF3B82F6), width: 1.5),
//               ),
//               filled: true,
//               fillColor: entry.debit > 0 ? Color(0xFFDCFCE7) : Colors.white,
//               contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               prefixText: 'OMR ',
//               prefixStyle: TextStyle(
//                 fontSize: 11,
//                 color: Color(0xFF64748B),
//                 fontWeight: FontWeight.w500,
//               ),
//               hintText: '0.00',
//               hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
//               isDense: true,
//             ),
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             inputFormatters: [
//               FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
//             ],
//             textAlign: TextAlign.right,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: entry.debit > 0 ? Color(0xFF059669) : Color(0xFF1E293B),
//             ),
//             onChanged: (value) {
//               setState(() {
//                 entry.debit = double.tryParse(value) ?? 0.0;
//                 if (entry.debit > 0) entry.credit = 0.0;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCompactCreditField(JournalEntryLine entry) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Credit',
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 6),
//         Container(
//           height: 40,
//           child: TextField(
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFF3B82F6), width: 1.5),
//               ),
//               filled: true,
//               fillColor: entry.credit > 0 ? Color(0xFFFEF3C7) : Colors.white,
//               contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               prefixText: 'OMR ',
//               prefixStyle: TextStyle(
//                 fontSize: 11,
//                 color: Color(0xFF64748B),
//                 fontWeight: FontWeight.w500,
//               ),
//               hintText: '0.00',
//               hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
//               isDense: true,
//             ),
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             inputFormatters: [
//               FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
//             ],
//             textAlign: TextAlign.right,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: entry.credit > 0 ? Color(0xFFD97706) : Color(0xFF1E293B),
//             ),
//             onChanged: (value) {
//               setState(() {
//                 entry.credit = double.tryParse(value) ?? 0.0;
//                 if (entry.credit > 0) entry.debit = 0.0;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAddLineButton() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: OutlinedButton.icon(
//         onPressed: _addNewLine,
//         icon: Icon(Icons.add, size: 18),
//         label: Text('Add Another Line'),
//         style: OutlinedButton.styleFrom(
//           foregroundColor: Color(0xFF3B82F6),
//           side: BorderSide(color: Color(0xFF3B82F6)),
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       ),
//     );
//   }

//   Widget _buildTotalsCard() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 24),
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: _isBalanced ? Color(0xFF10B981) : Color(0xFFEF4444),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: (_isBalanced ? Color(0xFF10B981) : Color(0xFFEF4444))
//                 .withOpacity(0.1),
//             blurRadius: 20,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: _buildTotalItem(
//                   'Total Debit',
//                   _totalDebit,
//                   Color(0xFF059669),
//                   Color(0xFFDCFCE7),
//                 ),
//               ),
//               SizedBox(width: 24),
//               Expanded(
//                 child: _buildTotalItem(
//                   'Total Credit',
//                   _totalCredit,
//                   Color(0xFFD97706),
//                   Color(0xFFFEF3C7),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//           Divider(color: Color(0xFFE2E8F0)),
//           SizedBox(height: 20),
//           _buildBalanceStatus(),
//         ],
//       ),
//     );
//   }

//   Widget _buildTotalItem(
//     String label,
//     double amount,
//     Color color,
//     Color bgColor,
//   ) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF64748B),
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'OMR ${amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.w700,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBalanceStatus() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _isBalanced ? Color(0xFFDCFCE7) : Color(0xFFFEE2E2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: _isBalanced ? Color(0xFF059669) : Color(0xFFDC2626),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               _isBalanced ? Icons.check : Icons.warning_rounded,
//               color: Colors.white,
//               size: 20,
//             ),
//           ),
//           SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 _isBalanced ? 'Entry Balanced' : 'Entry Not Balanced',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: _isBalanced ? Color(0xFF059669) : Color(0xFFDC2626),
//                 ),
//               ),
//               if (!_isBalanced)
//                 Text(
//                   'Difference: OMR ${_difference.abs().toStringAsFixed(2)}',
//                   style: TextStyle(fontSize: 13, color: Color(0xFF991B1B)),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Color(0xFF3B82F6),
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Color(0xFF1E293B),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _referenceController.dispose();
//     _memoController.dispose();
//     super.dispose();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:modern_motors_panel/model/branches/branch_model.dart';
// import 'package:modern_motors_panel/model/chartoAccounts_model.dart';
// import 'package:modern_motors_panel/modern_motors/chart_of_account_service.dart';
// import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
// import 'package:provider/provider.dart';

// class JournalEntryLine {
//   String? accountId;
//   String? accountName;
//   String description;
//   double debit;
//   double credit;

//   JournalEntryLine({
//     this.accountId,
//     this.accountName,
//     this.description = '',
//     this.debit = 0.0,
//     this.credit = 0.0,
//   });

//   bool get isValid => accountId != null && (debit > 0 || credit > 0);
//   bool get hasBothAmounts => debit > 0 && credit > 0;
// }

// class AddJournalEntryWidget extends StatefulWidget {
//   const AddJournalEntryWidget({Key? key}) : super(key: key);

//   @override
//   State<AddJournalEntryWidget> createState() => _AddJournalEntryWidgetState();
// }

// class _AddJournalEntryWidgetState extends State<AddJournalEntryWidget> {
//   final ChartAccountService _accountService = ChartAccountService();
//   final List<JournalEntryLine> _entries = [];
//   Map<String, List<AccountTreeNode>> _allAccountsByBranch = {};
//   List<ChartAccount> _filteredAccounts = [];
//   bool _isLoadingAccounts = true;
//   String? _errorLoadingAccounts;
//   DateTime _selectedDate = DateTime.now();
//   final _referenceController = TextEditingController();
//   final _memoController = TextEditingController();
//   String? _selectedBranchId;

//   @override
//   void initState() {
//     super.initState();
//     _loadChartOfAccounts();
//     _addNewLine();
//   }

//   Future<void> _loadChartOfAccounts() async {
//     setState(() {
//       _isLoadingAccounts = true;
//       _errorLoadingAccounts = null;
//     });

//     try {
//       final subscription = _accountService.watchAllAccounts().listen(
//         (accountsData) {
//           if (mounted) {
//             setState(() {
//               _allAccountsByBranch = accountsData;
//               _isLoadingAccounts = false;
//               if (_selectedBranchId == null && accountsData.isNotEmpty) {
//                 _selectedBranchId = accountsData.keys.first;
//                 _updateFilteredAccounts();
//               }
//             });
//           }
//         },
//         onError: (error) {
//           if (mounted) {
//             setState(() {
//               _errorLoadingAccounts = error.toString();
//               _isLoadingAccounts = false;
//             });
//           }
//         },
//       );

//       await subscription.asFuture<void>();
//       await subscription.cancel();
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _errorLoadingAccounts = e.toString();
//           _isLoadingAccounts = false;
//         });
//       }
//     }
//   }

//   void _updateFilteredAccounts() {
//     if (_selectedBranchId != null &&
//         _allAccountsByBranch.containsKey(_selectedBranchId)) {
//       final branchAccounts = _allAccountsByBranch[_selectedBranchId]!;
//       _filteredAccounts = _flattenAccounts(branchAccounts);
//     } else {
//       _filteredAccounts = [];
//     }
//     setState(() {});
//   }

//   List<ChartAccount> _flattenAccounts(List<AccountTreeNode> branchAccounts) {
//     final List<ChartAccount> flatList = [];
//     for (final node in branchAccounts) {
//       _addAccountsRecursively(node, flatList);
//     }
//     return flatList;
//   }

//   void _addAccountsRecursively(AccountTreeNode node, List<ChartAccount> list) {
//     list.add(node.account);
//     for (final child in node.children) {
//       _addAccountsRecursively(child, list);
//     }
//   }

//   void _addNewLine() {
//     setState(() {
//       _entries.add(JournalEntryLine());
//     });
//   }

//   void _removeLine(int index) {
//     if (_entries.length > 1) {
//       setState(() {
//         _entries.removeAt(index);
//       });
//     }
//   }

//   double get _totalDebit =>
//       _entries.fold(0.0, (sum, entry) => sum + entry.debit);
//   double get _totalCredit =>
//       _entries.fold(0.0, (sum, entry) => sum + entry.credit);
//   bool get _isBalanced => (_totalDebit - _totalCredit).abs() < 0.01;
//   double get _difference => _totalDebit - _totalCredit;

//   void _saveEntry() {
//     if (_selectedBranchId == null) {
//       _showErrorSnackBar('Please select a branch');
//       return;
//     }

//     if (!_isBalanced) {
//       _showErrorSnackBar('Journal entry must be balanced');
//       return;
//     }

//     if (!_entries.any((e) => e.isValid)) {
//       _showErrorSnackBar('Please add at least one valid entry line');
//       return;
//     }

//     // Check if any entry has both debit and credit
//     if (_entries.any((entry) => entry.hasBothAmounts)) {
//       _showErrorSnackBar(
//         'Each line must have either debit OR credit, not both',
//       );
//       return;
//     }

//     // Check if we have at least one debit and one credit entry
//     final hasDebit = _entries.any((entry) => entry.debit > 0);
//     final hasCredit = _entries.any((entry) => entry.credit > 0);

//     if (!hasDebit || !hasCredit) {
//       _showErrorSnackBar(
//         'Journal entry must have at least one debit and one credit line',
//       );
//       return;
//     }

//     // TODO: Implement save logic
//     _showSuccessSnackBar('Journal entry saved successfully');
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.error_outline, color: Colors.white),
//             SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Color(0xFFDC2626),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.check_circle_outline, color: Colors.white),
//             SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Color(0xFF059669),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final branchProvider = Provider.of<MmResourceProvider>(context);
//     final branches = branchProvider.branchesList;

//     return Scaffold(
//       backgroundColor: Color(0xFFF8FAFC),
//       appBar: _buildAppBar(),
//       body: _isLoadingAccounts
//           ? _buildLoadingState()
//           : _errorLoadingAccounts != null
//           ? _buildErrorState()
//           : _buildMainContent(branches),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.white,
//       foregroundColor: Color(0xFF1E293B),
//       title: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Color(0xFF3B82F6).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(Icons.receipt_long, color: Color(0xFF3B82F6), size: 20),
//           ),
//           SizedBox(width: 12),
//           Text(
//             'New Journal Entry',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1E293B),
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton.icon(
//           onPressed: () => Navigator.pop(context),
//           icon: Icon(Icons.close, size: 18),
//           label: Text('Cancel'),
//           style: TextButton.styleFrom(foregroundColor: Color(0xFF64748B)),
//         ),
//         SizedBox(width: 8),
//         ElevatedButton.icon(
//           onPressed: _isBalanced ? _saveEntry : null,
//           icon: Icon(Icons.save_outlined, size: 18),
//           label: Text('Save Entry'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Color(0xFF3B82F6),
//             foregroundColor: Colors.white,
//             elevation: 0,
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             disabledBackgroundColor: Color(0xFFE2E8F0),
//             disabledForegroundColor: Color(0xFF94A3B8),
//           ),
//         ),
//         SizedBox(width: 16),
//       ],
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF3B82F6)),
//           SizedBox(height: 24),
//           Text(
//             'Loading accounts...',
//             style: TextStyle(
//               fontSize: 16,
//               color: Color(0xFF64748B),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Container(
//         margin: EdgeInsets.all(32),
//         padding: EdgeInsets.all(32),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Color(0xFFE2E8F0)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Color(0xFFFEE2E2),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.error_outline,
//                 size: 48,
//                 color: Color(0xFFDC2626),
//               ),
//             ),
//             SizedBox(height: 24),
//             Text(
//               'Failed to Load Accounts',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1E293B),
//               ),
//             ),
//             SizedBox(height: 12),
//             Text(
//               _errorLoadingAccounts!,
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Color(0xFF64748B)),
//             ),
//             SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: _loadChartOfAccounts,
//               icon: Icon(Icons.refresh, size: 18),
//               label: Text('Retry'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF3B82F6),
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMainContent(List<BranchModel> branches) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           _buildHeaderSection(branches),
//           SizedBox(height: 16),
//           _buildEntriesSection(),
//           SizedBox(height: 16),
//           _buildTotalsCard(),
//           SizedBox(height: 24),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderSection(List<BranchModel> branches) {
//     return Container(
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Color(0xFFE2E8F0)),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF1E293B).withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Entry Details',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1E293B),
//             ),
//           ),
//           SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(child: _buildBranchDropdown(branches)),
//               SizedBox(width: 12),
//               Expanded(child: _buildDateField()),
//               SizedBox(width: 12),
//               Expanded(child: _buildReferenceField()),
//             ],
//           ),
//           SizedBox(height: 12),
//           _buildMemoField(),
//         ],
//       ),
//     );
//   }

//   Widget _buildBranchDropdown(List<BranchModel> branches) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Branch',
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 6),
//         DropdownButtonFormField<String>(
//           value: _selectedBranchId,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             filled: true,
//             fillColor: Color(0xFFF8FAFC),
//             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           ),
//           items: [
//             DropdownMenuItem(
//               value: null,
//               child: Text(
//                 'Select Branch',
//                 style: TextStyle(color: Color(0xFF94A3B8)),
//               ),
//             ),
//             ..._allAccountsByBranch.keys.map((branchId) {
//               final branch = branches.firstWhere(
//                 (b) => b.id == branchId,
//                 orElse: () => BranchModel(
//                   id: branchId,
//                   branchName: 'Branch $branchId',
//                   address: '',
//                 ),
//               );
//               return DropdownMenuItem(
//                 value: branchId,
//                 child: Text(branch.branchName),
//               );
//             }).toList(),
//           ],
//           onChanged: (value) {
//             setState(() {
//               _selectedBranchId = value;
//               _updateFilteredAccounts();
//             });
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildDateField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Date',
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 6),
//         InkWell(
//           onTap: () => _selectDate(context),
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               color: Color(0xFFF8FAFC),
//               border: Border.all(color: Color(0xFFE2E8F0)),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.calendar_today, size: 18, color: Color(0xFF64748B)),
//                 SizedBox(width: 12),
//                 Text(
//                   '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
//                   style: TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildReferenceField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Reference No.',
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 6),
//         TextField(
//           controller: _referenceController,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             filled: true,
//             fillColor: Color(0xFFF8FAFC),
//             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             hintText: 'Optional',
//             hintStyle: TextStyle(color: Color(0xFF94A3B8)),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMemoField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Memo',
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 6),
//         TextField(
//           controller: _memoController,
//           maxLines: 2,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
//             ),
//             filled: true,
//             fillColor: Color(0xFFF8FAFC),
//             contentPadding: EdgeInsets.all(16),
//             hintText: 'Add notes or description for this entry...',
//             hintStyle: TextStyle(color: Color(0xFF94A3B8)),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEntriesSection() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Color(0xFFE2E8F0)),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF1E293B).withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildEntriesHeader(),
//           Divider(height: 1, color: Color(0xFFE2E8F0)),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             padding: EdgeInsets.all(16),
//             itemCount: _entries.length,
//             separatorBuilder: (context, index) => SizedBox(height: 8),
//             itemBuilder: (context, index) => _buildEntryRow(index),
//           ),
//           Divider(height: 1, color: Color(0xFFE2E8F0)),
//           _buildAddLineButton(),
//         ],
//       ),
//     );
//   }

//   Widget _buildEntriesHeader() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Text(
//             'Transaction Lines',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1E293B),
//             ),
//           ),
//           Spacer(),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Color(0xFFF1F5F9),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               '${_entries.length} ${_entries.length == 1 ? 'Line' : 'Lines'}',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF475569),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEntryRow(int index) {
//     final entry = _entries[index];

//     return Container(
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Color(0xFFE2E8F0)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Account Dropdown - 40%
//           Expanded(flex: 40, child: _buildCompactAccountDropdown(entry)),
//           SizedBox(width: 8),
//           // Description - 25%
//           Expanded(flex: 25, child: _buildCompactDescriptionField(entry)),
//           SizedBox(width: 8),
//           // Debit - 15%
//           Expanded(flex: 15, child: _buildCompactDebitField(entry)),
//           SizedBox(width: 8),
//           // Credit - 15%
//           Expanded(flex: 15, child: _buildCompactCreditField(entry)),
//           SizedBox(width: 8),
//           // Remove button - 5%
//           if (_entries.length > 1)
//             Container(
//               width: 32,
//               child: IconButton(
//                 icon: Icon(Icons.close, size: 16),
//                 onPressed: () => _removeLine(index),
//                 color: Color(0xFF64748B),
//                 tooltip: 'Remove line',
//                 padding: EdgeInsets.zero,
//                 constraints: BoxConstraints(minWidth: 24, minHeight: 24),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCompactAccountDropdown(JournalEntryLine entry) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Account',
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 4),
//         Container(
//           height: 36,
//           child: DropdownButtonFormField<String>(
//             value: entry.accountId,
//             isExpanded: true,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFF3B82F6), width: 1.5),
//               ),
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               isDense: true,
//             ),
//             hint: Text(
//               _selectedBranchId == null ? 'Select branch' : 'Select account',
//               style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
//             ),
//             items: _filteredAccounts.map((account) {
//               return DropdownMenuItem(
//                 value: account.id,
//                 child: Text(
//                   '${account.accountCode} - ${account.accountName}',
//                   style: TextStyle(fontSize: 11),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               );
//             }).toList(),
//             onChanged: _selectedBranchId == null
//                 ? null
//                 : (value) {
//                     setState(() {
//                       entry.accountId = value;
//                       entry.accountName = _filteredAccounts
//                           .firstWhere((a) => a.id == value)
//                           .accountName;
//                     });
//                   },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCompactDescriptionField(JournalEntryLine entry) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Description',
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 4),
//         Container(
//           height: 36,
//           child: TextField(
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFF3B82F6), width: 1.5),
//               ),
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               hintText: 'Description...',
//               hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
//               isDense: true,
//             ),
//             style: TextStyle(fontSize: 12),
//             onChanged: (value) {
//               entry.description = value;
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCompactDebitField(JournalEntryLine entry) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Debit',
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 4),
//         Container(
//           height: 36,
//           child: TextField(
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFF3B82F6), width: 1.5),
//               ),
//               filled: true,
//               fillColor: entry.debit > 0 ? Color(0xFFDCFCE7) : Colors.white,
//               contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
//               prefixText: 'OMR ',
//               prefixStyle: TextStyle(
//                 fontSize: 10,
//                 color: Color(0xFF64748B),
//                 fontWeight: FontWeight.w500,
//               ),
//               hintText: '0.00',
//               hintStyle: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
//               isDense: true,
//             ),
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             inputFormatters: [
//               FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
//             ],
//             textAlign: TextAlign.right,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               color: entry.debit > 0 ? Color(0xFF059669) : Color(0xFF1E293B),
//             ),
//             onChanged: (value) {
//               setState(() {
//                 entry.debit = double.tryParse(value) ?? 0.0;
//                 if (entry.debit > 0) entry.credit = 0.0;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCompactCreditField(JournalEntryLine entry) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Credit',
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF475569),
//           ),
//         ),
//         SizedBox(height: 4),
//         Container(
//           height: 36,
//           child: TextField(
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFFE2E8F0)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Color(0xFF3B82F6), width: 1.5),
//               ),
//               filled: true,
//               fillColor: entry.credit > 0 ? Color(0xFFFEF3C7) : Colors.white,
//               contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
//               prefixText: 'OMR ',
//               prefixStyle: TextStyle(
//                 fontSize: 10,
//                 color: Color(0xFF64748B),
//                 fontWeight: FontWeight.w500,
//               ),
//               hintText: '0.00',
//               hintStyle: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
//               isDense: true,
//             ),
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             inputFormatters: [
//               FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
//             ],
//             textAlign: TextAlign.right,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               color: entry.credit > 0 ? Color(0xFFD97706) : Color(0xFF1E293B),
//             ),
//             onChanged: (value) {
//               setState(() {
//                 entry.credit = double.tryParse(value) ?? 0.0;
//                 if (entry.credit > 0) entry.debit = 0.0;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAddLineButton() {
//     return Container(
//       padding: EdgeInsets.all(12),
//       child: OutlinedButton.icon(
//         onPressed: _addNewLine,
//         icon: Icon(Icons.add, size: 16),
//         label: Text('Add Line'),
//         style: OutlinedButton.styleFrom(
//           foregroundColor: Color(0xFF3B82F6),
//           side: BorderSide(color: Color(0xFF3B82F6)),
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//         ),
//       ),
//     );
//   }

//   Widget _buildTotalsCard() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16),
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: _isBalanced ? Color(0xFF10B981) : Color(0xFFEF4444),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: (_isBalanced ? Color(0xFF10B981) : Color(0xFFEF4444))
//                 .withOpacity(0.1),
//             blurRadius: 20,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: _buildTotalItem(
//                   'Total Debit',
//                   _totalDebit,
//                   Color(0xFF059669),
//                   Color(0xFFDCFCE7),
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: _buildTotalItem(
//                   'Total Credit',
//                   _totalCredit,
//                   Color(0xFFD97706),
//                   Color(0xFFFEF3C7),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           Divider(color: Color(0xFFE2E8F0)),
//           SizedBox(height: 16),
//           _buildBalanceStatus(),
//         ],
//       ),
//     );
//   }

//   Widget _buildTotalItem(
//     String label,
//     double amount,
//     Color color,
//     Color bgColor,
//   ) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF64748B),
//             ),
//           ),
//           SizedBox(height: 6),
//           Text(
//             'OMR ${amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBalanceStatus() {
//     return Container(
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: _isBalanced ? Color(0xFFDCFCE7) : Color(0xFFFEE2E2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: _isBalanced ? Color(0xFF059669) : Color(0xFFDC2626),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               _isBalanced ? Icons.check : Icons.warning_rounded,
//               color: Colors.white,
//               size: 16,
//             ),
//           ),
//           SizedBox(width: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 _isBalanced ? 'Entry Balanced' : 'Entry Not Balanced',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: _isBalanced ? Color(0xFF059669) : Color(0xFFDC2626),
//                 ),
//               ),
//               if (!_isBalanced)
//                 Text(
//                   'Difference: OMR ${_difference.abs().toStringAsFixed(2)}',
//                   style: TextStyle(fontSize: 12, color: Color(0xFF991B1B)),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Color(0xFF3B82F6),
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Color(0xFF1E293B),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _referenceController.dispose();
//     _memoController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/model/branches/branch_model.dart';
import 'package:modern_motors_panel/model/chartoAccounts_model.dart';
import 'package:modern_motors_panel/modern_motors/chart_of_account_service.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class JournalEntryLine {
  String? accountId;
  String? accountName;
  String description;
  double debit;
  double credit;

  JournalEntryLine({
    this.accountId,
    this.accountName,
    this.description = '',
    this.debit = 0.0,
    this.credit = 0.0,
  });

  bool get isValid => accountId != null && (debit > 0 || credit > 0);
  bool get hasBothAmounts => debit > 0 && credit > 0;
}

class AddJournalEntryWidget extends StatefulWidget {
  const AddJournalEntryWidget({Key? key}) : super(key: key);

  @override
  State<AddJournalEntryWidget> createState() => _AddJournalEntryWidgetState();
}

class _AddJournalEntryWidgetState extends State<AddJournalEntryWidget> {
  final ChartAccountService _accountService = ChartAccountService();
  final List<JournalEntryLine> _entries = [];
  Map<String, List<AccountTreeNode>> _allAccountsByBranch = {};
  List<ChartAccount> _filteredAccounts = [];
  bool _isLoadingAccounts = true;
  String? _errorLoadingAccounts;
  DateTime _selectedDate = DateTime.now();
  final _referenceController = TextEditingController();
  final _memoController = TextEditingController();
  String? _selectedBranchId;

  @override
  void initState() {
    super.initState();
    _loadChartOfAccounts();
    _addNewLine();
  }

  Future<void> _loadChartOfAccounts() async {
    setState(() {
      _isLoadingAccounts = true;
      _errorLoadingAccounts = null;
    });

    try {
      final subscription = _accountService.watchAllAccounts().listen(
        (accountsData) {
          if (mounted) {
            setState(() {
              _allAccountsByBranch = accountsData;
              _isLoadingAccounts = false;
              if (_selectedBranchId == null && accountsData.isNotEmpty) {
                _selectedBranchId = accountsData.keys.first;
                _updateFilteredAccounts();
              }
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _errorLoadingAccounts = error.toString();
              _isLoadingAccounts = false;
            });
          }
        },
      );

      await subscription.asFuture<void>();
      await subscription.cancel();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorLoadingAccounts = e.toString();
          _isLoadingAccounts = false;
        });
      }
    }
  }

  void _updateFilteredAccounts() {
    if (_selectedBranchId != null &&
        _allAccountsByBranch.containsKey(_selectedBranchId)) {
      final branchAccounts = _allAccountsByBranch[_selectedBranchId]!;
      _filteredAccounts = _flattenAccounts(branchAccounts);
    } else {
      _filteredAccounts = [];
    }
    setState(() {});
  }

  List<ChartAccount> _flattenAccounts(List<AccountTreeNode> branchAccounts) {
    final List<ChartAccount> flatList = [];
    for (final node in branchAccounts) {
      _addAccountsRecursively(node, flatList);
    }
    return flatList;
  }

  void _addAccountsRecursively(AccountTreeNode node, List<ChartAccount> list) {
    list.add(node.account);
    for (final child in node.children) {
      _addAccountsRecursively(child, list);
    }
  }

  void _addNewLine() {
    setState(() {
      _entries.add(JournalEntryLine());
    });
  }

  void _removeLine(int index) {
    if (_entries.length > 1) {
      setState(() {
        _entries.removeAt(index);
      });
    }
  }

  double get _totalDebit =>
      _entries.fold(0.0, (sum, entry) => sum + entry.debit);
  double get _totalCredit =>
      _entries.fold(0.0, (sum, entry) => sum + entry.credit);
  bool get _isBalanced => (_totalDebit - _totalCredit).abs() < 0.01;
  double get _difference => _totalDebit - _totalCredit;

  void _saveEntry() {
    if (_selectedBranchId == null) {
      _showErrorSnackBar('Please select a branch');
      return;
    }

    if (!_isBalanced) {
      _showErrorSnackBar('Journal entry must be balanced');
      return;
    }

    if (!_entries.any((e) => e.isValid)) {
      _showErrorSnackBar('Please add at least one valid entry line');
      return;
    }

    // Check if any entry has both debit and credit
    if (_entries.any((entry) => entry.hasBothAmounts)) {
      _showErrorSnackBar(
        'Each line must have either debit OR credit, not both',
      );
      return;
    }

    // Check if we have at least one debit and one credit entry
    final hasDebit = _entries.any((entry) => entry.debit > 0);
    final hasCredit = _entries.any((entry) => entry.credit > 0);

    if (!hasDebit || !hasCredit) {
      _showErrorSnackBar(
        'Journal entry must have at least one debit and one credit line',
      );
      return;
    }

    // TODO: Implement save logic
    _showSuccessSnackBar('Journal entry saved successfully');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final branchProvider = Provider.of<MmResourceProvider>(context);
    final branches = branchProvider.branchesList;

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: _isLoadingAccounts
          ? _buildLoadingState()
          : _errorLoadingAccounts != null
          ? _buildErrorState()
          : _buildMainContent(branches),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1E293B),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.receipt_long, color: Color(0xFF3B82F6), size: 20),
          ),
          SizedBox(width: 12),
          Text(
            'New Journal Entry',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, size: 18),
          label: Text('Cancel'),
          style: TextButton.styleFrom(foregroundColor: Color(0xFF64748B)),
        ),
        SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: _isBalanced ? _saveEntry : null,
          icon: Icon(Icons.save_outlined, size: 18),
          label: Text('Save Entry'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBackgroundColor: Color(0xFFE2E8F0),
            disabledForegroundColor: Color(0xFF94A3B8),
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF3B82F6)),
          SizedBox(height: 24),
          Text(
            'Loading accounts...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(32),
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFE2E8F0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFFDC2626),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Failed to Load Accounts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 12),
            Text(
              _errorLoadingAccounts!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B)),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadChartOfAccounts,
              icon: Icon(Icons.refresh, size: 18),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(List<BranchModel> branches) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderSection(branches),
          SizedBox(height: 20),
          _buildEntriesSection(),
          SizedBox(height: 20),
          _buildFooterSection(),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(List<BranchModel> branches) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E293B).withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Entry Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildBranchDropdown(branches)),
              SizedBox(width: 16),
              Expanded(child: _buildDateField()),
              SizedBox(width: 16),
              Expanded(child: _buildReferenceField()),
            ],
          ),
          SizedBox(height: 16),
          _buildMemoField(),
        ],
      ),
    );
  }

  Widget _buildBranchDropdown(List<BranchModel> branches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Branch',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedBranchId,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(
                'Select Branch',
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
            ),
            ..._allAccountsByBranch.keys.map((branchId) {
              final branch = branches.firstWhere(
                (b) => b.id == branchId,
                orElse: () => BranchModel(
                  id: branchId,
                  branchName: 'Branch $branchId',
                  address: '',
                ),
              );
              return DropdownMenuItem(
                value: branchId,
                child: Text(branch.branchName, style: TextStyle(fontSize: 14)),
              );
            }).toList(),
          ],
          onChanged: (value) {
            setState(() {
              _selectedBranchId = value;
              _updateFilteredAccounts();
            });
          },
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            height: 56,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: Color(0xFF6B7280)),
                SizedBox(width: 12),
                Text(
                  '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                  style: TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReferenceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reference No.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _referenceController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            hintText: 'Optional',
            hintStyle: TextStyle(color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }

  Widget _buildMemoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Memo',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _memoController,
          maxLines: 3,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(16),
            hintText: 'Add notes or description for this entry...',
            hintStyle: TextStyle(color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }

  Widget _buildEntriesSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E293B).withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildEntriesHeader(),
          Divider(height: 1, color: Color(0xFFE2E8F0)),
          _buildTableHeader(),
          Divider(height: 1, color: Color(0xFFE2E8F0)),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
            itemCount: _entries.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Color(0xFFF1F5F9)),
            itemBuilder: (context, index) => _buildEntryRow(index),
          ),
          _buildTableFooter(),
        ],
      ),
    );
  }

  Widget _buildEntriesHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Text(
            'Transaction Lines',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_entries.length} ${_entries.length == 1 ? 'Line' : 'Lines'}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Color(0xFFF8FAFC),
      child: Row(
        children: [
          Expanded(
            flex: 40,
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 25,
            child: Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 15,
            child: Text(
              'Debit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 15,
            child: Text(
              'Credit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
          SizedBox(width: 16),
          Container(width: 40), // Space for remove button
        ],
      ),
    );
  }

  Widget _buildEntryRow(int index) {
    final entry = _entries[index];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: index.isEven ? Colors.white : Color(0xFFF8FAFC),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Dropdown - 40%
          Expanded(flex: 40, child: _buildCompactAccountDropdown(entry)),
          SizedBox(width: 16),
          // Description - 25%
          Expanded(flex: 25, child: _buildCompactDescriptionField(entry)),
          SizedBox(width: 16),
          // Debit - 15%
          Expanded(flex: 15, child: _buildCompactDebitField(entry)),
          SizedBox(width: 16),
          // Credit - 15%
          Expanded(flex: 15, child: _buildCompactCreditField(entry)),
          SizedBox(width: 16),
          // Remove button
          if (_entries.length > 1)
            Container(
              width: 40,
              child: IconButton(
                icon: Icon(Icons.delete_outline, size: 20),
                onPressed: () => _removeLine(index),
                color: Color(0xFFEF4444),
                tooltip: 'Remove line',
                padding: EdgeInsets.zero,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactAccountDropdown(JournalEntryLine entry) {
    return Container(
      height: 48,
      child: DropdownButtonFormField<String>(
        value: entry.accountId,
        isExpanded: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFD1D5DB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFD1D5DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        hint: Text(
          _selectedBranchId == null ? 'Select branch' : 'Select account',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
        items: _filteredAccounts.map((account) {
          return DropdownMenuItem(
            value: account.id,
            child: Text(
              '${account.accountCode} - ${account.accountName}',
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: _selectedBranchId == null
            ? null
            : (value) {
                setState(() {
                  entry.accountId = value;
                  entry.accountName = _filteredAccounts
                      .firstWhere((a) => a.id == value)
                      .accountName;
                });
              },
      ),
    );
  }

  Widget _buildCompactDescriptionField(JournalEntryLine entry) {
    return Container(
      height: 48,
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFD1D5DB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFD1D5DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          hintText: 'Description...',
          hintStyle: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
        style: TextStyle(fontSize: 14),
        onChanged: (value) {
          entry.description = value;
        },
      ),
    );
  }

  Widget _buildCompactDebitField(JournalEntryLine entry) {
    return Container(
      height: 48,
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFD1D5DB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFD1D5DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
          filled: true,
          fillColor: entry.debit > 0 ? Color(0xFFF0FDF4) : Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          prefixText: 'OMR ',
          prefixStyle: TextStyle(
            fontSize: 14,
            color: Color(0xFF374151),
            fontWeight: FontWeight.w500,
          ),
          hintText: '0.00',
          hintStyle: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: entry.debit > 0 ? Color(0xFF059669) : Color(0xFF1E293B),
        ),
        onChanged: (value) {
          setState(() {
            entry.debit = double.tryParse(value) ?? 0.0;
            if (entry.debit > 0) entry.credit = 0.0;
          });
        },
      ),
    );
  }

  Widget _buildCompactCreditField(JournalEntryLine entry) {
    return Container(
      height: 48,
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFD1D5DB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFD1D5DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
          filled: true,
          fillColor: entry.credit > 0 ? Color(0xFFFFFBEB) : Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          prefixText: 'OMR ',
          prefixStyle: TextStyle(
            fontSize: 14,
            color: Color(0xFF374151),
            fontWeight: FontWeight.w500,
          ),
          hintText: '0.00',
          hintStyle: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: entry.credit > 0 ? Color(0xFFD97706) : Color(0xFF1E293B),
        ),
        onChanged: (value) {
          setState(() {
            entry.credit = double.tryParse(value) ?? 0.0;
            if (entry.credit > 0) entry.debit = 0.0;
          });
        },
      ),
    );
  }

  Widget _buildTableFooter() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: _addNewLine,
            icon: Icon(Icons.add, size: 18),
            label: Text('Add New Line'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          _buildTotalsDisplay(),
        ],
      ),
    );
  }

  Widget _buildTotalsDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          _buildTotalItem('Total Debit', _totalDebit, Color(0xFF059669)),
          SizedBox(width: 24),
          _buildTotalItem('Total Credit', _totalCredit, Color(0xFFD97706)),
          SizedBox(width: 24),
          _buildBalanceIndicator(),
        ],
      ),
    );
  }

  Widget _buildTotalItem(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'OMR ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _isBalanced ? Color(0xFFDCFCE7) : Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(
            _isBalanced ? Icons.check_circle : Icons.error_outline,
            size: 16,
            color: _isBalanced ? Color(0xFF059669) : Color(0xFFDC2626),
          ),
          SizedBox(width: 6),
          Text(
            _isBalanced ? 'Balanced' : 'Not Balanced',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _isBalanced ? Color(0xFF059669) : Color(0xFFDC2626),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Journal Entry Ready',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _isBalanced ? _saveEntry : null,
            icon: Icon(Icons.save_outlined, size: 18),
            label: Text('Save Journal Entry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor: Color(0xFFE2E8F0),
              disabledForegroundColor: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF3B82F6),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _referenceController.dispose();
    _memoController.dispose();
    super.dispose();
  }
}
