import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/modern_motors/customers/client_page.dart';
import 'package:modern_motors_panel/modern_motors/supplier/supplier_page.dart';
import 'package:modern_motors_panel/modern_motors/transactions/transaction_item.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/top_tab.dart';
import 'package:modern_motors_panel/modern_motors/widgets/top_tab_dropdown.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:provider/provider.dart';

class TransactionTab extends StatefulWidget {
  final List<DropdownItem> exportMethods;
  final DropdownItem? selectedExportMethod;

  const TransactionTab({
    super.key,
    required this.exportMethods,
    required this.selectedExportMethod,
  });

  @override
  State<TransactionTab> createState() => _TransactionTabState();
}

class _TransactionTabState extends State<TransactionTab> {
  bool status = false;
  DateTimeRange? selectedRange;

  void toggleSwitch(bool value) {
    setState(() {
      status = value;
    });
  }

  Future<DateTimeRange?> showDateRangePickerDialog(BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: now.subtract(const Duration(days: 7)),
        end: now,
      ),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year + 100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // picker color
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    return pickedRange;
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final range = await showDateRangePickerDialog(context);
                        if (range != null) {
                          setState(() => selectedRange = range);
                        }
                      },
                      child: Container(
                        width: selectedRange == null
                            ? context.width * 0.1
                            : context.width * 0.186,
                        padding: EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.borderColor),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.date_range),
                            6.w,
                            Text(
                              selectedRange == null
                                  ? 'Date Range'
                                  : '${selectedRange!.start.formattedWithDayMonthYear} → ${selectedRange!.end.formattedWithDayMonthYear}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    6.w,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.borderColor.withValues(alpha: 0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StatusSwitchWidget(
                            scale: 0.8,
                            isSwitched: status,
                            onChanged: toggleSwitch,
                            title: '',
                          ),
                          Text('Show Details'),
                          10.w,
                        ],
                      ),
                    ),
                  ],
                ),
                12.h,
                Text(
                  'Statement',
                  style: AppTheme.getCurrentTheme(
                    false,
                    connectionStatus,
                  ).textTheme.titleLarge!.copyWith(fontSize: 16),
                ),
                Text(
                  'Budget Investment LLC',
                  style: AppTheme.getCurrentTheme(
                    false,
                    connectionStatus,
                  ).textTheme.titleLarge!.copyWith(fontSize: 12),
                ),
                Text(
                  'Oman',
                  style: AppTheme.getCurrentTheme(false, connectionStatus)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    topTab(
                      onTap: () {},
                      icon: Icons.settings,
                      title: 'Customize',
                      color: Colors.blue.shade50,
                    ),
                    2.w,
                    topTab(
                      onTap: () {},
                      icon: Icons.print,
                      title: 'Print',
                      color: Colors.blue.shade50,
                    ),
                    2.w,
                    topTabDropdown(
                      title: 'Payment Method',
                      items: widget.exportMethods,
                      selectedValue: widget.selectedExportMethod,
                      onChanged: (val) {},
                      color: Colors.blue,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    14.h,
                    Image.asset('assets/images/logo1.png', height: 50),
                    10.h,
                    Text(
                      'MODERN HANDS SILVER',
                      style: AppTheme.getCurrentTheme(
                        false,
                        connectionStatus,
                      ).textTheme.titleLarge!.copyWith(fontSize: 12),
                    ),
                    Text(
                      'BARKA SULTANTE OF OMAN',
                      style: AppTheme.getCurrentTheme(false, connectionStatus)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '92478551 info@ish.com',
                      style: AppTheme.getCurrentTheme(false, connectionStatus)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'VAT NO. OM110030683',
                      style: AppTheme.getCurrentTheme(false, connectionStatus)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    10.h,
                    Row(
                      children: [
                        Text(
                          'Date:',
                          style: AppTheme.getCurrentTheme(
                            false,
                            connectionStatus,
                          ).textTheme.titleLarge!.copyWith(fontSize: 12),
                        ),
                        4.w,
                        Text(
                          '09/10/2025',
                          style: AppTheme.getCurrentTheme(
                            false,
                            connectionStatus,
                          ).textTheme.titleLarge!.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Text(
          'Transaction List till 09/10/2025',
          style: AppTheme.getCurrentTheme(false, connectionStatus)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        //  TransactionTable(transactions: transactions, isDetailed: status),
      ],
    );
  }
}
