import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/chartoAccounts_model.dart';
import 'package:modern_motors_panel/modern_motors/chart_of_account_service.dart';

class AddSubAccountDialog extends StatefulWidget {
  final ChartAccount parentAccount;
  final ChartAccountService accountService;

  const AddSubAccountDialog({
    super.key,
    required this.parentAccount,
    required this.accountService,
  });

  @override
  AddSubAccountDialogState createState() => AddSubAccountDialogState();
}

class AddSubAccountDialogState extends State<AddSubAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedType = 'expense';
  String _selectedSubType = 'operatingExpense';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with parent's type
    _selectedType = widget.parentAccount.accountType;
    _updateSubTypes();
  }

  void _updateSubTypes() {
    // Set appropriate sub-type based on account type
    switch (_selectedType) {
      case 'asset':
        _selectedSubType = 'currentAssets';
        break;
      case 'liability':
        _selectedSubType = 'currentLiabilities';
        break;
      case 'equity':
        _selectedSubType = 'equity';
        break;
      case 'revenue':
        _selectedSubType = 'revenue';
        break;
      case 'expense':
        _selectedSubType = 'operatingExpense';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Sub-Account'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Parent account info
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_tree, color: Colors.blue, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Parent: ${widget.parentAccount.accountName}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Level: ${widget.parentAccount.level} → ${widget.parentAccount.level + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Code: ${widget.parentAccount.accountCode}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Account Code *',
                  hintText: 'e.g., 5101, 5102, 510101',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Account code is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Account Name *',
                  hintText: 'e.g., Office Supplies, Travel Expenses',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Account name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Account Type *',
                  border: OutlineInputBorder(),
                ),
                items: [
                  _buildDropdownItem('asset', 'Assets'),
                  _buildDropdownItem('liability', 'Liabilities'),
                  _buildDropdownItem('equity', 'Equity'),
                  _buildDropdownItem('revenue', 'Revenue'),
                  _buildDropdownItem('expense', 'Expenses'),
                ],
                onChanged: _isLoading
                    ? null
                    : (value) {
                        setState(() {
                          _selectedType = value!;
                          _updateSubTypes();
                        });
                      },
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedSubType,
                decoration: InputDecoration(
                  labelText: 'Account Sub-Type *',
                  border: OutlineInputBorder(),
                ),
                items: _getSubTypeOptions(),
                onChanged: _isLoading
                    ? null
                    : (value) {
                        setState(() {
                          _selectedSubType = value!;
                        });
                      },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          child: _isLoading
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Add Sub-Account'),
        ),
      ],
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String value, String text) {
    return DropdownMenuItem(value: value, child: Text(text));
  }

  List<DropdownMenuItem<String>> _getSubTypeOptions() {
    switch (_selectedType) {
      case 'asset':
        return [
          _buildDropdownItem('currentAssets', 'Current Assets'),
          _buildDropdownItem('fixedAssets', 'Fixed Assets'),
          _buildDropdownItem('investments', 'Investments'),
          _buildDropdownItem('otherAssets', 'Other Assets'),
        ];
      case 'liability':
        return [
          _buildDropdownItem('currentLiabilities', 'Current Liabilities'),
          _buildDropdownItem('longTermLiabilities', 'Long Term Liabilities'),
          _buildDropdownItem('otherLiabilities', 'Other Liabilities'),
        ];
      case 'equity':
        return [
          _buildDropdownItem('equity', 'Equity'),
          _buildDropdownItem('retainedEarnings', 'Retained Earnings'),
          _buildDropdownItem('ownersCapital', 'Owner\'s Capital'),
        ];
      case 'revenue':
        return [
          _buildDropdownItem('revenue', 'Revenue'),
          _buildDropdownItem('salesRevenue', 'Sales Revenue'),
          _buildDropdownItem('serviceRevenue', 'Service Revenue'),
          _buildDropdownItem('otherRevenue', 'Other Revenue'),
        ];
      case 'expense':
        return [
          _buildDropdownItem('operatingExpense', 'Operating Expense'),
          _buildDropdownItem('costOfGoodsSold', 'Cost of Goods Sold'),
          _buildDropdownItem('salariesWages', 'Salaries & Wages'),
          _buildDropdownItem('rentExpense', 'Rent Expense'),
          _buildDropdownItem('utilitiesExpense', 'Utilities Expense'),
          _buildDropdownItem('marketingExpense', 'Marketing Expense'),
          _buildDropdownItem('travelExpense', 'Travel Expense'),
          _buildDropdownItem('officeSupplies', 'Office Supplies'),
          _buildDropdownItem('depreciation', 'Depreciation'),
          _buildDropdownItem('otherExpenses', 'Other Expenses'),
        ];
      default:
        return [_buildDropdownItem('other', 'Other')];
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newAccount = ChartAccount(
        id: '', // Will be generated by service
        accountCode: _codeController.text.trim(),
        accountName: _nameController.text.trim(),
        accountSubType: _selectedSubType,
        accountType: _selectedType,
        childAccountIds: [],
        createdAt: DateTime.now(),
        currentBalance: 0,
        description: _descriptionController.text.trim(),
        isActive: true,
        isDefault: false,
        level: widget.parentAccount.level + 1, // Increment level
        refId: widget.parentAccount.refId,
        parentAccountId: null, // Will be set by service
        branchId: widget.parentAccount.branchId,
      );

      await widget.accountService.addSubAccount(
        parentAccountId: widget.parentAccount.id!,
        accountData: newAccount,
        branchId: widget.parentAccount.branchId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sub-account added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding sub-account: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
