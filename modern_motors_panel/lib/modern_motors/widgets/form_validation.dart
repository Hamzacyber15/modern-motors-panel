import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ValidationUtils {
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required.".tr();
    }
    if (value.length < 10 || value.length > 15) {
      return "Enter a valid phone number.".tr();
    }
    return null;
  }

  static String? validateCompanyName(String? value) {
    if (value == null || value.isEmpty) {
      return "Company name is required.".tr();
    }
    return null;
  }

  static String? heavyEquipmentName(String? value) {
    if (value == null || value.isEmpty) {
      return "Heavy Equipment name is required.".tr();
    }
    return null;
  }

  static String? heavyEquipmentArabicName(String? value) {
    if (value == null || value.isEmpty) {
      return "Heavy Equipment name arabic is required.".tr();
    }
    return null;
  }

  static String? serviceName(String? value) {
    if (value == null || value.isEmpty) {
      return "Service name is required.".tr();
    }
    return null;
  }

  static String? heavyEquipmentDescription(String? value) {
    if (value == null || value.isEmpty) {
      return "Heavy Equipment description is required.".tr();
    }
    return null;
  }

  static String? heavyEquipmentArabicDescription(String? value) {
    if (value == null || value.isEmpty) {
      return "Heavy Equipment description arabic is required.".tr();
    }
    return null;
  }

  static String? validateCustomerName(String? value) {
    if (value == null || value.isEmpty) {
      return "Customer name is required.".tr();
    }
    return null;
  }

  static String? productName(String? value) {
    if (value == null || value.isEmpty) {
      return "Product name is required.".tr();
    }
    return null;
  }

  static String? plateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Plate Number is required.".tr();
    }
    if (value.length < 4 || value.length > 8) {
      return "Enter a valid plate number.".tr();
    }
    return null;
  }

  static String? codeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Code is required.".tr();
    }

    return null;
  }

  static String? vehicleType(String? value) {
    if (value == null || value.isEmpty) {
      return "Vehicle Type is required.".tr();
    }

    return null;
  }

  static String? engineCapacity(String? value) {
    if (value == null || value.isEmpty) {
      return "Engine Capacity is required.".tr();
    }

    return null;
  }

  static String? maxLoad(String? value) {
    if (value == null || value.isEmpty) {
      return "Max Load is required.".tr();
    }

    return null;
  }

  static String? passengerCount(String? value) {
    if (value == null || value.isEmpty) {
      return "Passender Count is required.".tr();
    }

    return null;
  }

  static String? colorValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Color  is required.".tr();
    }

    return null;
  }

  static String? emptyWeight(String? value) {
    if (value == null || value.isEmpty) {
      return "Empty Weight is required.".tr();
    }

    return null;
  }

  static String? modelYear(String? value) {
    if (value == null || value.isEmpty) {
      return "Model Year is required.".tr();
    }

    return null;
  }

  static String? salary(String? value) {
    if (value == null || value.isEmpty) {
      return "Salary amount is required.".tr();
    }

    return null;
  }

  static String? contractSalary(String? value) {
    if (value == null || value.isEmpty) {
      return "Contract Salary amount is required.".tr();
    }

    return null;
  }

  static String? chassisNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Chassis Number is required.".tr();
    }

    return null;
  }

  static String? manufactureYear(String? value) {
    if (value == null || value.isEmpty) {
      return "Manufacture Year is required.".tr();
    }

    return null;
  }

  static String? expectedLife(String? value) {
    if (value == null || value.isEmpty) {
      return "Expected life of years is required.".tr();
    }
    if (value == '0') {
      return "Please enter a valid number.".tr();
    }
    return null;
  }

  static String? purchaseCost(String? value) {
    if (value == null || value.isEmpty) {
      return "Purchase cost is required.".tr();
    }
    if (value == '0') {
      return "Enter a valid purchase cost.".tr();
    }
    return null;
  }

  static String? depreciationRate(String? value) {
    if (value == null || value.isEmpty) {
      return "Depreciation rate is required.".tr();
    }
    if (value == '0') {
      return "Please enter a valid Depreciation rate.".tr();
    }
    return null;
  }

  static String? assetName(String? value) {
    if (value == null || value.isEmpty) {
      return "Asset name is required.".tr();
    }
    return null;
  }

  static String? assetDescription(String? value) {
    if (value == null || value.isEmpty) {
      return "Asset description is required.".tr();
    }
    return null;
  }

  static String? bankName(String? value) {
    if (value == null || value.isEmpty) {
      return "Bank name is required.".tr();
    }
    return null;
  }

  static String? nationality(String? value) {
    if (value == null || value.isEmpty) {
      return "Nationality is required.".tr();
    }
    return null;
  }

  static String? vatNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Vat number is required.".tr();
    }
    return null;
  }

  static String? idCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "ID Card Number is required.".tr();
    }
    return null;
  }

  static String? mobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Mobile Number is required.";
    }

    if (!RegExp(r'^\d{8}$').hasMatch(value)) {
      return 'Mobile Number must be 8 digits';
    }

    return null;
  }

  static String? businessName(String? value, {required String selectedType}) {
    if (selectedType != 'business') return null; // skip validation

    if (value == null || value.trim().isEmpty) {
      return 'Business Name is required';
    }
    return null;
  }

  static String? validateCustomerCrNumber(
    String? value, {
    required String selectedType,
  }) {
    if (selectedType != 'business') return null;

    if (value == null || value.trim().isEmpty) {
      return 'CR Number is required';
    }

    if (value.length < 6 || value.length > 20) {
      return 'CR Number must be between 6 and 20 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Only letters and numbers allowed';
    }

    return null;
  }

  static String? threshold(String? value) {
    if (value == null || value.isEmpty) {
      return "Threshold name is required.".tr();
    }
    return null;
  }

  static String? minimumPrice(String? value) {
    if (value == null || value.isEmpty) {
      return "Minimum price is required.".tr();
    }
    return null;
  }

  static String? productDescription(String? value) {
    if (value == null || value.isEmpty) {
      return "Product description is required.".tr();
    }
    return null;
  }

  static String? totalItems(String? value) {
    if (value == null || value.isEmpty) {
      return "Total Items is required.".tr();
    }
    return null;
  }

  static String? inventoryName(String? value) {
    if (value == null || value.isEmpty) {
      return "Inventory name is required.".tr();
    }
    return null;
  }

  static String? designationTitle(String? value) {
    if (value == null || value.isEmpty) {
      return "Designation Title is required.".tr();
    }
    return null;
  }

  static String? arabicDesignationTitle(String? value) {
    if (value == null || value.isEmpty) {
      return "Arabic Designation Title is required.".tr();
    }
    return null;
  }

  static String? shipping(String? value) {
    if (value == null || value.isEmpty) {
      return "Shipping Value is required.".tr();
    }
    return null;
  }

  static String? taxOrder(String? value) {
    if (value == null || value.isEmpty) {
      return "Tax Order is required.".tr();
    }
    return null;
  }

  static String? discount(String? value) {
    if (value == null || value.isEmpty) {
      return "Discount is required.".tr();
    }
    return null;
  }

  static String? priority(String? value) {
    if (value == null || value.isEmpty) {
      return "Priority is required.".tr();
    }
    return null;
  }

  static String? quantity(String? value) {
    debugPrint('=== ValidationUtils.quantity called with: $value ===');

    if (value == null || value.isEmpty) {
      debugPrint('Returning: Quantity is required');
      return "Quantity is required.";
    }

    // Check if value contains only digits
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      debugPrint('Returning: Only digits are allowed');
      return "Only digits are allowed for quantity.";
    }

    // Check if value is a valid positive number
    final quantity = int.tryParse(value);
    if (quantity == null) {
      debugPrint('Returning: Please enter a valid number');
      return "Please enter a valid number.";
    }

    // Check if quantity is positive
    if (quantity <= 0) {
      debugPrint('Returning: Quantity must be greater than zero');
      return "Quantity must be greater than zero.";
    }

    // Check for reasonable maximum limit
    if (quantity > 999999) {
      debugPrint('Returning: Quantity is too large');
      return "Quantity is too large.";
    }

    debugPrint('Returning: null (no error)');
    return null;
  }

  static String? price(String? value) {
    if (value == null || value.isEmpty) {
      return "Price is required.".tr();
    }
    final parsedPrice = double.tryParse(value);
    if (parsedPrice == null || parsedPrice <= 0) {
      return "Enter a valid price greater than 0.".tr();
    }

    return null;
  }

  static String? validateWhatsappNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "WhatsApp number is required.".tr();
    }
    if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
      return "Enter a valid WhatsApp number.".tr();
    }
    return null;
  }

  static String? validateContactNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Contact number is required.".tr();
    }
    if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
      return "Enter a valid contact number.".tr();
    }
    return null;
  }

  static String? validateEmergencyContactNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Emergency Contact Number is required.".tr();
    }
    if (!RegExp(r'^\d{8}$').hasMatch(value)) {
      return 'Contact number be 8 digits';
    }
    return null;
  }

  static String? validateOptionalEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      final RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
      );
      if (!emailRegex.hasMatch(value)) {
        return "Enter a valid email address.".tr();
      }
    }
    return null; // optional, so null is okay
  }

  static String? validateCrNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "CR number is required.".tr();
    }
    return null;
  }

  static String? validatePostalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Postal code is required';
    }

    if (!RegExp(r'^\d{4,6}$').hasMatch(value)) {
      return 'Postal code must be 4 to 6 digits';
    }

    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return "Address is required.".tr();
    }
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return "City is required.".tr();
    }
    return null;
  }

  static String? validateState(String? value) {
    if (value == null || value.isEmpty) {
      return "State is required.".tr();
    }
    return null;
  }

  static String? validateManagerName(String? value) {
    if (value == null || value.isEmpty) {
      return "Manager name is required.".tr();
    }
    return null;
  }

  static String? validateCategoryName(String? value) {
    if (value == null || value.isEmpty) {
      return "Category name is required.".tr();
    }
    return null;
  }

  static String? validateTermsTitle(String? value) {
    if (value == null || value.isEmpty) {
      return "Title is required.".tr();
    }
    return null;
  }

  static String? validateTermsDescription(String? value) {
    if (value == null || value.isEmpty) {
      return "Description is required.".tr();
    }
    return null;
  }

  static String? validateIndex(String? value) {
    if (value == null || value.isEmpty) {
      return "Index is required.".tr();
    }
    return null;
  }

  static String? leaveTypeArabic(String? value) {
    if (value == null || value.isEmpty) {
      return "Leave Type Arabic name is required.".tr();
    }
    return null;
  }

  static String? leaveType(String? value) {
    if (value == null || value.isEmpty) {
      return "Leave Type is required.".tr();
    }
    return null;
  }

  static String? noOfLeaves(String? value) {
    if (value == null || value.isEmpty) {
      return "Category name is required.".tr();
    }
    return null;
  }

  static String? validationMethodName(String? value) {
    if (value == null || value.isEmpty) {
      return "Method name is required.".tr();
    }
    return null;
  }

  static String? validateCurrencyCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Currency code is required';
    }

    if (!RegExp(r'^[A-Z]{3}$').hasMatch(value.trim())) {
      return 'Enter a valid 3-letter currency code (e.g. PKR, USD)';
    }

    return null;
  }

  static String? validateCountry(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Country name is required';
    }

    if (!RegExp(r'^[a-zA-Z\s]{2,}$').hasMatch(value.trim())) {
      return 'Enter a valid country name';
    }

    return null;
  }

  static String? validateNationality(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nationality is required';
    }

    if (!RegExp(r'^[a-zA-Z\s]{2,}$').hasMatch(value.trim())) {
      return 'Enter a valid Nationality';
    }

    return null;
  }

  static String? validateNationalityArabic(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nationality Arabic is required';
    }

    return null;
  }

  static String? priceListValidation(List? list) {
    if (list == null || list.isEmpty) {
      return 'Please add price';
    }
    return null; // valid case
  }

  static String? validateReview(String? value) {
    if (value == null || value.isEmpty) {
      return "Review cannot be empty.".tr();
    }
    if (value.length < 5) {
      return "Review must be at least 5 characters long.".tr();
    }
    if (value.length > 500) {
      return "Review cannot exceed 500 characters.".tr();
    }
    return null;
  }

  static String? validatePreviousPhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter phone number.".tr();
    }
    if (value.length < 10 || value.length > 15) {
      return "Enter a valid phone number.".tr();
    }
    return null;
  }

  static String? validateCodeNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Code number is required';
    }

    if (!RegExp(r'^\d{4,6}$').hasMatch(value)) {
      return 'Code number must be 4 to 6 digits';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required.".tr();
    }

    // Remove all spaces (optional)
    final cleaned = value.replaceAll(' ', '');

    // Final pattern: + followed by 10-15 digits only
    final RegExp regex = RegExp(r'^\+\d{10,15}$');

    if (!regex.hasMatch(cleaned)) {
      return "Enter a valid phone number (e.g., +923001234567)".tr();
    }

    return null;
  }

  // static String? validateAccountNumber(String? value) {
  //   if (value == null || value.trim().isEmpty) {
  //     return 'Account number is required';
  //   }
  //
  //   if (!RegExp(r'^\d{8,16}$').hasMatch(value)) {
  //     return 'Account number must be 8 to 16 digits';
  //   }
  //
  //   return null;
  // }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Description is required.".tr();
    }
    if (value.length < 10) {
      return "Description must be at least 10 characters long.".tr();
    }
    return null;
  }

  static String? validateLengthWidth(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required.".tr();
    }

    final numValue = double.tryParse(value);
    if (numValue == null) {
      return "Please enter a valid number.".tr();
    }

    if (numValue <= 0) {
      return "Value must be greater than 0.".tr();
    }

    if (numValue > 1000) {
      return "Value is too large (max: 1000).".tr();
    }

    return null;
  }

  static String? validateImage(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  }

  static String? validateNewICC(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter valid SIM number.".tr();
    }
    if (value.trim().length < 19) {
      return "Please enter valid SIM number.".tr();
    }
    return null;
  }

  static String? validateFiggersSimNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "SIM Number is required.".tr();
    }
    if (value.trim().length < 19) {
      return "Please enter a valid SIM number.".tr();
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email can't be empty".tr();
    }

    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
      r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    );

    if (!emailRegex.hasMatch(email)) {
      return "Please enter a valid email address".tr();
    }

    return null; // Email is valid
  }

  static String? invoiceDate(String? date) {
    if (date == null || date.isEmpty) {
      return "Please Choose Invoice date".tr();
    }
    return null;
  }

  static String? choseDate(String? date) {
    if (date == null || date.isEmpty) {
      return "Please Choose the date".tr();
    }
    return null;
  }

  static String? issueDate(String? date) {
    if (date == null || date.isEmpty) {
      return "Please Choose Issue date".tr();
    }
    return null;
  }

  static String? invoiceNumber(String? date) {
    if (date == null || date.isEmpty) {
      return "Please Generate Invoice Number".tr();
    }
    return null;
  }

  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.'.tr();
    }

    List<String> errors = [];

    if (!RegExp(r'.{8,}').hasMatch(value)) {
      errors.add('at least 8 characters');
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      errors.add('an uppercase letter');
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      errors.add('a lowercase letter');
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      errors.add('a number');
    }
    if (!RegExp(r'[@$!%*?&]').hasMatch(value)) {
      errors.add('a special character');
    }

    if (errors.isNotEmpty) {
      return 'Password must include ${errors.join(", ")}.'.tr();
    }

    return null; // Valid password
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required.".tr();
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long.".tr();
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required.".tr();
    }
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
      return "Name can only contain letters and spaces.".tr();
    }
    if (value.length < 3) {
      return "Name must be at least 3 characters long.".tr();
    }
    if (value.length > 40) {
      return "Name must be less than 40 characters long.".tr();
    }
    return null;
  }

  static String? validateEmergencyName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Emergency Contact Name is required.".tr();
    }
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
      return "Name can only contain letters and spaces.".tr();
    }
    if (value.length < 3) {
      return "Name must be at least 3 characters long.".tr();
    }
    if (value.length > 40) {
      return "Name must be less than 40 characters long.".tr();
    }
    return null;
  }

  static String? validateIdNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "ID number is required.".tr();
    }
    if (!RegExp(r"^\d+$").hasMatch(value)) {
      return "ID number must be numeric.".tr();
    }
    if (value.length < 10) {
      return "Id number must be at least 10 characters long.".tr();
    }
    if (value.length > 25) {
      return "Id number must be less than 25 characters long.".tr();
    }
    return null;
  }

  static String? validateVehicleNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Vehicle number is required.".tr();
    }
    if (!RegExp(r"^[A-Z]{2,3}-\d{3,4}$").hasMatch(value)) {
      return "Invalid vehicle number format (e.g., ABC-1234).".tr();
    }
    if (value.length < 2) {
      return "Vehicle number must be at least 2 characters long.".tr();
    }
    if (value.length > 10) {
      return "Vehicle number must be less than 10 characters long.".tr();
    }
    return null;
  }

  static String? checkEmpty(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "OTP cannot be empty".tr();
    }
    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return "Invalid OTP. Enter a 4-digit number".tr();
    }
    return null;
  }

  static String? validatePackagingLabel(List<String>? value) {
    if (value == null || value.isEmpty) {
      return 'Please add at least one pick-up location'.tr();
    }
    return null;
  }

  static String? advancePaymentPercentage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please add advance payment percentage'.tr();
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Confirm password is required.".tr();
    }
    if (value != password) {
      return "Passwords do not match.".tr();
    }
    return null;
  }

  static String? validateAccountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Account number is required.".tr();
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return "Account number must contain only digits.".tr();
    }
    if (value.length < 6) {
      return "Account number must be at least 6 digits.".tr();
    }
    if (value.length > 20) {
      return "Account number must not exceed 20 digits.".tr();
    }
    return null;
  }

  static String? validateFirstName(String? value) {
    if (value!.isEmpty) {
      return 'First Name is required.'.tr();
    } else if (value.length < 3) {
      return 'First Name should be at least 3 characters.'.tr();
    } else if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value)) {
      return 'First Name should only contain letters.'.tr();
    }
    return null;
  }

  static String? customerName(String? value) {
    if (value!.isEmpty) {
      return 'Please Choose Customer Name.'.tr();
    } else if (value.length < 3) {
      return 'Customer Name should be at least 3 characters.'.tr();
    } else if (!RegExp(r"^[A-Za-z]+(?: [A-Za-z]+)*$").hasMatch(value)) {
      return 'Customer Name should only contain letters.'.tr();
    }

    return null;
  }

  static String? validateLastName(String? value) {
    if (value!.isEmpty) {
      return 'Last Name is required.'.tr();
    } else if (value.length < 3) {
      return 'Last Name should be at least 3 characters.'.tr();
    } else if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value)) {
      return 'Last Name should only contain letters.'.tr();
    }
    return null;
  }

  // // Validator for Figgers Sim Number
  // static String? validateSimNumber(String? value) {
  //   if (value!.isEmpty) {
  //     return 'Sim Number is required.'.tr();
  //   } else if (value.length < 9 || value.length > 15) {
  //     return 'Sim Number should be between 9 and 15 digits.'.tr();
  //   }
  //   return null;
  // }

  // Validator for Sim Number
  static String? validateSimNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Sim Number is required.'.tr();
    }
    if (!RegExp(r'^\+?[0-9]+$').hasMatch(value)) {
      return 'Only numbers and + are allowed.'.tr();
    }
    if (value.length < 9 || value.length > 15) {
      return 'Sim Number should be between 9 and 15 digits.'.tr();
    }
    return null;
  }

  // Validator for IMEI Number
  static String? validateImeiNumber(String? value) {
    if (value!.isEmpty) {
      return 'IMEI Number is required.'.tr();
    } else if (value.length < 16) {
      return 'IMEI Number should be exactly 15 digits.'.tr();
    } else if (!RegExp(r"^\d{16}$").hasMatch(value)) {
      return 'IMEI Number should be exactly 15 digits.'.tr();
    }
    return null;
  }

  // Validator for Zip Code
  static String? validateZipCode(String? value) {
    if (value!.isEmpty) {
      return 'Zip Code is required.'.tr();
    } else if (value.length < 5) {
      return 'Zip Code should be exactly 5 digits.'.tr();
    } else if (!RegExp(r"^\d{5}(?:[-\s]\d{4})?$").hasMatch(value)) {
      return 'Invalid Zip Code format.'.tr();
    }
    return null;
  }

  // Add these methods to your ValidationUtils class
  static String? sellingPriceWithMinValidation(
    String? value,
    TextEditingController minPriceController,
  ) {
    if (value == null || value.isEmpty) {
      return 'Selling price is required'.tr();
    }

    final sellingPriceValue = double.tryParse(value);
    if (sellingPriceValue == null) {
      return 'Invalid selling price'.tr();
    }

    if (sellingPriceValue <= 0) {
      return 'Selling price must be greater than 0'.tr();
    }

    final minPriceText = minPriceController.text;
    if (minPriceText.isNotEmpty) {
      final minPriceValue = double.tryParse(minPriceText);
      if (minPriceValue != null && sellingPriceValue < minPriceValue) {
        return 'Selling price cannot be less than minimum price'.tr();
      }
    }

    return null;
  }

  static String? minimumPriceWithMaxValidation(
    String? value,
    TextEditingController sellingPriceController,
  ) {
    if (value == null || value.isEmpty) {
      return null; // Minimum price is optional
    }

    final minPriceValue = double.tryParse(value);
    if (minPriceValue == null) {
      return 'Invalid minimum price'.tr();
    }

    if (minPriceValue <= 0) {
      return 'Minimum price must be greater than 0'.tr();
    }

    final sellingPriceText = sellingPriceController.text;
    if (sellingPriceText.isNotEmpty) {
      final sellingPriceValue = double.tryParse(sellingPriceText);
      if (sellingPriceValue != null && minPriceValue > sellingPriceValue) {
        return 'Minimum price cannot be more than selling price'.tr();
      }
    }

    return null;
  }
}
