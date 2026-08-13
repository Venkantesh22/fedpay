import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/data/models/district_model.dart';
import 'package:lekra/data/models/status_model.dart';

class RegistrationKycFromController extends GetxController
    implements GetxService {
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

  final TextEditingController sellerIdentifierController =
      TextEditingController();

  final TextEditingController businessMCCController =
      TextEditingController();

  final TextEditingController shopAddressController =
      TextEditingController();

  final TextEditingController pincodeController =
      TextEditingController();

  final TextEditingController cityController =
      TextEditingController();

  final TextEditingController dateOfIncorporationController =
      TextEditingController();

  // ============================================================
  // STATE / DISTRICT
  // ============================================================

  StateModel? selectState;

  DistrictModel? selectDistrict;

  // ============================================================
  // DROPDOWNS
  // ============================================================

  String? turnoverType;
  String? acceptanceType;
  String? ownershipType;

  final List<String> turnoverTypeList = [
    'SMALL',
    'LARGE',
  ];

  final List<String> acceptanceTypeList = [
    'ONLINE',
    'OFFLINE',
  ];

  final List<String> ownershipTypeList = [
    'PROPRIETARY',
    'PARTNERSHIP',
    'PRIVATE',
    'LLP',
    'SOCIETY',
    'TRUST',
    'GOVT',
    'HUF',
    'BOI',
    'AOP',
    'AJP',
  ];

  // ============================================================
  // SETTERS
  // ============================================================

  void setTurnoverType(String? value) {
    turnoverType = value;
    update();
  }

  void setAcceptanceType(String? value) {
    acceptanceType = value;
    update();
  }

  void setOwnershipType(String? value) {
    ownershipType = value;
    update();
  }

  void setState(StateModel? state) {
    selectState = state;

    // Reset district whenever state changes.
    selectDistrict = null;

    update();
  }

  void setDistrict(DistrictModel? district) {
    selectDistrict = district;
    update();
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  bool validateRegistration() {
    if (firstNameController.text.trim().isEmpty) {
      return false;
    }

    if (lastNameController.text.trim().isEmpty) {
      return false;
    }

    if (businessNumberController.text.trim().length != 10) {
      return false;
    }

    if (businessEmailController.text.trim().isEmpty) {
      return false;
    }

    if (businessNameController.text.trim().isEmpty) {
      return false;
    }

    if (shopAddressController.text.trim().isEmpty) {
      return false;
    }

    if (pincodeController.text.trim().length != 6) {
      return false;
    }

    if (cityController.text.trim().isEmpty) {
      return false;
    }

    if (selectState == null) {
      return false;
    }

    if (selectDistrict == null) {
      return false;
    }

    return true;
  }

  // ============================================================
  // FORM DATA
  // ============================================================

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstNameController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'seller_identifier': sellerIdentifierController.text.trim(),
      'business_name': businessNameController.text.trim(),
      'mobile_number': businessNumberController.text.trim(),
      'email': businessEmailController.text.trim(),
      'mcc': businessMCCController.text.trim(),

      'turnover_type': turnoverType,
      'acceptance_type': acceptanceType,
      'ownership_type': ownershipType,

      'state_id': selectState?.stateId,
      'district_id': selectDistrict?.districtId,

      'city': cityController.text.trim(),
      'pincode': pincodeController.text.trim(),
      'shop_address': shopAddressController.text.trim(),

      'doi': dateOfIncorporationController.text.trim(),
    };
  }

  // ============================================================
  // CLEAR
  // ============================================================

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    sellerIdentifierController.clear();
    businessNameController.clear();
    businessNumberController.clear();
    businessEmailController.clear();
    businessMCCController.clear();
    shopAddressController.clear();
    pincodeController.clear();
    cityController.clear();
    dateOfIncorporationController.clear();

    turnoverType = null;
    acceptanceType = null;
    ownershipType = null;

    selectState = null;
    selectDistrict = null;

    update();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    sellerIdentifierController.dispose();
    businessNameController.dispose();
    businessNumberController.dispose();
    businessEmailController.dispose();
    businessMCCController.dispose();
    shopAddressController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    dateOfIncorporationController.dispose();

    super.onClose();
  }
}