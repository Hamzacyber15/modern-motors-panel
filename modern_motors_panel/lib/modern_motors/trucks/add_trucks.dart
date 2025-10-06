// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/firebase_services/data_upload_service.dart';
import 'package:modern_motors_panel/model/admin_model/country_model.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/drop_down_menu_model.dart';
import 'package:modern_motors_panel/model/trucks/mm_trucks_models.dart/mmtruck_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/buttons/custom_button.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';
import 'package:provider/provider.dart';

class AddTrucks extends StatefulWidget {
  final VoidCallback? onBack;
  final MmtrucksModel? truckModel;
  final bool isEdit;

  const AddTrucks({
    super.key,
    this.onBack,
    this.truckModel,
    required this.isEdit,
  });

  @override
  State<AddTrucks> createState() => _AddTrucksState();
}

class _AddTrucksState extends State<AddTrucks> {
  TextEditingController plateNumberController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController modelYearController = TextEditingController();
  TextEditingController engineCapacityController = TextEditingController();
  TextEditingController emptyWeightController = TextEditingController();
  TextEditingController maxLoadController = TextEditingController();
  TextEditingController manufactureYearController = TextEditingController();
  TextEditingController passengerCountController = TextEditingController();
  TextEditingController chassisNumberController = TextEditingController();
  GlobalKey<FormState> addTruckKey = GlobalKey<FormState>();
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  bool status = true;
  List<CountryModel> countriesList = [];
  List<CustomerModel> allCustomers = [];
  List<CustomerModel> filteredCustomers = [];
  String? selectedCountry;
  String? selectedCountryId;
  String? selectedOwnById;
  String? selectedOwnerById;
  String? selectedOwnBy;
  String? selectedOwnerBy;
  List<AttachmentModel> attachments = [];
  String selectedEngineType = "";
  String truckColor = "";
  DropDownMenuDataModel engineType = Constants.engineType[0];

  final Map<String, String> ownByOptions = {
    'modern motors': 'Modern Motors',
    'other': 'Other',
  };

  @override
  void initState() {
    _loadDataAndInit();
    super.initState();
  }

  Future<void> _loadDataAndInit() async {
    if (catLoader.value) {
      return;
    }
    catLoader.value = true;

    Future.wait([
      DataFetchService.fetchCountries(),
      DataFetchService.fetchCustomers(),
    ]).then((results) {
      setState(() {
        countriesList = results[0] as List<CountryModel>;
        allCustomers = results[1] as List<CustomerModel>;
        if (widget.isEdit && widget.truckModel != null) {
          final trucks = widget.truckModel!;

          plateNumberController.text = trucks.plateNumber.toString();
          codeController.text = trucks.code?.toString() ?? '';
          selectedEngineType = trucks.vehicleType;
          truckColor = trucks.color ?? '';
          selectedCountry = trucks.country;
          modelYearController.text = trucks.modelYear.toString();
          engineCapacityController.text = trucks.engineCapacity.toString();
          emptyWeightController.text = trucks.emptyWeight.toString();
          maxLoadController.text = trucks.maxLoad.toString();
          manufactureYearController.text = trucks.manufactureYear.toString();
          passengerCountController.text = trucks.passengerCount.toString();
          chassisNumberController.text = trucks.chassisNumber ?? "";
          status = trucks.status == 'active' ? true : false;
          selectedOwnById = trucks.ownBy;
          selectedOwnBy = trucks.ownBy;

          if (countriesList.any((u) => u.country == trucks.country)) {
            selectedCountryId = countriesList
                .firstWhere((country) => country.country == trucks.country)
                .id;
          } else {
            selectedCountryId = null;
          }

          if (widget.truckModel?.ownBy == 'Other') {
            if (allCustomers.any((u) => u.id == trucks.ownById)) {
              selectedOwnerById = allCustomers
                  .firstWhere((customer) => customer.id == trucks.ownById)
                  .id;
            } else {
              selectedOwnerById = null;
            }
          }

          // if (missingData) {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     Constants.showMessage(
          //       context,
          //       'One or more selected category/brand/unit has been deleted. Please update.',
          //     );
          //   });
          // }
        }
        catLoader.value = false;
      });
    });

    // final countries = await DataFetchService.fetchCountries();

    // setState(() {
    //
    //
    // });
  }

