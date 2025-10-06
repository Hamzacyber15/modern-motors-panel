import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/estimation_preview.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/maintenance_preview_2_preview.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/maintenance_template1_preview.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/retail_layout_preview.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/template_1_preview.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/templates/previews.dart/template_5_preview.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';

class TemplateGridView extends StatelessWidget {
  final VoidCallback? onBack;

  const TemplateGridView({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeaderWidget(
          title: 'Choose Template',
          buttonText: 'Back to Manage',
          subTitle: 'Choose the template you want to edit',
          onCreateIcon: 'assets/images/back.png',
          selectedItems: [],
          buttonWidth: 0.4,
          onCreate: onBack!.call,
          onDelete: () async {},
        ),
        20.h,
        Container(
          height: context.height * 0.7,
          width: context.width * 0.6,
          decoration: BoxDecoration(color: Colors.white),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Define how many columns we want in the GridView based on screen width
              int crossAxisCount = constraints.maxWidth > 400 ? 4 : 2;

              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      crossAxisCount, // Dynamically adjust number of columns
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.8,
                ),
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 170,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    getTemplateWidget(templatesName[index]),
                                // builder: (context) => Template1Preview(),
                                // builder: (context) => RetailLayoutPreview(),
                                // (context) => EstimationTemplatePreview(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.pageHeaderSubTitleColor,
                                width: 1.5,
                              ),
                            ),
                            child: Image.asset(
                              templates[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      4.h,
                      Text(templatesName[index]),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

List templates = [
  'assets/images/img.png',
  'assets/images/img_3.png',
  'assets/images/img_2.png',
  'assets/images/document (7)_page-0001.jpg',
  'assets/images/document (9)_page-0001.jpg',
  'assets/images/document (8)_page-0001.jpg',
];
List templatesName = [
  'Estimation Template',
  'Template 1',
  'Template 5',
  'Retail',
  'Maintenance Template 1',
  'Maintenance Template 2',
];

Widget getTemplateWidget(String templateKey) {
  switch (templateKey) {
    case 'Estimation Template':
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
