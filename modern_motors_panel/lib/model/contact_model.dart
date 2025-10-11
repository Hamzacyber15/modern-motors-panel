import 'package:flutter/material.dart';

class ContactModel {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController telephoneController;
  final TextEditingController mobileController;

  ContactModel({
    String firstName = '',
    String lastName = '',
    String email = '',
    String telephone = '',
    String mobile = '',
  }) : firstNameController = TextEditingController(text: firstName),
       lastNameController = TextEditingController(text: lastName),
       emailController = TextEditingController(text: email),
       telephoneController = TextEditingController(text: telephone),
       mobileController = TextEditingController(text: mobile);

  Map<String, dynamic> toMap() => {
    'firstName': firstNameController.text,
    'lastName': lastNameController.text,
    'email': emailController.text,
    'telephone': telephoneController.text,
    'mobile': mobileController.text,
  };

  factory ContactModel.fromMap(Map<String, dynamic> map) => ContactModel(
    firstName: map['firstName'] ?? '',
    lastName: map['lastName'] ?? '',
    email: map['email'] ?? '',
    telephone: map['telephone'] ?? '',
    mobile: map['mobile'] ?? '',
  );

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    mobileController.dispose();
  }
}
