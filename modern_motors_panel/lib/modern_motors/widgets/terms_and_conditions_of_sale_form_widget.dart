import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/terms/terms_of_sale_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dialogue_box/alert_dialogue_box_bottom_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/dynamic_data_table_buttons.dart';
import 'package:modern_motors_panel/modern_motors/widgets/form_validation.dart';
import 'package:modern_motors_panel/modern_motors/widgets/page_header_widget.dart';
import 'package:modern_motors_panel/modern_motors/widgets/status_switch_button.dart';
import 'package:modern_motors_panel/widgets/overlay_loader.dart';

class TermConditionsForSaleFormWidget extends StatefulWidget {
  final VoidCallback? onBack;
  final String? docId;
  final TermsAndConditionsOfSalesModel? termsModel;
  final List<TermsAndConditionsOfSalesModel> termsList;
  final bool isEdit;

  const TermConditionsForSaleFormWidget({
    super.key,
    this.onBack,
    this.termsModel,
    this.docId,
    required this.termsList,
    required this.isEdit,
  });

  @override
  State<TermConditionsForSaleFormWidget> createState() =>
      _TermConditionsForSaleFormWidgetState();
}

class _TermConditionsForSaleFormWidgetState
    extends State<TermConditionsForSaleFormWidget> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController indexController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> addTermsKey = GlobalKey<FormState>();
  ValueNotifier<bool> loading = ValueNotifier(false);
  bool status = true;
  final List<TermsAndConditionsOfSalesModel> addTermsInList = [];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.termsModel != null) {
      final terms = widget.termsModel!;
      addTermsInList.addAll(widget.termsList);
      titleController.text = terms.title;
      descriptionController.text = terms.description;
      indexController.text = terms.index.toString();
      status = terms.status == 'active' ? true : false;
      debugPrint('stats 1 ${addTermsInList.length}');
      addTermsInList.remove(widget.termsModel);
      debugPrint('stats 1 ${addTermsInList.length}');
    } else {
      addTermsInList.addAll(widget.termsList);
    }
  }

  void _submitTermAndConditionsTermAndConditions() async {
    if (loading.value) {
      return;
    }
    if (addTermsInList.isNotEmpty &&
        addTermsInList.any(
          (val) => val.index == int.tryParse(indexController.text),
        )) {
      Constants.showMessage(context, 'Index already exists');
    } else {
      loading.value = true;
      try {
        if (widget.isEdit) {
          addTerms();
        }
        final terms = TermsOfSalesModel(terms: addTermsInList);

        if (widget.isEdit || widget.docId != null) {
          await FirebaseFirestore.instance
              .collection('termsAndConditionsOfSale')
              .doc(widget.docId)
              .update(terms.toMap())
              .then((_) {
                if (!mounted) return;
                Constants.showMessage(context, 'Term updated successfully');
                widget.onBack?.call();
              })
              .catchError((error) {
                if (!mounted) return;
                debugPrint('Failed to update terms: $error');
                Constants.showMessage(
                  context,
                  'Failed to update terms: $error',
                );
              });
        } else {
          await FirebaseFirestore.instance
              .collection('termsAndConditionsOfSale')
              .add({
                ...terms.toMap(),
                'createdAt': FieldValue.serverTimestamp(),
              })
              .then((_) {
                if (!mounted) return;
                Constants.showMessage(context, 'Terms added successfully');
                widget.onBack?.call();
              })
              .catchError((error) {
                if (!mounted) return;
                Constants.showMessage(context, 'Failed to add term: $error');
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
  }

  void addTerms() {
    final value = TermsAndConditionsOfSalesModel(
      title: titleController.text.trim(),
      status: status ? 'active' : 'inactive',
      description: descriptionController.text.trim(),
      index: int.tryParse(indexController.text)!,
    );
    debugPrint('stats 2 ${value.status}');
    if (addTermsInList.any((element) => element.index == value.index)) {
      Constants.showMessage(context, 'Index already exists in the list');
      return;
    }
    addTermsInList.add(value);
    titleController.clear();
    descriptionController.clear();
    indexController.clear();
    // addTermsKey.currentState!.reset();
    // FocusScope.of(context).unfocus();
    setState(() {});
  }

  void toggleSwitch(bool value) {
    setState(() {
      status = value;
      debugPrint('status $status');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: PageHeaderWidget(
            title: widget.isEdit ? 'Update Terms' : 'New Terms',
            buttonText: 'Back to Terms'.tr(),
            subTitle: 'Create New Terms'.tr(),
            importButtonText: 'Import Terms'.tr(),
            onCreateIcon: 'assets/icons/back.png',
            selectedItems: [],
            buttonWidth: 0.4,
            onCreate: widget.onBack!.call,
            onDelete: () async {},
          ),
        ),
        SliverToBoxAdapter(
          child: OverlayLoader(
            loader: false,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor, width: 0.6),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                    minWidth: 500,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      16.h,

                      // AlertDialogHeader(
                      //   title: widget.isEdit ? 'Update Terms' : 'New Terms',
                      // ),
                      // Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Form(
                          key: addTermsKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomMmTextField(
                                      labelText: 'Enter Index',
                                      hintText: 'Enter Index',
                                      controller: indexController,
                                      keyboardType: TextInputType.number,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: ValidationUtils.validateIndex,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    flex: 2,
                                    child: CustomMmTextField(
                                      labelText: 'Enter Title',
                                      hintText: 'Enter Title',
                                      controller: titleController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator:
                                          ValidationUtils.validateTermsTitle,
                                    ),
                                  ),
                                ],
                              ),
                              10.h,
                              CustomMmTextField(
                                labelText: 'Enter Description',
                                hintText: 'Enter Description',
                                controller: descriptionController,
                                maxLines: 3,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator:
                                    ValidationUtils.validateTermsDescription,
                              ),
                            ],
                          ),
                        ),
                      ),
                      16.h,
                      if (!widget.isEdit)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: AddTerms(
                            onAdd: () {
                              if (addTermsKey.currentState!.validate()) {
                                addTerms();
                              }
                            },
                          ),
                        ),
                      if (widget.isEdit) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: StatusSwitchWidget(
                            isSwitched: status,
                            onChanged: toggleSwitch,
                          ),
                        ),
                      ],
                      12.h,
                      if (addTermsInList.isNotEmpty && !widget.isEdit) ...[
                        Text(
                          'Terms to be added: ',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          itemCount: addTermsInList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 5.1,
                              ),
                          itemBuilder: (context, index) {
                            final m = addTermsInList[index];
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${m.index}. ${m.title}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Expanded(
                                          child: Text(
                                            m.description,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                            maxLines: 4,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      buildActionButton(
                                        icon: Icons.edit,
                                        color: const Color(0xFF280CDE),
                                        onTap: () {
                                          final term = addTermsInList[index];
                                          indexController.text = term.index
                                              .toString();
                                          titleController.text = term.title;
                                          descriptionController.text =
                                              term.description;
                                          setState(() {
                                            addTermsInList.removeAt(index);
                                          });
                                        },
                                        tooltip: 'Edit',
                                      ),
                                      const SizedBox(height: 4),
                                      buildActionButton(
                                        icon: Icons.delete_outline,
                                        color: const Color(0xFFDE0C21),
                                        onTap: () => setState(
                                          () => addTermsInList.removeAt(index),
                                        ),
                                        tooltip: 'Remove',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                      22.h,
                      AlertDialogBottomWidget(
                        title: widget.isEdit ? 'Update' : 'New',
                        onCreate: () {
                          if (addTermsInList.isNotEmpty && !widget.isEdit) {
                            _submitTermAndConditionsTermAndConditions();
                          } else if (widget.isEdit) {
                            _submitTermAndConditionsTermAndConditions();
                          } else {
                            Constants.showMessage(
                              context,
                              'Please Add The Terms',
                            );
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
            ),
          ),
        ),
      ],
    );
  }
}
