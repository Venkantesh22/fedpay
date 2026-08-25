import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/repositories/vender_kyc_repo.dart';

class BankDetailsController extends GetxController implements GetxService {
  final VenderKycRepo venderKycRepo;

  BankDetailsController({required this.venderKycRepo});

  bool isLoading = false;

  // ============================================================
  // ACCOUNT DETAILS
  // ============================================================

  final TextEditingController accountNameController =
      TextEditingController(text: "Ajeet das");

  final TextEditingController accountNumberController =
      TextEditingController(text: "12345678901");

  final TextEditingController confirmAccountNumberController =
      TextEditingController(text: "12345678901");

  final TextEditingController ifscController =
      TextEditingController(text: "SBIN0012345");

  final TextEditingController bankNameController =
      TextEditingController(text: "State Bank of India");

  final TextEditingController branchNameController =
      TextEditingController(text: "Karnul");

  final TextEditingController registeredMobileController =
      TextEditingController(text: "8926600327");

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
  //! Api call
  // ============================================================

  //* submit Vender kyc   venderKycBankDetails()
  Future<ResponseModel> venderKycBankDetails() async {
    log('----------- venderKycBankDetails Called ----------');

    isLoading = true;
    update();

    try {
      final Map<String, dynamic> data = {
        "section": "bank_details",
        "account_holder_name": accountNameController.text.trim(),
        "bank_name": bankNameController.text.trim(),
        "account_number": accountNumberController.text.trim(),
        "confirm_account_number": confirmAccountNumberController.text.trim(),
        "ifsc_code": ifscController.text.trim(),
        "branch_name": branchNameController.text.trim(),
        "account_type": accountType.toLowerCase(),
        "bank_registered_mobile": registeredMobileController.text.trim()
      };

      final response = await venderKycRepo.venderKycBankDetails(
        data: data,
      );

      log('STATUS CODE: ${response.statusCode}');
      log('RESPONSE BODY: ${response.body}');
      log('RESPONSE TYPE: ${response.body.runtimeType}');

      final body = response.body;

      if (response.statusCode == 200 &&
          body is Map &&
          body['status']?.toString().toLowerCase() == 'success') {
        return ResponseModel(
          true,
          body['message']?.toString() ??
              'venderKycBankDetails() submitted successfully',
        );
      }

      String message = 'Something went wrong';

      if (body is Map && body['message'] != null) {
        message = body['message'].toString();
      } else if (response.statusText != null &&
          response.statusText!.isNotEmpty) {
        message = response.statusText!;
      }

      return ResponseModel(false, message);
    } catch (e, stackTrace) {
      log(
        'ERROR AT venderKycBankDetails(): $e',
        stackTrace: stackTrace,
      );

      return ResponseModel(
        false,
        'Error while submitting venderKycBankDetails(): $e',
      );
    } finally {
      isLoading = false;
      update();
    }
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
