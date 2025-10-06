import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/model/default_address_preview.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';

class AddDefaultAddress extends StatefulWidget {
  final String? docId; // Firestore docId for editing
  final DefaultAddressModel? address;

  const AddDefaultAddress({super.key, this.docId, this.address});

  @override
  State<AddDefaultAddress> createState() => _AddDefaultAddressState();
}

class _AddDefaultAddressState extends State<AddDefaultAddress> {
  final _formKey = GlobalKey<FormState>();

  // controllers for all fields
  final companyNameController = TextEditingController();
  final companyNameArController = TextEditingController();
  final companyAddressController = TextEditingController();
  final companyContact1Controller = TextEditingController();
  final companyContact2Controller = TextEditingController();
  final streetController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine1ArController = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final addressLine2ArController = TextEditingController();
  final addressLine3Controller = TextEditingController();
  final addressLine3ArController = TextEditingController();
  final websiteController = TextEditingController();
  final cityController = TextEditingController();
  final email1Controller = TextEditingController();
  final email2Controller = TextEditingController();
  final address2Line1Controller = TextEditingController();
  final address2Line1ArController = TextEditingController();
  final address2Line2Controller = TextEditingController();
  final address2Line2ArController = TextEditingController();
  final address2Line3Controller = TextEditingController();
  final address2Line3ArController = TextEditingController();
  final branchLine1Controller = TextEditingController();
  final branchLine2Controller = TextEditingController();

