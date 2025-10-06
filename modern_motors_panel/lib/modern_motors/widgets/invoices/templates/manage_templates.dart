import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/invoices/templates/estimation_template_preview_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/estimation_preview.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/maintenance_preview_2_preview.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/maintenance_template1_preview.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/retail_layout_preview.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/template_1_preview.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/template_5_preview.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/template_grid_view.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/widgets/empty_widget.dart';
import 'package:provider/provider.dart';

class ManageTemplates extends StatefulWidget {
  const ManageTemplates({super.key});

  @override
  State<ManageTemplates> createState() => _ProductPageState();
}

class _ProductPageState extends State<ManageTemplates> {
  bool showTemplates = true;
  bool loading = false;
  User? user = FirebaseAuth.instance.currentUser;
  List<EstimationTemplatePreviewModel> templatesList = [];

  @override
  void initState() {
    super.initState();
    fetchTemplates();
  }

  void fetchTemplates() async {
    if (loading) return;
    setState(() {
      loading = true;
    });
    try {
      templatesList = await DataFetchService.fetchPreviewTemplated();
      debugPrint('Fetched ${templatesList.length} templates');
    } catch (e) {
      debugPrint('Error fetching templates: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;

    return showTemplates
        ? Column(
            children: [
              PageHeaderWidget(
                title: "Templates".tr(),
                buttonText: "New Template".tr(),
                subTitle: "Manage your templates".tr(),
                requiredPermission: 'Create Template Previews',
                selectedItems: [],
                buttonWidth: 0.34,
                onCreate: () {
                  setState(() {
                    showTemplates = false;
                  });
                },
              ),
              14.h,
              Expanded(
                child: Container(
                  color: Colors.white,
                  width: context.width * 0.6,
                  child: loading
                      ? Center(child: CircularProgressIndicator())
                      : templatesList.isEmpty
                      ? EmptyWidget(text: "No Templates found".tr())
                      : ListView.builder(
                          itemCount: templatesList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14.0,
                                vertical: 10,
                              ),
                              child: InkWell(
                                onTap: () {
                                  final provider = context
                                      .read<MmResourceProvider>();
                                  final permissions =
                                      provider
                                          .employeeModel
                                          ?.profileAccessKey ??
                                      [];
                                  if (permissions.contains(
                                        'Edit Template Previews',
                                      ) ||
                                      user!.uid == Constants.adminId) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => getTemplateWidget(
                                          templatesList[index].type ?? '',
                                        ),
                                        // EstimationTemplatePreview(),
                                      ),
                                    );
                                  } else {
                                    Constants.showMessage(
                                      context,
                                      'You don not have permission to edit it',
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: context.width * 0.05,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppTheme
                                                  .pageHeaderSubTitleColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Image.asset(
                                            // 'assets/images/img_3.png',
                                            getThumbnailForType(
                                              templatesList[index].type,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        8.w,
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${templatesList[index].type?.capitalizeFirst ?? '---'} Invoice',
                                              style:
                                                  AppTheme.getCurrentTheme(
                                                        false,
                                                        connectionStatus,
                                                      ).textTheme.displayMedium!
                                                      .copyWith(
                                                        color: AppTheme.black50,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Created At: ',
                                                  style:
                                                      AppTheme.getCurrentTheme(
                                                            false,
                                                            connectionStatus,
                                                          )
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            color: AppTheme
                                                                .black50,
                                                          ),
                                                ),
                                                Text(
                                                  templatesList[index]
                                                      .timestamp!
                                                      .toDate()
                                                      .formattedWithDayMonthYear,
                                                  style:
                                                      AppTheme.getCurrentTheme(
                                                            false,
                                                            connectionStatus,
                                                          )
                                                          .textTheme
                                                          .displaySmall!
                                                          .copyWith(
                                                            color: AppTheme
                                                                .toOrdersTextColor,
                                                          ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // buildActionButton(
                                    //   icon: Icons.edit_rounded,
                                    //   color: const Color(0xFF059669),
                                    //   onTap: () {
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder:
                                    //             (context) => getTemplateWidget(
                                    //               templatesList[index].type ?? '',
                                    //             ),
                                    //         // EstimationTemplatePreview(),
                                    //       ),
                                    //     );
                                    //   },
                                    //   tooltip: 'Edit',
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          )
        : TemplateGridView(
            onBack: () {
              debugPrint('pressed');
              setState(() {
                showTemplates = true;
              });
            },
          );
  }
}

// Put this near the top (replace your old 'templates' & 'templatesName' lists)

// type -> asset thumbnail
const Map<String, String> kTemplateThumbnails = {
  'Estimation': 'assets/images/img.png',
  'Template 1': 'assets/images/img_3.png',
  'Template 5': 'assets/images/img_2.png',
  'Retail': 'assets/images/document (7)_page-0001.jpg',
  'Maintenance Template 1': 'assets/images/document (9)_page-0001.jpg',
  'Maintenance Template 2': 'assets/images/document (8)_page-0001.jpg',
};

// Fallback image if an unknown type comes from backend
const String kDefaultTemplateThumb = 'assets/images/img.png';

Widget getTemplateWidget(String templateKey) {
  switch (templateKey) {
    case 'Estimation':
      return EstimationTemplatePreview();
    case 'Template 1':
      return Template1Preview();
    case 'Template 5':
      return Template5Preview();
    case 'Retail':
      return RetailLayoutPreview();
    case 'Maintenance Template 1':
      return MaintenanceTemplate1Preview();
    case 'Maintenance Template 2':
      return MaintenanceTemplate2Preview();
    default:
      return const Center(child: Text('No Template Selected'));
  }
}

String getThumbnailForType(String? type) {
  if (type == null) return kDefaultTemplateThumb;
  return kTemplateThumbnails[type] ?? kDefaultTemplateThumb;
}
