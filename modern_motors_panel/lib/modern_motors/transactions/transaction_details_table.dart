import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/price/price_item.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:provider/provider.dart';

class TransactionDetailTable extends StatelessWidget {
  final List<PriceItem> items;

  const TransactionDetailTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return Column(
      children: [
        // 🔹 HEADER
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Row(
            children: [
              // PRICE x QTY (fixed)
              Container(
                width: context.width * 0.1,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Text(
                  'PRICE × QTY',
                  style: AppTheme.getCurrentTheme(false, connectionStatus)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 12, color: Colors.black),
                ),
              ),
              VerticalDivider(
                thickness: 1,
                color: AppTheme.borderColor,
                width: 1,
              ),

              // ITEM (expanded)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Text(
                    'ITEM',
                    style: AppTheme.getCurrentTheme(false, connectionStatus)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 12, color: Colors.black),
                  ),
                ),
              ),
              VerticalDivider(
                thickness: 1,
                color: AppTheme.borderColor,
                width: 1,
              ),

              // TOTAL (fixed)
              Container(
                width: context.width * 0.1,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                alignment: Alignment.centerRight,
                child: Text(
                  'TOTAL',
                  style: AppTheme.getCurrentTheme(false, connectionStatus)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 12, color: Colors.black),
                ),
              ),
            ],
          ),
        ),

        // 🔹 BODY
        ...items.map((item) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: AppTheme.borderColor),
                right: BorderSide(color: AppTheme.borderColor),
              ),
            ),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        width: context.width * 0.1,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Text(
                          item.priceQty,
                          style: AppTheme.getCurrentTheme(
                            false,
                            connectionStatus,
                          ).textTheme.displayLarge!.copyWith(fontSize: 12),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 1,
                        color: AppTheme.borderColor,
                        width: 1,
                      ),

                      // ITEM
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: Text(
                            item.item,
                            style: AppTheme.getCurrentTheme(
                              false,
                              connectionStatus,
                            ).textTheme.displayLarge!.copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 1,
                        color: AppTheme.borderColor,
                        width: 1,
                      ),

                      // TOTAL
                      Container(
                        width: context.width * 0.1,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        alignment: Alignment.centerRight,
                        child: Text(
                          item.total,
                          style: AppTheme.getCurrentTheme(
                            false,
                            connectionStatus,
                          ).textTheme.displayLarge!.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Text(
                    'TOTAL AMOUNT',
                    style: AppTheme.getCurrentTheme(false, connectionStatus)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(height: 30, width: 1, color: AppTheme.borderColor),
              Container(
                width: context.width * 0.15,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Text(
                  '25.000 OMR',
                  style: AppTheme.getCurrentTheme(false, connectionStatus)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