  bool saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _fillControllers(widget.address!);
    }
  }

  void _fillControllers(DefaultAddressModel model) {
    companyNameController.text = model.companyName ?? '';
    companyNameArController.text = model.companyNameAr ?? '';
    companyAddressController.text = model.companyAddress ?? '';
    companyAddressController.text = model.companyAddress ?? '';
    companyContact1Controller.text = model.companyContact1 ?? '';
    companyContact2Controller.text = model.companyContact2 ?? '';
    streetController.text = model.streetAddress ?? '';
    addressLine1Controller.text = model.addressLine1 ?? '';
    addressLine1ArController.text = model.addressLine1Ar ?? '';
    addressLine2Controller.text = model.addressLine2 ?? '';
    addressLine2ArController.text = model.addressLine2Ar ?? '';
    addressLine3Controller.text = model.addressLine3 ?? '';
    addressLine3ArController.text = model.addressLine3Ar ?? '';
    websiteController.text = model.website ?? '';
    cityController.text = model.city ?? '';
    email1Controller.text = model.email ?? '';
    email2Controller.text = model.email2 ?? '';
    address2Line1Controller.text = model.address2Line1 ?? '';
    address2Line1ArController.text = model.address2Line1Ar ?? '';
    address2Line2Controller.text = model.address2Line2 ?? '';
    address2Line2ArController.text = model.address2Line2Ar ?? '';
    address2Line3Controller.text = model.address2Line3 ?? '';
    address2Line3ArController.text = model.address2Line3Ar ?? '';
    branchLine1Controller.text = model.branchLine1 ?? '';
    branchLine2Controller.text = model.branchLine2 ?? '';
  }

  Future<void> saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => saving = true);

    try {
      final model = DefaultAddressModel(
        companyName: companyNameController.text,
        companyNameAr: companyNameArController.text,
        companyAddress: companyAddressController.text,
        companyContact1: companyContact1Controller.text,
        companyContact2: companyContact2Controller.text,
        streetAddress: streetController.text,
        addressLine1: addressLine1Controller.text,
        addressLine1Ar: addressLine1ArController.text,
        addressLine2: addressLine2Controller.text,
        addressLine2Ar: addressLine2ArController.text,
        addressLine3: addressLine3Controller.text,
        addressLine3Ar: addressLine3ArController.text,
        website: websiteController.text,
        city: cityController.text,
        email: email1Controller.text,
        email2: email2Controller.text,
        address2Line1: address2Line1Controller.text,
        address2Line1Ar: address2Line1ArController.text,
        address2Line2: address2Line2Controller.text,
        address2Line2Ar: address2Line2ArController.text,
        address2Line3: address2Line3Controller.text,
        address2Line3Ar: address2Line3ArController.text,
        branchLine1: branchLine1Controller.text,
        branchLine2: branchLine2Controller.text,
        status: widget.address != null ? widget.address!.status : 'active',
      );

      if (widget.docId != null) {
        // 🔹 Update existing
        await FirebaseFirestore.instance
            .collection("defaultAddresses")
            .doc(widget.docId)
            .set(model.toMap(), SetOptions(merge: true));
      } else {
        // 🔹 Add new
        await FirebaseFirestore.instance
            .collection("defaultAddresses")
            .add(model.toMap());
      }

      if (mounted) {
        Constants.showMessage(
          context,
          widget.docId != null
              ? "Address updated successfully!"
              : "Address added successfully!",
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error saving address: $e");
      if (!mounted) return;
      Constants.showMessage(context, "Error: $e");
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Widget _rowFields(Widget left, Widget right) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 10),
        Expanded(child: right),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.address != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Default Address" : "Add Default Address"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _rowFields(
                CustomMmTextField(
                  controller: companyNameController,
                  hintText: 'Company Name',
                  validator: (val) =>
                      val == null || val.isEmpty ? "Required" : null,
                ),
                CustomMmTextField(
                  controller: companyNameArController,
                  hintText: 'Company Name (AR)',
                  validator: (val) =>
                      val == null || val.isEmpty ? "Required" : null,
                ),
              ),
              const SizedBox(height: 10),
              _rowFields(
                CustomMmTextField(
                  controller: companyAddressController,
                  hintText: 'Company Address',
                  validator: (val) =>
                      val == null || val.isEmpty ? "Required" : null,
                ),
                CustomMmTextField(
                  controller: streetController,
                  hintText: 'Street Address',
                  validator: (val) =>
                      val == null || val.isEmpty ? "Required" : null,
                ),
              ),
              const SizedBox(height: 10),
              _rowFields(
                CustomMmTextField(
                  controller: companyContact1Controller,
                  hintText: 'Contact 1',
                  validator: (val) =>
                      val == null || val.isEmpty ? "Required" : null,
                ),
                CustomMmTextField(
                  controller: companyContact2Controller,
                  hintText: 'Contact 2',
                ),
              ),
              const SizedBox(height: 10),
              _rowFields(
                CustomMmTextField(
                  controller: cityController,
                  hintText: 'City',
                  validator: (val) =>
                      val == null || val.isEmpty ? "Required" : null,
                ),
                CustomMmTextField(
                  controller: websiteController,
                  hintText: 'Website',
                ),
              ),
              const SizedBox(height: 10),
              _rowFields(
                CustomMmTextField(
                  controller: email1Controller,
                  hintText: 'Email 1',
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Required";
                    if (!val.contains("@")) return "Invalid email";
                    return null;
                  },
                ),
                CustomMmTextField(
                  controller: email2Controller,
                  hintText: 'Email 2',
                ),
              ),
              const SizedBox(height: 10),
              _rowFields(
                CustomMmTextField(
                  controller: addressLine1Controller,
                  hintText: 'Address Line 1',
                ),
                CustomMmTextField(
                  controller: addressLine1ArController,
                  hintText: 'Address Line 1 (AR)',
                ),
              ),
              const SizedBox(height: 10),
              _rowFields(
                CustomMmTextField(
                  controller: addressLine2Controller,
                  hintText: 'Address Line 2',
                ),
                CustomMmTextField(
                  controller: addressLine2ArController,
                  hintText: 'Address Line 2 (AR)',
                ),
              ),
              const SizedBox(height: 10),
              _rowFields(
                CustomMmTextField(
                  controller: addressLine3Controller,
                  hintText: 'Address Line 3',
                ),
                CustomMmTextField(
                  controller: addressLine3ArController,
                  hintText: 'Address Line 3 (AR)',
                ),
              ),
              const SizedBox(height: 10),
              _rowFields(
                CustomMmTextField(
                  controller: address2Line1Controller,
                  hintText: 'Address2 Line 1',
                ),
                CustomMmTextField(
                  controller: address2Line1ArController,
                  hintText: 'Address2 Line 1 (AR)',
                ),
              ),
              const SizedBox(height: 10),
              _rowFields(
                CustomMmTextField(
                  controller: address2Line2Controller,
                  hintText: 'Address2 Line 2',
                ),
                CustomMmTextField(
                  controller: address2Line2ArController,
                  hintText: 'Address2 Line 2 (AR)',
                ),
              ),
              const SizedBox(height: 10),
              _rowFields(
                CustomMmTextField(
                  controller: address2Line3Controller,
                  hintText: 'Address2 Line 3',
                ),
                CustomMmTextField(
                  controller: address2Line3ArController,
                  hintText: 'Address2 Line 3 (AR)',
                ),
              ),
              const SizedBox(height: 10),
              _rowFields(
                CustomMmTextField(
                  controller: branchLine1Controller,
                  hintText: 'Branch Line 1',
                ),
                CustomMmTextField(
                  controller: branchLine2Controller,
                  hintText: 'Branch Line 2',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saving ? null : saveAddress,
                child: saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEdit ? "Update" : "Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
