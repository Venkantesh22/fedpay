import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/data/models/district_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/status_model.dart';
import 'package:lekra/data/repositories/vender_kyc_repo.dart';

class RegistrationKycFromController extends GetxController
    implements GetxService {
  final VenderKycRepo venderKycRepo;
  RegistrationKycFromController({required this.venderKycRepo});

  bool isLoading = false;
  // ============================================================
  // REGISTRATION & BASIC DETAILS
  // ============================================================

  final TextEditingController firstNameController =
      TextEditingController();

  final TextEditingController lastNameController =
      TextEditingController();

  final TextEditingController businessNameController =
      TextEditingController();

  final TextEditingController businessNumberController =
      TextEditingController();

  final TextEditingController businessEmailController =
      TextEditingController();

  // final TextEditingController sellerIdentifierController =
  //     TextEditingController();

  final TextEditingController businessMCCController = TextEditingController();

  final TextEditingController shopAddressController =
      TextEditingController();

  final TextEditingController pincodeController =
      TextEditingController();

  // final TextEditingController cityController =
  //     TextEditingController();

  // final TextEditingController dateOfIncorporationController =
  //     TextEditingController();

  // ============================================================
  // STATE / DISTRICT
  // ============================================================

  StateModel? selectState;

  DistrictModel? selectCity;

  void setState(StateModel? state) {
    selectState = state;

    selectCity = null;

    update();
  }

  void setDistrict(DistrictModel? district) {
    selectCity = district;
    update();
  }

  // ============================================================
  // Call Api
  // ============================================================

  //* submit Vender kyc   venderKycBasicDetails()
  Future<ResponseModel> venderKycBasicDetails() async {
    log('----------- venderKycBasicDetails Called ----------');

    isLoading = true;
    update();

    try {
      final Map<String, dynamic> data = {
        "section": "basic_details",
        "first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "mobile_number": businessNumberController.text.trim(),
        "email": businessEmailController.text.trim(),
        "shop_name": businessNameController.text.trim(),
        "shop_address": shopAddressController.text.trim(),
        "pin_code": pincodeController.text.trim(),
        "city": selectCity?.districtName ?? "",
        "state": selectState?.stateName ?? "",
      };

      final response = await venderKycRepo.venderKycBasicDetails(
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
              'Registration details submitted successfully',
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
        'ERROR AT venderKycBasicDetails(): $e',
        stackTrace: stackTrace,
      );

      return ResponseModel(
        false,
        'Error while submitting registration details: $e',
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  // ============================================================
  // CLEAR
  // ============================================================

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    // sellerIdentifierController.clear();
    businessNameController.clear();
    businessNumberController.clear();
    businessEmailController.clear();
    businessMCCController.clear();
    shopAddressController.clear();
    pincodeController.clear();
    // cityController.clear();
    // dateOfIncorporationController.clear();

    selectState = null;
    selectCity = null;

    update();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    // sellerIdentifierController.dispose();
    businessNameController.dispose();
    businessNumberController.dispose();
    businessEmailController.dispose();
    businessMCCController.dispose();
    shopAddressController.dispose();
    pincodeController.dispose();
    // cityController.dispose();
    // dateOfIncorporationController.dispose();

    super.onClose();
  }
}
