import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankDetailsController extends GetxController
    implements GetxService {
  // ============================================================
  // ACCOUNT DETAILS
  // ============================================================

  final TextEditingController accountNameController =
      TextEditingController();

  final TextEditingController accountNumberController =
      TextEditingController();

  final TextEditingController confirmAccountNumberController =
      TextEditingController();

  final TextEditingController ifscController =
      TextEditingController();

  final TextEditingController bankNameController =
      TextEditingController();

  final TextEditingController branchNameController =
      TextEditingController();

  final TextEditingController registeredMobileController =
      TextEditingController();

  // ============================================================
  // ACCOUNT TYPE
  // ============================================================

  String accountType = 'Savings';

  final List<String> accountTypeList = [
    'Savings',
    'Current',
  ];

  void setAccountType(String value) {
    accountType = value;
    update();
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  bool validateBankDetails() {
    if (accountNameController.text.trim().isEmpty) {
      return false;
    }

    if (accountNumberController.text.trim().isEmpty) {
      return false;
    }

    if (confirmAccountNumberController.text.trim().isEmpty) {
      return false;
    }

    if (accountNumberController.text.trim() !=
        confirmAccountNumberController.text.trim()) {
      return false;
    }

    if (ifscController.text.trim().isEmpty) {
      return false;
    }

    if (bankNameController.text.trim().isEmpty) {
      return false;
    }

    if (branchNameController.text.trim().isEmpty) {
      return false;
    }

    if (registeredMobileController.text.trim().length != 10) {
      return false;
    }

    return true;
  }

  // ============================================================
  // REQUEST DATA
  // ============================================================

  Map<String, dynamic> toMap() {
    return {
      'settlement_account_name':
          accountNameController.text.trim(),

      'settlement_account_number':
          accountNumberController.text.trim(),

      'settlement_account_ifsc':
          ifscController.text.trim().toUpperCase(),

      'bank_name':
          bankNameController.text.trim(),

      'branch_name':
          branchNameController.text.trim(),

      'account_type':
          accountType,

      'bank_registered_mobile':
          registeredMobileController.text.trim(),
    };
  }

  // ============================================================
  // CLEAR FORM
  // ============================================================

  void clearForm() {
    accountNameController.clear();
    accountNumberController.clear();
    confirmAccountNumberController.clear();
    ifscController.clear();
    bankNameController.clear();
    branchNameController.clear();
    registeredMobileController.clear();

    accountType = 'Savings';

    update();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    accountNameController.dispose();
    accountNumberController.dispose();
    confirmAccountNumberController.dispose();
    ifscController.dispose();
    bankNameController.dispose();
    branchNameController.dispose();
    registeredMobileController.dispose();

    super.onClose();
  }
}