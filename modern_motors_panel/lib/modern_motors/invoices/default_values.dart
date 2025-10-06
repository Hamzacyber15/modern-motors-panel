import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/model/default_address_preview.dart';
import 'package:modern_motors_panel/model/invoices/templates/estimation_template_preview_model.dart';
import 'package:modern_motors_panel/modern_motors/invoices/add_default_address.dart';
import 'package:modern_motors_panel/modern_motors/widgets/add_default_bank_details.dart';
import 'package:modern_motors_panel/modern_motors/widgets/add_default_values.dart';
import 'package:modern_motors_panel/modern_motors/widgets/invoices/set_default_value_button.dart';
import 'package:provider/provider.dart';

class DefaultValues extends StatefulWidget {
  const DefaultValues({super.key});

  @override
  State<DefaultValues> createState() => _DefaultValuesState();
}

class _DefaultValuesState extends State<DefaultValues> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<DefaultAddressModel> addresses = [];
  List<BankDetails> banks = [];
  bool loading = true;
  ValueNotifier<bool> defaultBankLoader = ValueNotifier(false);
  ValueNotifier<bool> defaultAddressLoader = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final addrSnap = await _firestore.collection("defaultAddresses").get();
      final bankSnap = await _firestore.collection("defaultBankDetails").get();

      final addrList = addrSnap.docs
          .map((doc) => DefaultAddressModel.fromDoc(doc))
          .toList();

      final bankList = bankSnap.docs
          .map((doc) => BankDetails.fromDoc(doc))
          .toList();

      setState(() {
        addresses = addrList;
        banks = bankList;
        loading = false;
      });
    } catch (e) {
      debugPrint("Error fetching data: $e");
      setState(() {
        loading = false;
      });
    }
  }

  void makeBankDefault(String docId) async {
    if (defaultBankLoader.value) {
      return;
    }
    try {
      defaultBankLoader.value = true;
      final firestore = FirebaseFirestore.instance;

      final currentDefault = banks.firstWhere(
        (b) => b.status == "default",
        orElse: () => BankDetails(id: null),
      );

      if (currentDefault.id != null && currentDefault.id != docId) {
        await firestore
            .collection("defaultBankDetails")
            .doc(currentDefault.id)
            .update({"status": "active"});
      }

      await firestore.collection("defaultBankDetails").doc(docId).update({
        "status": "default",
      });

      if (context.mounted) {
        Constants.showMessage(context, 'Bank set as default successfully!');
        await fetchData();
      }
    } catch (e) {
      debugPrint("Error setting default bank: $e");
      if (context.mounted) {
        Constants.showMessage(context, 'Error setting default bank: $e');
      }
    } finally {
      defaultBankLoader.value = false;
    }
  }

  void makeAddressDefault(String docId) async {
    if (defaultAddressLoader.value) {
      return;
    }
    try {
      defaultAddressLoader.value = true;
      final firestore = FirebaseFirestore.instance;

      final currentDefault = addresses.firstWhere(
        (b) => b.status == "default",
        orElse: () => DefaultAddressModel(id: null),
      );

      if (currentDefault.id != null && currentDefault.id != docId) {
        await firestore
            .collection("defaultAddresses")
            .doc(currentDefault.id)
            .update({"status": "active"});
      }

      await firestore.collection("defaultAddresses").doc(docId).update({
        "status": "default",
      });

      if (mounted) {
        Constants.showMessage(context, 'Bank set as default successfully!');
        await fetchData(); // refresh list
      }
    } catch (e) {
      debugPrint("Error setting default bank: $e");
      if (context.mounted) {
        Constants.showMessage(context, 'Error setting default bank: $e');
      }
    } finally {
      defaultAddressLoader.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              AddDefaultValuesWidget(
                title: 'Default Addresses',
                permissionAccess: 'Add Default Addresses',
                onPress: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return AddDefaultAddress();
                      },
                    ),
                  );
                  //context.push('/addDefaultAddress').then((value) {
                  fetchData();
                  //});
                },
              ),
              Expanded(
                child: addresses.isEmpty
                    ? const Center(child: Text("No addresses found"))
                    : ListView.builder(
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          final addr = addresses[index];
                          return Card(
                            child: ListTile(
                              onTap: () {
                                // context.push(
                                //   '/addDefaultAddress',
                                //   extra: {'docId': addr.id, 'address': addr},
                                // );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return AddDefaultAddress(
                                        docId: addr.id,
                                        address: addr,
                                      );
                                    },
                                  ),
                                );
                              },
                              title: Text(addr.companyAddress ?? "No Address"),
                              subtitle: Text(addr.city ?? ""),
                              trailing: SetDefaultValueButtonWidget(
                                permissionAccess: 'Add Default Addresses',
                                loadingNotifier: defaultAddressLoader,
                                onPress: () {
                                  makeAddressDefault(addr.id!);
                                },
                                status: addr.status!,
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const Divider(thickness: 2),
              AddDefaultValuesWidget(
                title: 'Default Bank Details',
                permissionAccess: 'Add Default Bank Details',
                onPress: () async {
                  // context.push('/addDefaultBankDetails').then((value) {
                  //   fetchData();
                  // });
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return AddDefaultBankDetails();
                      },
                    ),
                  );
                  fetchData();
                },
              ),
              Expanded(
                child: banks.isEmpty
                    ? const Center(child: Text("No bank details found"))
                    : ListView.builder(
                        itemCount: banks.length,
                        itemBuilder: (context, index) {
                          final bank = banks[index];
                          return Card(
                            child: ListTile(
                              onTap: () {
                                // context.push(
                                //   '/addDefaultBankDetails',
                                //   extra: {
                                //     'docId': bank.id, // docId from Firestore
                                //     'bank': bank, // model instance
                                //   },
                                // );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return AddDefaultBankDetails(
                                        docId: bank.id,
                                        bank: bank,
                                      );
                                    },
                                  ),
                                );
                              },
                              title: Text(bank.bankName ?? "No Bank Name"),
                              subtitle: Text("IBAN: ${bank.ibanNumber ?? ''}"),
                              trailing: SetDefaultValueButtonWidget(
                                permissionAccess: 'Add Default Bank Details',
                                loadingNotifier: defaultBankLoader,
                                onPress: () {
                                  makeBankDefault(bank.id!);
                                },
                                status: bank.status!,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
