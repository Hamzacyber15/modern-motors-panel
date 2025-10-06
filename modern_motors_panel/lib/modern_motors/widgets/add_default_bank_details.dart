import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/model/invoices/templates/estimation_template_preview_model.dart';
import 'package:modern_motors_panel/modern_motors/widgets/custom_mm_text_field.dart';

class AddDefaultBankDetails extends StatefulWidget {
  final String? docId; // Firestore docId for editing
  final BankDetails? bank;

  const AddDefaultBankDetails({super.key, this.docId, this.bank});

  @override
  State<AddDefaultBankDetails> createState() => _AddDefaultBankDetailsState();
}

class _AddDefaultBankDetailsState extends State<AddDefaultBankDetails> {
  final _formKey = GlobalKey<FormState>();

  final bankNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ibanNumberController = TextEditingController();
  final swiftNumberController = TextEditingController();

  String status = "active"; // default status
  bool saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.bank != null) {
      _fillControllers(widget.bank!);
    }
  }

  void _fillControllers(BankDetails bank) {
    bankNameController.text = bank.bankName ?? '';
    accountNumberController.text = bank.accountNumber ?? '';
    ibanNumberController.text = bank.ibanNumber ?? '';
    swiftNumberController.text = bank.swiftNumber ?? '';
    status = bank.status ?? "active";
  }

  Future<void> saveBankDetails() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => saving = true);

    try {
      final model = BankDetails(
        bankName: bankNameController.text,
        accountNumber: accountNumberController.text,
        ibanNumber: ibanNumberController.text,
        swiftNumber: swiftNumberController.text,
        status: status,
      );

      if (widget.docId != null) {
        // 🔹 Update existing
        await FirebaseFirestore.instance
            .collection("defaultBankDetails")
            .doc(widget.docId)
            .set(model.toMap(), SetOptions(merge: true));
      } else {
        // 🔹 Add new
        await FirebaseFirestore.instance
            .collection("defaultBankDetails")
            .add(model.toMap());
      }

      if (mounted) {
        Constants.showMessage(
          context,
          widget.docId != null
              ? "Bank details updated successfully!"
              : "Bank details added successfully!",
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error saving bank details: $e");
      if (!mounted) return;
      Constants.showMessage(context, "Error: $e");
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.bank != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Bank Details" : "Add Bank Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomMmTextField(
                controller: bankNameController,
                hintText: "Bank Name",
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              CustomMmTextField(
                controller: accountNumberController,
                hintText: "Account Number",
              ),
              CustomMmTextField(
                controller: ibanNumberController,
                hintText: "IBAN Number",
              ),
              CustomMmTextField(
                controller: swiftNumberController,
                hintText: "SWIFT Number",
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saving ? null : saveBankDetails,
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
