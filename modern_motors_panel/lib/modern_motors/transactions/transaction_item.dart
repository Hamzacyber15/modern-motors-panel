import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/price/price_item.dart';
import 'package:modern_motors_panel/modern_motors/transactions/transaction_details_table.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:provider/provider.dart';

class TransactionItem {
  final String date;
  final String transaction;
  final String amount;
  final String balanceDue;
  final List<PriceItem> priceItems;

  TransactionItem({
    required this.date,
    required this.transaction,
    required this.amount,
    required this.balanceDue,
    required this.priceItems,
  });
}

class TransactionTable extends StatelessWidget {
  final List<TransactionItem> transactions;
  final bool isDetailed;

  const TransactionTable({
    super.key,
    required this.transactions,
    required this.isDetailed,
  });

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return Column(
      children: [
        // Header row
        Container(
          decoration: BoxDecoration(
            color: AppTheme.darkTeal,
            border: Border(
              top: borderSide(color: AppTheme.borderColor),
              left: borderSide(color: AppTheme.borderColor),
              right: borderSide(color: AppTheme.borderColor),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10),
                width: context.width * 0.12,
                child: Text(
                  'DATE',
                  style: AppTheme.getCurrentTheme(false, connectionStatus)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 12, color: Colors.white),
                ),
              ),
              Container(height: 30, width: 1, color: AppTheme.borderColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'TRANSACTION',
                    style: AppTheme.getCurrentTheme(false, connectionStatus)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
              Container(height: 30, width: 1, color: AppTheme.borderColor),
              Container(
                padding: EdgeInsets.only(right: 10),
                alignment: Alignment.centerRight,
                width: context.width * 0.12,
                child: Text(
                  'AMOUNT',
                  style: AppTheme.getCurrentTheme(false, connectionStatus)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 12, color: Colors.white),
                ),
              ),
              Container(height: 30, width: 1, color: AppTheme.borderColor),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 10),
                width: context.width * 0.12,
                child: Text(
                  'BALANCE DUE',
                  style: AppTheme.getCurrentTheme(false, connectionStatus)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  top: borderSide(color: AppTheme.borderColor),
                  left: borderSide(color: AppTheme.borderColor),
                  right: borderSide(color: AppTheme.borderColor),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 4, bottom: 4),
                      width: context.width * 0.12,
                      alignment: Alignment.topLeft,
                      child: Text(
                        tx.date,
                        style: AppTheme.getCurrentTheme(false, connectionStatus)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    VerticalDivider(
                      thickness: 1,
                      color: AppTheme.borderColor,
                      width: 1,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                              top: 4,
                              bottom: 4,
                            ),
                            child: Text(
                              tx.transaction,
                              style: AppTheme.getCurrentTheme(
                                false,
                                connectionStatus,
                              ).textTheme.displayLarge!.copyWith(fontSize: 12),
                            ),
                          ),
                          if (isDetailed) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: TransactionDetailTable(
                                items: tx.priceItems,
                              ),
                            ),
                            4.h,
                          ],
                        ],
                      ),
                    ),
                    VerticalDivider(
                      thickness: 1,
                      color: AppTheme.borderColor,
                      width: 1,
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10, top: 4, bottom: 4),
                      width: context.width * 0.12,
                      alignment: Alignment.topRight,
                      child: Text(
                        tx.amount,
                        style: AppTheme.getCurrentTheme(false, connectionStatus)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    VerticalDivider(
                      thickness: 1,
                      color: AppTheme.borderColor,
                      width: 1,
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10, top: 4),
                      width: context.width * 0.12,
                      alignment: Alignment.topRight,
                      child: Text(
                        tx.balanceDue,
                        style: AppTheme.getCurrentTheme(false, connectionStatus)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // Footer row
        Container(
          decoration: BoxDecoration(
            color: AppTheme.darkTeal,
            border: Border(
              top: borderSide(color: AppTheme.borderColor),
              left: borderSide(color: AppTheme.borderColor),
              right: borderSide(color: AppTheme.borderColor),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'END OF PERIOD BALANCE',
                    style: AppTheme.getCurrentTheme(false, connectionStatus)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
              Container(height: 30, width: 1, color: AppTheme.borderColor),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 10),
                width: context.width * 0.2406,
                child: Text(
                  '0.000 OMR',
                  style: AppTheme.getCurrentTheme(false, connectionStatus)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BorderSide borderSide({required Color color}) {
    return BorderSide(color: color);
  }
}
