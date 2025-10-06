import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/provider/hide_app_bar_provider.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class PageHeaderWidget extends StatefulWidget {
  final String title;
  final String subTitle;
  final List<String> selectedItems;
  final VoidCallback? onCreate;
  final VoidCallback? onPdfImport;
  final VoidCallback? onExelImport;
  final VoidCallback? onImport;
  final String buttonText;
  final String importButtonText;
  final String? requiredPermission;
  final double buttonWidth;
  final Future<void> Function()? onDelete;
  final Widget? setLogos;
  final bool selection;
  final Future<void> Function()? onDesignation;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onAddInInvoice;
  final String onCreateIcon;

  const PageHeaderWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.selectedItems,
    required this.onCreate,
    this.onDelete,
    this.setLogos,
    this.selection = false,
    this.onDesignation,
    this.onAddInInvoice,
    required this.buttonText,
    this.requiredPermission,
    this.importButtonText = 'Import Product',
    this.onPdfImport,
    this.onExelImport,
    this.buttonWidth = 0.16,
    this.onImport,
    this.onRefresh,
    this.onCreateIcon = 'assets/images/add-circle.png',
  });

  @override
  State<PageHeaderWidget> createState() => _PageHeaderWidgetState();
}

class _PageHeaderWidgetState extends State<PageHeaderWidget> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<MmResourceProvider>(context, listen: false);
    provider.listenToEmployee(user!.uid);
    // provider.listenToEmployee("O4cq5T5khYsyePxfA9Bd");
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return Container(
      color: Color(0xffF2F2F2),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = Constants.isMobileView(constraints);
          final headerText = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: AppTheme.getCurrentTheme(
                  false,
                  connectionStatus,
                ).textTheme.displayMedium,
              ),
              Text(
                widget.subTitle,
                style: AppTheme.getCurrentTheme(
                  false,
                  connectionStatus,
                ).textTheme.displaySmall,
              ),
            ],
          );

          final actionButtons = Consumer<MmResourceProvider>(
            builder: (context, value, child) {
              final hasPermission =
                  user!.uid == Constants.adminId ||
                  widget.requiredPermission == null ||
                  (value.employeeModel?.profileAccessKey?.contains(
                        widget.requiredPermission,
                      ) ??
                      false);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.selectedItems.isNotEmpty
                      ? Row(
                          children: [
                            if (widget.onAddInInvoice != null) ...[
                              SizedBox(
                                height: isMobile
                                    ? context.height * 0.062
                                    : context.height * 0.06,
                                width: isMobile
                                    ? context.width * 0.065
                                    : context.width * 0.12,
                                child: CustomButton(
                                  text: isMobile ? '' : 'Add in invoice',
                                  onPressed: widget.onAddInInvoice,
                                  iconAsset: 'assets/images/due invoices.png',
                                  iconColor: AppTheme.whiteColor,
                                  buttonType: ButtonType.IconAndText,
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                              ),
                              10.w,
                            ],
                            if (widget.onDelete != null)
                              SizedBox(
                                height: isMobile
                                    ? context.height * 0.062
                                    : context.height * 0.06,
                                width: isMobile
                                    ? context.height * 0.065
                                    : context.height * 0.16,
                                child: CustomButton(
                                  text: isMobile ? '' : 'Delete',
                                  onPressed: widget.onDelete,
                                  iconAsset: 'assets/images/delete.png',
                                  buttonType: ButtonType.IconAndText,
                                  backgroundColor: AppTheme.redColor,
                                ),
                              ),
                            10.w,
                            10.w,
                            if (widget.onDesignation != null)
                              SizedBox(
                                height: isMobile
                                    ? context.height * 0.062
                                    : context.height * 0.06,
                                width: isMobile
                                    ? context.height * 0.065
                                    : context.height * 0.16,
                                child: CustomButton(
                                  onPressed: widget.onDesignation,
                                  iconAsset:
                                      'assets/icons/assign_designation.png',
                                  iconColor: AppTheme.whiteColor,
                                  buttonType: ButtonType.IconAndText,
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                              ),
                          ],
                        )
                      : Row(
                          children: [
                            if (widget.selection) ...[
                              if (widget.setLogos != null) widget.setLogos!,
                            ] else ...[
                              if (widget.onPdfImport != null) ...[
                                SizedBox(
                                  height: context.height * 0.062,
                                  width: context.height * 0.065,
                                  child: CustomButton(
                                    onPressed: widget.onPdfImport,
                                    iconAsset: 'assets/images/pdf.png',
                                    buttonType: ButtonType.IconOnly,
                                    borderColor: AppTheme.borderColor,
                                    backgroundColor: AppTheme.whiteColor,
                                    iconSize: 20,
                                  ),
                                ),
                                6.w,
                              ],
                              if (widget.onExelImport != null) ...[
                                SizedBox(
                                  height: context.height * 0.062,
                                  width: context.height * 0.065,
                                  child: CustomButton(
                                    onPressed: widget.onExelImport,
                                    iconAsset: 'assets/images/excel sheet.png',
                                    buttonType: ButtonType.IconOnly,
                                    borderColor: AppTheme.borderColor,
                                    backgroundColor: AppTheme.whiteColor,
                                    iconSize: 20,
                                  ),
                                ),
                                6.w,
                              ],
                              SizedBox(
                                height: context.height * 0.062,
                                width: context.height * 0.065,
                                child: CustomButton(
                                  onPressed: widget.onRefresh,
                                  iconAsset: 'assets/images/recycle.png',
                                  buttonType: ButtonType.IconOnly,
                                  borderColor: AppTheme.borderColor,
                                  backgroundColor: AppTheme.whiteColor,
                                  iconColor: AppTheme.pageHeaderSubTitleColor,
                                  iconSize: 12,
                                ),
                              ),
                              6.w,
                              SizedBox(
                                height: context.height * 0.062,
                                width: context.height * 0.065,
                                child: Consumer<HideAppbarProvider>(
                                  builder: (context, provider, child) {
                                    return CustomButton(
                                      onPressed: () {
                                        final isAppbarVisible =
                                            provider.getIsBarValue;
                                        provider.setIsBarValue(
                                          !isAppbarVisible,
                                        );
                                      },
                                      iconAsset: provider.getIsBarValue == true
                                          ? 'assets/images/up arrow.png'
                                          : 'assets/images/down arrow.png',
                                      buttonType: ButtonType.IconOnly,
                                      borderColor: AppTheme.borderColor,
                                      backgroundColor: AppTheme.whiteColor,
                                      iconColor:
                                          AppTheme.pageHeaderSubTitleColor,
                                      iconSize: 12,
                                    );
                                  },
                                ),
                              ),
                              6.w,
                              if (widget.onCreate != null) ...[
                                if (hasPermission)
                                  SizedBox(
                                    height: isMobile
                                        ? context.height * 0.062
                                        : context.height * 0.06,
                                    width: isMobile
                                        ? context.height * 0.065
                                        : context.height * widget.buttonWidth,
                                    child: CustomButton(
                                      text: isMobile ? '' : widget.buttonText,
                                      onPressed: widget.onCreate,
                                      iconAsset: widget.onCreateIcon,
                                      iconColor: AppTheme.whiteColor,
                                      buttonType: ButtonType.IconAndText,
                                      backgroundColor: AppTheme.primaryColor,
                                      textColor: AppTheme.whiteColor,
                                    ),
                                  ),
                              ],
                            ],
                            // if (onImport != null) ...[
                            //   6.w,
                            //   SizedBox(
                            //     height:
                            //         isMobile
                            //             ? context.height * 0.062
                            //             : context.height * 0.06,
                            //     width:
                            //         isMobile
                            //             ? context.height * 0.065
                            //             : context.height * 0.27,
                            //     child: CustomButton(
                            //       text: isMobile ? '' : importButtonText,
                            //       onPressed: () {},
                            //       iconAsset: 'assets/icons/export_icon.png',
                            //       buttonType: ButtonType.iconAndText,
                            //       backgroundColor: AppTheme.primaryColor,
                            //       textColor: AppTheme.whiteColor,
                            //       iconColor: AppTheme.whiteColor,
                            //     ),
                            //   ),
                            // ],
                          ],
                        ),
                ],
              );
            },
          );

          return Column(
            children: [
              22.h,
              Padding(
                padding: isMobile
                    ? EdgeInsets.only(right: 24, top: 20, bottom: 10, left: 10)
                    : EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [headerText, 12.h, actionButtons],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [headerText, actionButtons],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
