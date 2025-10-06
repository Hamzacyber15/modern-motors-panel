import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/admin_model/currency_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_header.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';

class CurrencyFormWidget extends StatefulWidget {
  final VoidCallback? onBack;
  final CurrencyModel? currencyModel;
  final bool isEdit;

  const CurrencyFormWidget({
    super.key,
    this.onBack,
    this.currencyModel,
    required this.isEdit,
  });

  @override
  State<CurrencyFormWidget> createState() => _CurrencyFormWidgetState();
}

class _CurrencyFormWidgetState extends State<CurrencyFormWidget> {
  final TextEditingController currencyController = TextEditingController();
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
      if (widget.isEdit && widget.currencyModel != null) {
        final category = widget.currencyModel!;
        currencyController.text = category.currency;
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
      final currency = CurrencyModel(
        currency: currencyController.text,
        status: status ? 'active' : 'inactive',
      );

      if (widget.isEdit && widget.currencyModel?.id != null) {
        await FirebaseFirestore.instance
            .collection('currency')
            .doc(widget.currencyModel!.id)
            .update(currency.toMapForUpdate())
            .then((_) {
              if (!mounted) return;
              Constants.showMessage(context, 'Currency updated successfully');
              widget.onBack?.call();
              Navigator.of(context).pop();
            });
      } else {
        await FirebaseFirestore.instance
            .collection('currency')
            .add(currency.toMapForAdd())
            .then((value) {
              if (!mounted) return;
              Constants.showMessage(context, 'Currency added successfully');
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
                title: widget.isEdit ? 'Update Currency' : 'New Currency',
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
                        labelText: 'Enter currency',
                        hintText: 'Enter currency',
                        controller: currencyController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: ValidationUtils.validateCurrencyCode,
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
                title: widget.isEdit ? 'Update Currency' : 'New Currency',
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
