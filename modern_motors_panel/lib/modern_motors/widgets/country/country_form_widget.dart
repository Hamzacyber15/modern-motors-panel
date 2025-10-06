import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/country_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_header.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';

class CountryFormWidget extends StatefulWidget {
  final VoidCallback? onBack;
  final CountryModel? countryModel;
  final bool isEdit;

  const CountryFormWidget({
    super.key,
    this.onBack,
    this.countryModel,
    required this.isEdit,
  });

  @override
  State<CountryFormWidget> createState() => _CountryFormWidgetState();
}

class _CountryFormWidgetState extends State<CountryFormWidget> {
  final TextEditingController countryController = TextEditingController();
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
      if (widget.isEdit && widget.countryModel != null) {
        final category = widget.countryModel!;
        countryController.text = category.country;
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
      final country = CountryModel(
        country: countryController.text,
        status: status ? 'active' : 'inactive',
      );

      if (widget.isEdit && widget.countryModel?.id != null) {
        await FirebaseFirestore.instance
            .collection('country')
            .doc(widget.countryModel!.id)
            .update(country.toMapForUpdate())
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Country updated successfully');
              widget.onBack?.call();
              Navigator.of(context).pop();
            });
      } else {
        await FirebaseFirestore.instance
            .collection('country')
            .add(country.toMapForAdd())
            .then((value) {
              if (!mounted) return;
              Constants.showMessage(context, 'Country added successfully');
              widget.onBack?.call();
              Navigator.of(context).pop();
            });
      }
    } catch (e) {
      if (mounted) {
        Constants.showMessage(context, 'Something went wrong');
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
                title: widget.isEdit ? 'Update Country' : 'New Country',
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
                        labelText: 'Enter country',
                        hintText: 'Enter country',
                        controller: countryController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: ValidationUtils.validateCountry,
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
                title: widget.isEdit ? 'Update Country' : 'New Country',
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
