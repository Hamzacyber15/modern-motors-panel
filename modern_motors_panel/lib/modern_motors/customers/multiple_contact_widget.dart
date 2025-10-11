import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/extensions.dart';
import 'package:modern_motors_panel/model/contact_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:provider/provider.dart';

class MultipleContactsWidget extends StatefulWidget {
  final List<ContactModel> contacts;
  final ValueChanged<List<ContactModel>> onChanged;

  const MultipleContactsWidget({
    super.key,
    required this.contacts,
    required this.onChanged,
  });

  @override
  State<MultipleContactsWidget> createState() => _MultipleContactsWidgetState();
}

class _MultipleContactsWidgetState extends State<MultipleContactsWidget> {
  void _addContact() {
    setState(() {
      widget.contacts.add(ContactModel());
    });
    widget.onChanged(widget.contacts);
  }

  void _removeContact(int index) {
    setState(() {
      widget.contacts.removeAt(index);
    });
    widget.onChanged(widget.contacts);
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Contacts',
              style: AppTheme.getCurrentTheme(
                false,
                connectionStatus,
              ).textTheme.bodyMedium!.copyWith(fontSize: 16),
            ),
            IconButton(
              onPressed: _addContact,
              icon: const Icon(Icons.add_circle_outline_rounded),
            ),
          ],
        ),
        8.h,
        ...widget.contacts.asMap().entries.map((entry) {
          final index = entry.key;
          final contact = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomMmTextField(
                            labelText: 'First Name'.tr(),
                            hintText: 'Enter First Name'.tr(),
                            controller: contact.firstNameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Required' : null,
                          ),
                        ),
                        10.w,
                        Expanded(
                          child: CustomMmTextField(
                            labelText: 'Last Name'.tr(),
                            hintText: 'Enter Last Name'.tr(),
                            controller: contact.lastNameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    10.h,
                    Row(
                      children: [
                        Expanded(
                          child: CustomMmTextField(
                            labelText: 'Email'.tr(),
                            hintText: 'Enter Email'.tr(),
                            controller: contact.emailController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Required';
                              } else if (!v.contains('@')) {
                                return 'Invalid Email';
                              }
                              return null;
                            },
                          ),
                        ),
                        10.w,
                        Expanded(
                          child: CustomMmTextField(
                            labelText: 'Telephone'.tr(),
                            hintText: 'Enter Telephone'.tr(),
                            controller: contact.telephoneController,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    10.h,
                    CustomMmTextField(
                      labelText: 'Mobile'.tr(),
                      hintText: 'Enter Mobile Number'.tr(),
                      controller: contact.mobileController,
                      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => _removeContact(index),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
