import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/firebase_services/data_upload_service.dart';
import 'package:modern_motors_panel/model/admin_model/country_model.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/model/customer_models/customer_models.dart';
import 'package:modern_motors_panel/model/trucks/mm_trucks_models.dart/heavy_equipment_model.dart';
import 'package:modern_motors_panel/model/trucks/mm_trucks_models.dart/mmtruck_model.dart';
import 'package:modern_motors_panel/modern_motors/services/data_fetch_service.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/drop_downs/custom_searchable_drop_down.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';
import 'package:modern_motors_panel/widgets/picker/picker_widget.dart';

class InventoryTrucks extends StatefulWidget {
  final VoidCallback? onBack;
  final MmtrucksModel? truckModel;
  final bool isEdit;

  const InventoryTrucks({
    super.key,
    this.onBack,
    this.truckModel,
    required this.isEdit,
    MmtrucksModel? MmtrucksModel,
  });

  @override
  State<InventoryTrucks> createState() => _InventoryTrucksState();
}

class _InventoryTrucksState extends State<InventoryTrucks>
    with TickerProviderStateMixin {
  // Existing controllers
  TextEditingController plateNumberController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController modelYearController = TextEditingController();
  TextEditingController engineCapacityController = TextEditingController();
  TextEditingController emptyWeightController = TextEditingController();
  TextEditingController maxLoadController = TextEditingController();
  TextEditingController manufactureYearController = TextEditingController();
  TextEditingController passengerCountController = TextEditingController();
  TextEditingController chassisNumberController = TextEditingController();

  // New controllers for enhanced fields
  TextEditingController vinNumberController = TextEditingController();
  TextEditingController engineNumberController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController modelNameController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController mileageController = TextEditingController();

  GlobalKey<FormState> addTruckKey = GlobalKey<FormState>();
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  bool status = true;
  bool isLoading = false;
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Data lists
  List<CountryModel> countriesList = [];
  List<CustomerModel> allCustomers = [];
  List<HeavyEquipmentTypeModel> allEquipment = [];
  List<HeavyEquipmentTypeModel> displayedEquipment = [];

  // Selection variables
  String? selectedCountry;
  String? selectedCountryId;
  String? selectedOwnById;
  String? selectedOwnerBy;
  String? selectedOwnBy;
  String? selectedColorId;
  String? selectedFuelType;
  String? selectedTransmission;
  String? selectedCondition;
  String? selectedTruckCategory;

  List<AttachmentModel> attachments = [];

  // Enhanced dropdown options
  final Map<String, String> ownByOptions = {
    'modern motors': 'Modern Motors',
    'other': 'Other',
  };

  final Map<String, Color> truckColors = {
    'white': Colors.white,
    'black': Colors.black,
    'silver': Colors.grey.shade300,
    'red': Colors.red,
    'blue': Colors.blue,
    'green': Colors.green,
    'yellow': Colors.yellow,
    'orange': Colors.orange,
    'brown': Colors.brown,
    'grey': Colors.grey,
  };

  final Map<String, String> fuelTypes = {
    'diesel': 'Diesel',
    'petrol': 'Petrol/Gasoline',
    'electric': 'Electric',
    'hybrid': 'Hybrid',
    'cng': 'CNG',
    'lpg': 'LPG',
  };

  final Map<String, String> transmissionTypes = {
    'manual': 'Manual',
    'automatic': 'Automatic',
    'semi_automatic': 'Semi-Automatic',
    'cvt': 'CVT',
  };

  final Map<String, String> conditionTypes = {
    'new': 'Brand New',
    'used_excellent': 'Used - Excellent',
    'used_good': 'Used - Good',
    'used_fair': 'Used - Fair',
    'refurbished': 'Refurbished',
  };

  Map<String, String> truckCategories = {
    // 'light_truck': 'Light Truck (< 3.5T)',
    // 'medium_truck': 'Medium Truck (3.5T - 12T)',
    // 'heavy_truck': 'Heavy Truck (> 12T)',
    // 'trailer': 'Trailer',
    // 'semi_trailer': 'Semi-Trailer',
    // 'pickup': 'Pickup Truck',
    // 'van': 'Commercial Van',
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadDataAndInit();
  }

  Map<String, String> convertEquipmentToTruckCategories(
    List<HeavyEquipmentTypeModel> allEquipment,
  ) {
    final Map<String, String> truckCategories = {};

    for (var equipment in allEquipment) {
      // Use the equipment ID as the key and name as the value
      if (equipment.id != null && equipment.id!.isNotEmpty) {
        truckCategories[equipment.id!] = equipment.name;
      }
    }

    return truckCategories;
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _loadDataAndInit() async {
    if (catLoader.value) return;
    catLoader.value = true;

    try {
      final results = await Future.wait([
        DataFetchService.fetchCountries(),
        DataFetchService.fetchCustomers(),
      ]);

      setState(() {
        countriesList = results[0] as List<CountryModel>;
        allCustomers = results[1] as List<CustomerModel>;

        if (widget.isEdit && widget.truckModel != null) {
          _populateEditData();
        }
      });
      _loadEquipment();
    } catch (e) {
      if (mounted) {
        Constants.showMessage(context, 'Failed to load data: $e');
      }
    } finally {
      catLoader.value = false;
    }
  }

  Future<void> _loadEquipment() async {
    setState(() => isLoading = true);

    final snapshot = await FirebaseFirestore.instance
        .collection('heavyEquipmentType')
        .orderBy('timestamp', descending: true)
        .get();

    final equipmentList = snapshot.docs
        .map((doc) => HeavyEquipmentTypeModel.fromDoc(doc))
        .toList();

    setState(() {
      allEquipment = equipmentList;
      displayedEquipment = equipmentList;
      isLoading = false;
      truckCategories = convertEquipmentToTruckCategories(allEquipment);
    });
  }

  void _populateEditData() {
    final truck = widget.truckModel!;

    // Populate existing fields
    plateNumberController.text = truck.plateNumber?.toString() ?? '';
    codeController.text = truck.code?.toString() ?? '';
    vehicleTypeController.text = truck.vehicleType ?? '';
    colorController.text = truck.color ?? '';
    selectedCountry = truck.country;
    modelYearController.text = truck.modelYear?.toString() ?? '';
    engineCapacityController.text = truck.engineCapacity?.toString() ?? '';
    emptyWeightController.text = truck.emptyWeight?.toString() ?? '';
    maxLoadController.text = truck.maxLoad?.toString() ?? '';
    manufactureYearController.text = truck.manufactureYear?.toString() ?? '';
    passengerCountController.text = truck.passengerCount?.toString() ?? '';
    chassisNumberController.text = truck.chassisNumber ?? '';
    status = truck.status == 'active';
    selectedOwnById = truck.ownBy?.toLowerCase();
    selectedOwnBy = truck.ownBy;

    // Set country ID
    if (countriesList.any((u) => u.country == truck.country)) {
      selectedCountryId = countriesList
          .firstWhere((country) => country.country == truck.country)
          .id;
    }

    // Set owner ID for "Other" ownership
    if (truck.ownBy == 'Other' &&
        allCustomers.any((u) => u.id == truck.ownById)) {
      selectedOwnerBy = truck.ownById;
    }

    // Set color selection
    selectedColorId = truckColors.keys.firstWhere(
      (key) => key == truck.color?.toLowerCase(),
      orElse: () => 'white',
    );
  }

  void _submitTruckDetails() async {
    if (loading.value) return;

    HapticFeedback.lightImpact();
    loading.value = true;

    try {
      List<String> urls = await Future.wait(
        attachments.map((attachment) async {
          return await Constants.uploadAttachment(attachment);
        }),
      );
      final truckData = MmtrucksModel(
        plateNumber: int.tryParse(plateNumberController.text),
        imageUrls: urls,
        vehicleType: vehicleTypeController.text,
        code: codeController.text,
        color: selectedColorId ?? 'white',
        country: selectedCountry,
        passengerCount: int.tryParse(passengerCountController.text) ?? 0,
        modelYear: int.tryParse(modelYearController.text) ?? 0,
        engineCapacity: int.tryParse(engineCapacityController.text) ?? 0,
        emptyWeight: int.tryParse(emptyWeightController.text) ?? 0,
        maxLoad: int.tryParse(maxLoadController.text) ?? 0,
        manufactureYear: int.tryParse(manufactureYearController.text) ?? 0,
        chassisNumber: chassisNumberController.text,
        status: status ? 'active' : 'inactive',
        ownBy: "Modern Motors",
        ownById: "Modern Motors",
        // Add new fields to your TruckModel class
        vinNumber: vinNumberController.text,
        engineNumber: engineNumberController.text,
        transmission: selectedTransmission,
        fuelType: selectedFuelType,
        brand: brandController.text,
        modelName: modelNameController.text,
        purchasePrice: double.tryParse(purchasePriceController.text),
        sellingPrice: double.tryParse(sellingPriceController.text),
        supplier: supplierController.text,
        notes: notesController.text,
        mileage: int.tryParse(mileageController.text),
        condition: selectedCondition,
        category: selectedTruckCategory,
      );

      if (widget.isEdit && widget.truckModel?.id != null) {
        await DataUploadService.updateTruck(widget.truckModel!.id!, truckData);
        if (!mounted) return;
        _showSuccessMessage('Truck updated successfully! 🚛');
      } else {
        await DataUploadService.addTruck(truckData);
        if (!mounted) return;
        _showSuccessMessage('Truck added to inventory successfully! ✨');
      }

      widget.onBack?.call();
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Failed to save truck: $e');
      }
    } finally {
      loading.value = false;
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void onFilesPicked(List<AttachmentModel> files) {
    setState(() {
      attachments = files;
    });
    HapticFeedback.selectionClick();
  }

  void toggleSwitch(bool value) {
    HapticFeedback.selectionClick();
    setState(() {
      status = value;
    });
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          SizedBox(width: 12),
          Text(
            title.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
          Expanded(child: Divider(indent: 16, color: Colors.grey.shade300)),
        ],
      ),
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Color'.tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: truckColors.length,
            itemBuilder: (context, index) {
              final colorKey = truckColors.keys.elementAt(index);
              final color = truckColors[colorKey]!;
              final isSelected = selectedColorId == colorKey;

              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    selectedColorId = colorKey;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: 12),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Colors.grey.shade300,
                      width: isSelected ? 3 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: color == Colors.white || color == Colors.yellow
                              ? Colors.black
                              : Colors.white,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
        if (selectedColorId != null) ...[
          SizedBox(height: 4),
          Text(
            selectedColorId!.capitalize(),
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMultipleImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.photo_library, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text(
              'Vehicle Images'.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
            Spacer(),
            Text(
              '${attachments.length}/10',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Add multiple high-quality images of the vehicle'.tr(),
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: attachments.length + 1,
            itemBuilder: (context, index) {
              if (index == attachments.length) {
                // Add new image button
                return PickerWidget(
                  multipleAllowed: true,
                  attachments: attachments,
                  galleryAllowed: true,
                  onFilesPicked: onFilesPicked,
                  memoAllowed: false,
                  // ft: FileType.image,
                  filesAllowed: false,
                  // captionAllowed: false,
                  videoAllowed: false,
                  cameraAllowed: true,
                  child: Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Add Photo'.tr(),
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Display existing images
              final attachment = attachments[index];
              return Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.memory(
                              attachment.bytes!,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            )
                          : Image.file(
                              File(attachment.url),
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            attachments.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8),
        Text(
          'JPEG, PNG up to 2 MB each. Max 10 images.'.tr(),
          style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    // Dispose all controllers
    plateNumberController.dispose();
    codeController.dispose();
    vehicleTypeController.dispose();
    colorController.dispose();
    modelYearController.dispose();
    engineCapacityController.dispose();
    emptyWeightController.dispose();
    maxLoadController.dispose();
    manufactureYearController.dispose();
    passengerCountController.dispose();
    chassisNumberController.dispose();
    vinNumberController.dispose();
    engineNumberController.dispose();
    brandController.dispose();
    modelNameController.dispose();
    purchasePriceController.dispose();
    sellingPriceController.dispose();
    supplierController.dispose();
    notesController.dispose();
    mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: PageHeaderWidget(
                  title: (widget.isEdit ? 'Edit Truck' : 'Add New Truck').tr(),
                  buttonText: 'Back to Inventory'.tr(),
                  subTitle:
                      (widget.isEdit
                              ? 'Update truck information'
                              : 'Add new truck to inventory')
                          .tr(),
                  onCreateIcon: 'assets/images/back.png',
                  selectedItems: [],
                  buttonWidth: 0.4,
                  onCreate: widget.onBack ?? () {},
                  onDelete: () async {},
                ),
              ),
              SliverToBoxAdapter(
                child: OverlayLoader(
                  loader: catLoader.value,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.whiteColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: addTruckKey,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Basic Information Section
                              _buildSectionHeader(
                                'Basic Information',
                                Icons.info_outline,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Plate Number'.tr(),
                                      hintText: 'Enter plate number'.tr(),
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
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Internal Code'.tr(),
                                      hintText: 'Enter internal code'.tr(),
                                      controller: codeController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: ValidationUtils.codeValidator,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Brand/Make'.tr(),
                                      hintText: 'e.g., Dongfeng, FAW, Sinotruk'
                                          .tr(),
                                      controller: brandController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (v) => v?.isEmpty == true
                                          ? 'Brand is required'
                                          : null,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Model Name'.tr(),
                                      hintText: 'Enter model name'.tr(),
                                      controller: modelNameController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (v) => v?.isEmpty == true
                                          ? 'Model is required'
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      hintText: 'Select Category'.tr(),
                                      value: selectedTruckCategory,
                                      items: truckCategories,
                                      onChanged: (val) => setState(
                                        () => selectedTruckCategory = val,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      hintText: 'Vehicle Condition'.tr(),
                                      value: selectedCondition,
                                      items: conditionTypes,
                                      onChanged: (val) => setState(
                                        () => selectedCondition = val,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              _buildColorSelector(),

                              // Technical Specifications Section
                              _buildSectionHeader(
                                'Technical Specifications',
                                Icons.engineering,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Engine Capacity (L)'.tr(),
                                      hintText: 'e.g., 6.7'.tr(),
                                      controller: engineCapacityController,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
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
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      hintText: 'Fuel Type'.tr(),
                                      value: selectedFuelType,
                                      items: fuelTypes,
                                      onChanged: (val) => setState(
                                        () => selectedFuelType = val,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      hintText: 'Transmission'.tr(),
                                      value: selectedTransmission,
                                      items: transmissionTypes,
                                      onChanged: (val) => setState(
                                        () => selectedTransmission = val,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Mileage (km)'.tr(),
                                      hintText: 'Enter current mileage'.tr(),
                                      controller: mileageController,
                                      keyboardType: TextInputType.number,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Empty Weight (kg)'.tr(),
                                      hintText: 'Vehicle empty weight'.tr(),
                                      controller: emptyWeightController,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
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
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Max Load (kg)'.tr(),
                                      hintText: 'Maximum payload'.tr(),
                                      controller: maxLoadController,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
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
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Manufacture Year'.tr(),
                                      hintText: 'e.g., 2023'.tr(),
                                      controller: manufactureYearController,
                                      keyboardType: TextInputType.number,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator:
                                          ValidationUtils.manufactureYear,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Model Year'.tr(),
                                      hintText: 'e.g., 2023'.tr(),
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
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Passenger Count'.tr(),
                                      hintText: 'Number of seats'.tr(),
                                      controller: passengerCountController,
                                      keyboardType: TextInputType.number,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: ValidationUtils.passengerCount,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: CustomSearchableDropdown(
                                      hintText: 'Origin Country'.tr(),
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
                                ],
                              ),

                              // Identification Numbers Section
                              _buildSectionHeader(
                                'Identification Numbers',
                                Icons.fingerprint,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Chassis Number'.tr(),
                                      hintText: 'Enter chassis number'.tr(),
                                      controller: chassisNumberController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: ValidationUtils.chassisNumber,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'VIN Number'.tr(),
                                      hintText: 'Vehicle Identification Number'
                                          .tr(),
                                      controller: vinNumberController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (v) =>
                                          v?.length != null &&
                                              v!.isNotEmpty &&
                                              v.length < 17
                                          ? 'VIN must be 17 characters'
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              CustomMmTextField(
                                labelText: 'Engine Number'.tr(),
                                hintText: 'Engine serial number'.tr(),
                                controller: engineNumberController,
                              ),

                              // Financial Information Section
                              _buildSectionHeader(
                                'Financial Information',
                                Icons.attach_money,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Purchase Price (OMR)'.tr(),
                                      hintText: 'Cost price'.tr(),
                                      controller: purchasePriceController,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      inputFormatter: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d{0,3}'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: CustomMmTextField(
                                      labelText: 'Selling Price (OMR)'.tr(),
                                      hintText: 'Expected selling price'.tr(),
                                      controller: sellingPriceController,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      inputFormatter: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d{0,3}'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              CustomMmTextField(
                                labelText: 'Supplier/Importer'.tr(),
                                hintText: 'Source company or dealer'.tr(),
                                controller: supplierController,
                              ),

                              // Ownership Section
                              _buildSectionHeader(
                                'Ownership Information',
                                Icons.person,
                              ),
                              CustomSearchableDropdown(
                                hintText: 'Owned By'.tr(),
                                value: selectedOwnById,
                                items: ownByOptions,
                                onChanged: (val) {
                                  setState(() {
                                    selectedOwnById = val;
                                    selectedOwnBy = ownByOptions[val];
                                    if (val != 'other') {
                                      selectedOwnerBy = null;
                                    }
                                  });
                                },
                              ),
                              if (selectedOwnBy == 'Other') ...[
                                SizedBox(height: 16),
                                CustomSearchableDropdown(
                                  hintText: 'Select Customer'.tr(),
                                  value: selectedOwnerBy,
                                  items: {
                                    for (var u in allCustomers)
                                      u.id!: u.customerName,
                                  },
                                  onChanged: (val) => setState(() {
                                    selectedOwnerBy = val;
                                  }),
                                ),
                              ],

                              // Status Section
                              _buildSectionHeader(
                                'Status & Notes',
                                Icons.note_alt,
                              ),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: status
                                      ? Colors.green.withOpacity(0.05)
                                      : Colors.orange.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: status
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.orange.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: status
                                            ? Colors.green
                                            : Colors.orange,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        status ? Icons.check : Icons.pause,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Inventory Status'.tr(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: status
                                                  ? Colors.green.shade700
                                                  : Colors.orange.shade700,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            status
                                                ? 'Active - Available for sale'
                                                : 'Inactive - Not available for sale',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    StatusSwitchWidget(
                                      isSwitched: status,
                                      onChanged: toggleSwitch,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              CustomMmTextField(
                                labelText: 'Additional Notes'.tr(),
                                hintText:
                                    'Any special notes or remarks about this vehicle...'
                                        .tr(),
                                controller: notesController,
                                maxLines: 3,
                              ),

                              // Images Section
                              _buildSectionHeader(
                                'Vehicle Images',
                                Icons.photo_camera,
                              ),
                              _buildMultipleImageUpload(),

                              // Action Buttons
                              SizedBox(height: 32),
                              AlertDialogBottomWidget(
                                title: widget.isEdit
                                    ? 'Update Truck'.tr()
                                    : 'Add to Inventory'.tr(),
                                onCreate: () {
                                  if (addTruckKey.currentState!.validate()) {
                                    if (selectedColorId == null) {
                                      _showErrorMessage(
                                        'Please select a vehicle color',
                                      );
                                      return;
                                    }
                                    if (selectedOwnBy == null) {
                                      _showErrorMessage(
                                        'Please select ownership type',
                                      );
                                      return;
                                    }
                                    if (selectedOwnBy == 'Other' &&
                                        selectedOwnerBy == null) {
                                      _showErrorMessage(
                                        'Please select a customer',
                                      );
                                      return;
                                    }
                                    _submitTruckDetails();
                                  } else {
                                    _showErrorMessage(
                                      'Please fix all validation errors',
                                    );
                                  }
                                },
                                onCancel: widget.onBack ?? () {},
                                loadingNotifier: loading,
                              ),
                              SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension for string capitalization
extension StringCapitalization on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
