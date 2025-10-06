import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/model/services_model/services_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';

class ServiceSelectionRow extends StatefulWidget {
  final List<ServiceTypeModel> allServices;
  final Function(double) onTotalChanged;
  final VoidCallback onRemove;
  final bool showRemoveButton;

  const ServiceSelectionRow({
    super.key,
    required this.allServices,
    required this.onTotalChanged,
    required this.onRemove,
    this.showRemoveButton = true,
  });

  @override
  State<ServiceSelectionRow> createState() => _ServiceSelectionRowState();
}

class _ServiceSelectionRowState extends State<ServiceSelectionRow> {
  ServiceTypeModel? _selectedService;
  double? _selectedPrice;
  int _quantity = 1;
  double _discount = 0;
  bool _applyVat = true;
  double _subtotal = 0;
  double _vatAmount = 0;
  double _total = 0;

  // Discount options (percentage)
  final List<double> discountOptions = [0, 5, 10, 15, 20, 25];

  @override
  void initState() {
    super.initState();
    _calculateTotals();
  }

  void _calculateTotals() {
    setState(() {
      // Calculate subtotal
      _subtotal = (_selectedPrice ?? 0) * _quantity;

      // Apply discount
      final discountAmount = _subtotal * (_discount / 100);
      final amountAfterDiscount = _subtotal - discountAmount;

      // Calculate VAT (5% if applied)
      _vatAmount = _applyVat ? amountAfterDiscount * 0.05 : 0;

      // Calculate final total
      _total = amountAfterDiscount + _vatAmount;

      // Notify parent about the total
      widget.onTotalChanged(_total);
    });
  }

  void _onServiceSelected(ServiceTypeModel? service) {
    setState(() {
      _selectedService = service;
      // Reset price when service changes
      _selectedPrice = null;
      _calculateTotals();
    });
  }

  void _onPriceSelected(double? price) {
    setState(() {
      _selectedPrice = price;
      _calculateTotals();
    });
  }

  void _onQuantityChanged(int quantity) {
    setState(() {
      _quantity = quantity;
      _calculateTotals();
    });
  }

  void _onDiscountChanged(double discount) {
    setState(() {
      _discount = discount;
      _calculateTotals();
    });
  }

