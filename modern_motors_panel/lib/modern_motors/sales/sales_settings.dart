// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/modern_motors/sales/credit_days_management_screen.dart';

class SalesSettings extends StatefulWidget {
  const SalesSettings({super.key});

  @override
  State<SalesSettings> createState() => _SalesSettingsState();
}

class _SalesSettingsState extends State<SalesSettings> {
  List<String> titleList = ["Credit Period"];
  List<String> iconList = ["assets/images/administration.svg"];

  void navType(String type) {
    if (type == "Credit Period") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return CreditDaysManagementScreen();
          },
        ),
      );
      // } else if (type == "fines") {
      //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //     return FinesMainPage();
      //   }));
      // } else if (type == "nationality") {
      //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //     return NationalityMainPage();
      //   }));
      // } else if (type == "labourWorkingFields") {
      //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //     return LabourWorkingFields();
      //   }));
      // } else if (type == "timeoutReasons") {
      //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //     return TimeOutMainPage();
      //   }));
      // } else if (type == "equipmentType") {
      //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //     return EquipmentMainScreens();
      //   }));
      // } else if (type == "designation") {
      //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //     return DesignationMainpage();
      //   }));
      // } else if (type == "hierarchy") {
      //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //     return LevelMainPage();
      //   }));
      // } else if (type == "roles") {
      //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //     return RolesMainPage();
      //   }));
      // } else if (type == "leaves") {
      //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //     return LeavesWebView();
      //   }));
      // } else if (type == "deductionCategory") {
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (_) {
      //         return DeductionCategoryView();
      //       },
      //     ),
      //   );
      // } else if (type == "deduction") {
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (_) {
      //         return CategoryTypeView();
      //       },
      //     ),
      //   );
      // } else if (type == "allowance") {
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (_) {
      //         return AllowanceMainPage();
      //       },
      //     ),
      //   );
      // } else if (type == "allowanceCategory") {
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (_) {
      //         return AllowanceCategory();
      //       },
      //     ),
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants.bigScreen = size.width > 800;
    Constants.mediumScreen = size.width >= 500 || size.width <= 700;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            itemCount: titleList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: Constants.bigScreen
                  ? 1.8
                  : Constants.mediumScreen
                  ? 1.5 // More vertical space
                  : 1.3,
              crossAxisCount: Constants.bigScreen
                  ? 6
                  : Constants.mediumScreen
                  ? 4
                  : 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => navType(titleList[index]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.whiteColor,
                            AppTheme.whiteColor.withOpacity(0.98),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              iconList[index],
                              height: constraints.maxHeight * 0.25,
                              width: constraints.maxHeight * 0.25,
                              colorFilter: ColorFilter.mode(
                                AppTheme.primaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            titleList[index].tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: constraints.maxHeight * 0.12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D2D2D),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
