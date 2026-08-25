import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/repositories/vender_kyc_repo.dart';

class BusinessInformationController extends GetxController
    implements GetxService {
  final VenderKycRepo venderKycRepo;

  BusinessInformationController({required this.venderKycRepo});

  bool isLoading = false;
  // ============================================================
  // BUSINESS INFORMATION
  // ============================================================

  String? businessCategory;

  String? expectedMonthlyTransactionVolume;

  String? businessOwnershipType;

  // ============================================================
  // TEXT CONTROLLERS
  // ============================================================

  final TextEditingController businessDescriptionController =
      TextEditingController();

  final TextEditingController businessStartDateController =
      TextEditingController();
  TextEditingController natureOfBusinessController = TextEditingController();

  // ============================================================
  // DROPDOWN LISTS
  // ============================================================

  final List<String> businessCategoryList = [
  'Retail',
  'Grocery / Kirana',
  'Electronic & Mobile',
  'Service & Consulting',
  'Food & Restaurants',
  'Apparel & Fashion',
  'Healthcare & Pharmacy',
  'Travel & Tourism',
  'Other',
];

final List<String> transactionVolumeList = [
  'Under 1 Lakh',
  '1 Lakh - 5 Lakh',
  '5 Lakh - 20 Lakh',
  'Above 20 Lakh',
];

final List<String> businessOwnershipTypeList = [
  'owned',
  'rented',
  'other',
];
  // ============================================================
  // SETTERS
  // ============================================================

  void setBusinessCategory(String? value) {
    businessCategory = value;
    update();
  }

  void setExpectedMonthlyTransactionVolume(String? value) {
    expectedMonthlyTransactionVolume = value;
    update();
  }

  void setBusinessOwnershipType(String? value) {
    businessOwnershipType = value;
    update();
  }

  //* submit Vender kyc Business information  venderKycBusinessInfo()
  Future<ResponseModel> venderKycBusinessInfo() async {
    log('----------- venderKycBusinessInfo Called ----------');

    isLoading = true;
    update();

    try {
      final Map<String, dynamic> data = {
        "section": "business_info",
        "business_category": businessCategory,
        "nature_of_business": natureOfBusinessController.text.trim(),
        "business_description": businessDescriptionController.text.trim(),
        "business_start_date": businessStartDateController.text.trim(),
        "expected_monthly_volume": expectedMonthlyTransactionVolume,
        "ownership_type": businessOwnershipType?.toLowerCase(),
      };

      final response = await venderKycRepo.venderKycBusinessInfo(
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
              'venderKycBusinessInfo details submitted successfully',
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
        'ERROR AT venderKycBusinessInfo(): $e',
        stackTrace: stackTrace,
      );

      return ResponseModel(
        false,
        'Error while submitting venderKycBusinessInfo() : $e',
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
    businessCategory = null;
    natureOfBusinessController.clear();
    expectedMonthlyTransactionVolume = null;
    businessOwnershipType = null;

    businessDescriptionController.clear();
    businessStartDateController.clear();

    update();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    businessDescriptionController.dispose();
    businessStartDateController.dispose();
    natureOfBusinessController.dispose();

    super.onClose();
  }
}