  void _onVatChanged(bool applyVat) {
    setState(() {
      _applyVat = applyVat;
      _calculateTotals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          // Service Dropdown
          Expanded(flex: 2, child: _buildServiceDropdown()),
          const SizedBox(width: 8),

          // Price Dropdown
          Expanded(flex: 2, child: _buildPriceDropdown()),
          const SizedBox(width: 8),

          // Quantity Dropdown
          Expanded(flex: 1, child: _buildQuantityDropdown()),
          const SizedBox(width: 8),

          // Discount Dropdown
          Expanded(flex: 1, child: _buildDiscountDropdown()),
          const SizedBox(width: 8),

          // Subtotal
          Expanded(flex: 1, child: _buildAmountDisplay('Subtotal', _subtotal)),
          const SizedBox(width: 8),

          // VAT Toggle
          Expanded(flex: 1, child: _buildVatToggle()),
          const SizedBox(width: 8),

          // Total
          Expanded(flex: 1, child: _buildAmountDisplay('Total', _total)),
          const SizedBox(width: 8),

          // Remove Button
          if (widget.showRemoveButton)
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: widget.onRemove,
            ),
        ],
      ),
    );
  }

  Widget _buildServiceDropdown() {
    // Convert services to a map for the dropdown
    final Map<String, String> serviceMap = {
      for (var service in widget.allServices)
        service.id ?? service.name: service.name,
    };

    return CustomSearchableDropdown(
      hintText: 'Select Service',
      items: serviceMap,
      value: _selectedService?.id ?? _selectedService?.name,
      onChanged: (value) {
        final selected = widget.allServices.firstWhere(
          (service) => service.id == value || service.name == value,
          orElse: () => ServiceTypeModel(name: '', createdBy: ""),
        );
        _onServiceSelected(selected.name.isNotEmpty ? selected : null);
      },
    );
  }

  Widget _buildPriceDropdown() {
    // Get available prices for selected service
    final prices = _selectedService?.prices ?? [];

    // If no service selected or no prices, show disabled dropdown
    if (_selectedService == null || prices.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[100],
        ),
        child: const Text(
          'Select service first',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Create price options map
    final Map<String, String> priceOptions = {};
    for (var price in prices) {
      if (price is num) {
        final priceValue = price.toDouble();
        priceOptions[priceValue.toString()] =
            '\$${priceValue.toStringAsFixed(2)}';
      }
    }

    return CustomSearchableDropdown(
      hintText: 'Select Price',
      items: priceOptions,
      value: _selectedPrice?.toString(),
      onChanged: (value) {
        if (value != null) {
          _onPriceSelected(double.parse(value));
        }
      },
    );
  }

  Widget _buildQuantityDropdown() {
    // Create quantity options (1-10)
    final Map<String, String> quantityOptions = {};
    for (int i = 1; i <= 10; i++) {
      quantityOptions[i.toString()] = i.toString();
    }

    return CustomSearchableDropdown(
      hintText: 'Qty',
      items: quantityOptions,
      value: _quantity.toString(),
      onChanged: (value) {
        if (value != null) {
          _onQuantityChanged(int.parse(value));
        }
      },
    );
  }

  Widget _buildDiscountDropdown() {
    // Create discount options map
    final Map<String, String> discountOptionsMap = {};
    for (var discount in discountOptions) {
      discountOptionsMap[discount.toString()] = '$discount%';
    }

    return CustomSearchableDropdown(
      hintText: 'Discount',
      items: discountOptionsMap,
      value: _discount.toString(),
      onChanged: (value) {
        if (value != null) {
          _onDiscountChanged(double.parse(value));
        }
      },
    );
  }

  Widget _buildVatToggle() {
    return Row(
      children: [
        Checkbox(
          value: _applyVat,
          onChanged: (value) {
            _onVatChanged(value ?? false);
          },
        ),
        const SizedBox(width: 4),
        const Text('VAT 5%'),
      ],
    );
  }

  Widget _buildAmountDisplay(String label, double amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }
}

class ServiceSelectionPanel extends StatefulWidget {
  final List<ServiceTypeModel> allServices;

  const ServiceSelectionPanel({super.key, required this.allServices});

  @override
  State<ServiceSelectionPanel> createState() => _ServiceSelectionPanelState();
}

class _ServiceSelectionPanelState extends State<ServiceSelectionPanel> {
  final List<double> _rowTotals = [];
  double _grandTotal = 0;

  void _addRow() {
    setState(() {
      _rowTotals.add(0);
    });
  }

  void _removeRow(int index) {
    setState(() {
      _rowTotals.removeAt(index);
      _calculateGrandTotal();
    });
  }

  void _updateRowTotal(int index, double total) {
    setState(() {
      if (index < _rowTotals.length) {
        _rowTotals[index] = total;
        _calculateGrandTotal();
      }
    });
  }

  void _calculateGrandTotal() {
    setState(() {
      _grandTotal = _rowTotals.fold(0, (sum, total) => sum + total);
    });
  }

  @override
  void initState() {
    super.initState();
    // Start with one empty row
    _rowTotals.add(0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Service',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Price',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Qty',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Discount',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Subtotal',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'VAT',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 40), // Space for remove button
            ],
          ),
        ),

        // Service Rows
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _rowTotals.length,
          itemBuilder: (context, index) {
            return ServiceSelectionRow(
              allServices: widget.allServices,
              onTotalChanged: (total) => _updateRowTotal(index, total),
              onRemove: () => _removeRow(index),
              showRemoveButton:
                  _rowTotals.length > 1, // Don't show remove for the only row
            );
          },
        ),

        const SizedBox(height: 16),

        // Add Row Button
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _addRow,
            icon: const Icon(Icons.add),
            label: const Text('Add Another Service'),
          ),
        ),

        const SizedBox(height: 24),

        // Grand Total
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.primaryColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'GRAND TOTAL:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${_grandTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Usage example:
/*
ServiceSelectionPanel(
  allServices: yourListOfServices,
)
*/