  void _submitTruckDetails() async {
    if (loading.value) {
      return;
    }
    loading.value = true;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    try {
      final truckData = MmtrucksModel(
        plateNumber: int.tryParse(plateNumberController.text),
        vehicleType: selectedEngineType,
        code: codeController.text,
        color: truckColor,
        country: selectedCountry,
        passengerCount: int.tryParse(passengerCountController.text) ?? 0,
        modelYear: int.tryParse(modelYearController.text) ?? 0,
        engineCapacity: int.tryParse(engineCapacityController.text) ?? 0,
        emptyWeight: int.tryParse(emptyWeightController.text) ?? 0,
        maxLoad: int.tryParse(maxLoadController.text) ?? 0,
        manufactureYear: int.tryParse(manufactureYearController.text) ?? 0,
        chassisNumber: chassisNumberController.text,
        status: status ? 'active' : 'inactive',
        ownBy: selectedOwnBy!,
        ownById: selectedOwnerById,
        addedBy: user.uid,
      );
      if (widget.isEdit && widget.truckModel?.id != null) {
        await DataUploadService.updateTruck(widget.truckModel!.id!, truckData)
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Truck updated successfully');
              widget.onBack?.call();
            })
            .catchError((error) {
              if (!mounted) return;
              Constants.showMessage(context, 'Failed to update truck: $error');
            });
      } else {
        await DataUploadService.addTruck(truckData)
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Truck added successfully'.tr());
              widget.onBack?.call();
            })
            .catchError((error) {
              if (!mounted) return;
              Constants.showMessage(context, 'Failed to add truck: $error');
            });
      }
    } catch (e) {
      if (mounted) {
        Constants.showMessage(context, 'Something went wrong');
        debugPrint('something went wrong: $e');
      }
    } finally {
      loading.value = false;
    }
  }

  void onFilesPicked(List<AttachmentModel> files) {
    setState(() {
      attachments = files;
    });
  }

  void toggleSwitch(bool value) {
    setState(() {
      status = value;
    });
  }

  Widget _buildDropdownCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  void getValues(String type, String value, String id) {
    if (type == "equipmentType") {
    } else if (type == "engineType") {
      selectedEngineType = value;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: PageHeaderWidget(
            title: 'Add Truck'.tr(),
            buttonText: 'Back to Trucks'.tr(),
            subTitle: 'Add New Truck'.tr(),
            onCreateIcon: 'assets/icons/back.png',
            selectedItems: [],
            buttonWidth: 0.4,
            onCreate: widget.onBack!.call,
            onDelete: () async {},
          ),
        ),
        SliverToBoxAdapter(
          child: OverlayLoader(
            loader: catLoader.value,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor, width: 0.6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 10),
                      child: Text(
                        'Truck Information'.tr(),
                        style: AppTheme.getCurrentTheme(
                          false,
                          connectionStatus,
                        ).textTheme.bodyMedium!.copyWith(fontSize: 16),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Form(
                        key: addTruckKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomMmTextField(
                                    labelText: 'Enter Plate Number'.tr(),
                                    hintText: 'Enter Plate Number'.tr(),
                                    controller: plateNumberController,
                                    keyboardType: TextInputType.number,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.plateNumber,
                                  ),
                                ),
                                10.w,
                                Expanded(
                                  child: CustomMmTextField(
                                    labelText: 'Enter code'.tr(),
                                    hintText: 'Enter code'.tr(),
                                    controller: codeController,
                                    inputFormatter: [
                                      // FilteringTextInputFormatter.digitsOnly
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.codeValidator,
                                  ),
                                ),
                              ],
                            ),
                            16.h,
                            Row(
                              children: [
                                // Expanded(
                                //   child: CustomMmTextField(
                                //     labelText: 'Enter Vehicle Type'.tr(),
                                //     hintText: 'Enter Vehicle Type'.tr(),
                                //     controller: vehicleTypeController,
                                //     autovalidateMode:
                                //         AutovalidateMode.onUserInteraction,
                                //     validator: ValidationUtils.vehicleType,
                                //   ),
                                // ),
                                // Expanded(
                                //   child: _buildDropdownCard(
                                //     title: "Engine Type",
                                //     child: DropDownMenu(
                                //       getValues,
                                //       "Select Engine Type",
                                //       Constants.engineType,
                                //       engineType,
                                //       "engineType",
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                  child: CustomSearchableDropdown(
                                    key: const ValueKey('engine_type'),
                                    hintText: 'Engine Type'.tr(),
                                    value: selectedEngineType,
                                    items: {
                                      for (var u in Constants.engineType)
                                        u.title: u.title,
                                    },
                                    onChanged: (val) => setState(() {
                                      selectedEngineType = val;
                                      selectedEngineType = Constants.engineType
                                          .firstWhere((u) => u.title == val)
                                          .title;
                                      debugPrint(
                                        "${"Engine Type"} : ${selectedEngineType}",
                                      );
                                    }),
                                  ),
                                ),
                                10.w,
                                // Expanded(
                                //   child: CustomMmTextField(
                                //     labelText: 'Enter Color'.tr(),
                                //     hintText: 'Enter Color'.tr(),
                                //     controller: colorController,
                                //     autovalidateMode:
                                //         AutovalidateMode.onUserInteraction,
                                //     validator: ValidationUtils.colorValidator,
                                //   ),
                                // ),
                                Expanded(
                                  child: CustomSearchableDropdown(
                                    key: const ValueKey('Choose_color'),
                                    hintText: 'Select Color'.tr(),
                                    value: selectedEngineType,
                                    items: {
                                      for (var u in Constants.truckColors)
                                        u.title: u.title,
                                    },
                                    onChanged: (val) => setState(() {
                                      selectedEngineType = val;
                                      selectedEngineType = Constants.truckColors
                                          .firstWhere((u) => u.title == val)
                                          .title;
                                      debugPrint(
                                        "${"Engine Type"} : ${selectedEngineType}",
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            16.h,
                            Row(
                              children: [
                                Expanded(
                                  child: CustomSearchableDropdown(
                                    key: const ValueKey('country_dropdown'),
                                    hintText: 'Pick Country'.tr(),
                                    value: selectedCountryId,
                                    items: {
                                      for (var u in countriesList)
                                        u.id!: u.country,
                                    },
                                    onChanged: (val) => setState(() {
                                      selectedCountryId = val;
                                      selectedCountry = countriesList
                                          .firstWhere((u) => u.id == val)
                                          .country;
                                    }),
                                  ),
                                ),
                                10.w,
                                Expanded(
                                  child: CustomMmTextField(
                                    labelText: 'Enter Model Year'.tr(),
                                    hintText: 'Enter Model Year'.tr(),
                                    controller: modelYearController,
                                    keyboardType: TextInputType.number,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.modelYear,
                                  ),
                                ),
                              ],
                            ),
                            16.h,
                            Row(
                              children: [
                                Expanded(
                                  child: CustomMmTextField(
                                    labelText: 'Enter Engine Capacity'.tr(),
                                    hintText: 'Enter Engine Capacity'.tr(),
                                    keyboardType: TextInputType.number,
                                    controller: engineCapacityController,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,2}'),
                                      ),
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.engineCapacity,
                                  ),
                                ),
                                10.w,
                                Expanded(
                                  child: CustomMmTextField(
                                    labelText: 'Enter Empty Weight'.tr(),
                                    hintText: 'Enter Empty Weight'.tr(),
                                    keyboardType: TextInputType.number,
                                    controller: emptyWeightController,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,2}'),
                                      ),
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.emptyWeight,
                                  ),
                                ),
                              ],
                            ),
                            16.h,
                            Row(
                              children: [
                                Expanded(
                                  child: CustomMmTextField(
                                    labelText: 'Enter Max Load'.tr(),
                                    hintText: 'Enter Maximum Load'.tr(),
                                    keyboardType: TextInputType.number,
                                    controller: maxLoadController,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,2}'),
                                      ),
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.maxLoad,
                                  ),
                                ),
                                10.w,
                                Expanded(
                                  child: CustomMmTextField(
                                    labelText: 'Enter Manufacture Year'.tr(),
                                    hintText: 'Enter Manufacture Year'.tr(),
                                    keyboardType: TextInputType.number,
                                    controller: manufactureYearController,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.manufactureYear,
                                  ),
                                ),
                              ],
                            ),
                            16.h,
                            Row(
                              children: [
                                Expanded(
                                  child: CustomMmTextField(
                                    labelText: 'Enter Passenger Count'.tr(),
                                    hintText: 'Enter Passenger Count'.tr(),
                                    keyboardType: TextInputType.number,
                                    controller: passengerCountController,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.passengerCount,
                                  ),
                                ),
                                10.w,
                                Expanded(
                                  child: CustomMmTextField(
                                    labelText: 'Enter Chassis Number'.tr(),
                                    hintText: 'Enter Chassis Number'.tr(),
                                    controller: chassisNumberController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidationUtils.chassisNumber,
                                  ),
                                ),
                              ],
                            ),
                            16.h,
                            CustomSearchableDropdown(
                              key: const ValueKey('own_by_dropdown'),
                              hintText: 'Own By'.tr(),
                              value: selectedOwnById,
                              items: ownByOptions,
                              onChanged: (val) {
                                setState(() {
                                  selectedOwnById = val;
                                  selectedOwnBy = ownByOptions[val];
                                });
                              },
                            ),
                            if (selectedOwnBy == 'Other') ...[
                              16.h,
                              CustomSearchableDropdown(
                                key: const ValueKey('customer_dropdown'),
                                hintText: 'Choose Customer'.tr(),
                                value: selectedOwnerById,
                                items: {
                                  for (var u in allCustomers)
                                    u.id!: u.customerName,
                                },
                                onChanged: (val) => setState(() {
                                  selectedOwnerById = val;
                                  selectedOwnerBy = allCustomers
                                      .firstWhere((u) => u.id == val)
                                      .customerName;
                                }),
                              ),
                            ],
                            16.h,
                            StatusSwitchWidget(
                              isSwitched: status,
                              onChanged: toggleSwitch,
                            ),
                            14.h,
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  PickerWidget(
                                    multipleAllowed: true,
                                    attachments: attachments,
                                    galleryAllowed: true,
                                    onFilesPicked: onFilesPicked,
                                    memoAllowed: false,
                                    //ft: FileType.image,
                                    filesAllowed: false,
                                    // captionAllowed: false,
                                    videoAllowed: false,
                                    cameraAllowed: true,
                                    child: Container(
                                      height: context.height * 0.2,
                                      width: context.width * 0.1,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppTheme.borderColor,
                                        ),
                                      ),
                                      child: attachments.isNotEmpty
                                          ? kIsWeb
                                                ? Image.memory(
                                                    attachments.last.bytes!,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.file(
                                                    File(attachments.last.url),
                                                    fit: BoxFit.cover,
                                                  )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .add_circle_outline_rounded,
                                                ),
                                                Text('Add Image'.tr()),
                                              ],
                                            ),
                                    ),
                                  ),
                                  12.w,
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: context.height * 0.06,
                                            width: context.height * 0.22,
                                            child: CustomButton(
                                              text: 'Upload Image'.tr(),
                                              onPressed: () {},
                                              fontSize: 14,
                                              buttonType: ButtonType.Filled,
                                              backgroundColor:
                                                  AppTheme.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      8.h,
                                      Text(
                                        'JPEG, PNG up to 2 MB'.tr(),
                                        style:
                                            AppTheme.getCurrentTheme(
                                              false,
                                              connectionStatus,
                                            ).textTheme.bodyMedium!.copyWith(
                                              fontSize: 12,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            AlertDialogBottomWidget(
                              title: widget.isEdit
                                  ? 'Update Truck'.tr()
                                  : 'Add Truck'.tr(),
                              onCreate: () {
                                if (addTruckKey.currentState!.validate()) {
                                  _submitTruckDetails();
                                }
                              },
                              onCancel: widget.onBack!.call,
                              loadingNotifier: loading,
                            ),
                            22.h,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
