import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/hr_models/nationality_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_header.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/snackbar_utils.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';

class NationalityFormWidget extends StatefulWidget {
  final VoidCallback? onBack;
  final NationalityModel? nationalityModel;
  final bool isEdit;

  const NationalityFormWidget({
    super.key,
    this.onBack,
    this.nationalityModel,
    required this.isEdit,
  });

  @override
  State<NationalityFormWidget> createState() => _NationalityFormWidgetState();
}

class _NationalityFormWidgetState extends State<NationalityFormWidget> {
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController nationalityArabicController =
      TextEditingController();

  GlobalKey<FormState> addCurrencyKey = GlobalKey<FormState>();
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> catLoader = ValueNotifier(false);
  bool status = true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    if (catLoader.value) {
      return;
    }

    catLoader.value = true;
    setState(() {
      if (widget.isEdit && widget.nationalityModel != null) {
        final category = widget.nationalityModel!;
        nationalityController.text = category.nationality;
        nationalityArabicController.text = category.nationalityArabic;
        status = category.status == 'active';
      }
    });
    catLoader.value = false;
  }

  void _submitCategory() async {
    if (loading.value) {
      return;
    }
    loading.value = true;
    try {
      final nationality = NationalityModel(
        nationality: nationalityController.text,
        nationalityArabic: nationalityArabicController.text,
        status: status ? 'active' : 'inactive',
        timestamp: Timestamp.now(),
      );

      if (widget.isEdit && widget.nationalityModel?.id != null) {
        await FirebaseFirestore.instance
            .collection('nationality')
            .doc(widget.nationalityModel!.id)
            .update(nationality.toMap())
            .then((_) {
              if (!mounted) return;
              SnackbarUtils.showSnackbar(
                context,
                'Nationality updated successfully',
              );
              widget.onBack?.call();
              Navigator.of(context).pop();
            });
      } else {
        await FirebaseFirestore.instance
            .collection('nationality')
            .add(nationality.toMap())
            .then((value) {
              if (!mounted) return;
              SnackbarUtils.showSnackbar(
                context,
                'Nationality added successfully',
              );
              widget.onBack?.call();
              Navigator.of(context).pop();
            });
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showSnackbar(context, 'Something went wrong');
      }
    } finally {
      loading.value = false;
    }
  }

  void toggleSwitch(bool value) {
    setState(() {
      status = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlayLoader(
      loader: catLoader.value,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.whiteColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, minWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              16.h,
              AlertDialogHeader(
                title: widget.isEdit ? 'Update Nationality' : 'New Nationality',
              ),
              22.h,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: addCurrencyKey,
                  child: Column(
                    children: [
                      8.h,
                      CustomMmTextField(
                        labelText: 'Enter Nationality',
                        hintText: 'Enter Nationality',
                        controller: nationalityController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: ValidationUtils.validateNationality,
                      ),
                      8.h,
                      CustomMmTextField(
                        labelText: 'Enter Arabic Nationality',
                        hintText: 'Enter Arabic Nationality',
                        controller: nationalityArabicController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: ValidationUtils.validateNationalityArabic,
                      ),
                    ],
                  ),
                ),
              ),
              16.h,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StatusSwitchWidget(
                  isSwitched: status,
                  onChanged: toggleSwitch,
                ),
              ),
              22.h,
              AlertDialogBottomWidget(
                buttonWidget: 0.26,
                title: widget.isEdit ? 'Update Nationality' : 'New Nationality',
                onCreate: () {
                  if (addCurrencyKey.currentState!.validate()) {
                    _submitCategory();
                  }
                },
                loadingNotifier: loading,
              ),
              22.h,
            ],
          ),
        ),
      ),
    );
  }
}
