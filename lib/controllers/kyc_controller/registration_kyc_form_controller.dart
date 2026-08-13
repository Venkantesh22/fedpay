import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/data/models/district_model.dart';
import 'package:lekra/data/models/status_model.dart';

class RegistrationKycFromController extends GetxController
    implements GetxService {
  // ============================================================
  // BASIC DETAILS
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

  final TextEditingController businessMCCController =
      TextEditingController();

  final TextEditingController sellerIdentifierController =
      TextEditingController();

  final TextEditingController dateOfIncorporationController =
      TextEditingController();

  // ============================================================
  // ADDRESS
  // ============================================================

  final TextEditingController shopAddressController =
      TextEditingController();

  final TextEditingController cityController =
      TextEditingController();

  final TextEditingController pincodeController =
      TextEditingController();

  StateModel? selectState;

  DistrictModel? selectDistrict;

  // ============================================================
  // DROPDOWN VALUES
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

    // State changed, therefore district must be reset.
    selectDistrict = null;

    update();
  }

  void setDistrict(DistrictModel? district) {
    selectDistrict = district;
    update();
  }

  // ============================================================
  // CLEAR FORM
  // ============================================================

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();

    businessNameController.clear();
    businessNumberController.clear();
    businessEmailController.clear();
    businessMCCController.clear();

    sellerIdentifierController.clear();
    dateOfIncorporationController.clear();

    shopAddressController.clear();
    cityController.clear();
    pincodeController.clear();

    turnoverType = null;
    acceptanceType = null;
    ownershipType = null;

    selectState = null;
    selectDistrict = null;

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

    if (businessNameController.text.trim().isEmpty) {
      return false;
    }

    if (businessNumberController.text.trim().isEmpty) {
      return false;
    }

    if (businessEmailController.text.trim().isEmpty) {
      return false;
    }

    if (shopAddressController.text.trim().isEmpty) {
      return false;
    }

    if (cityController.text.trim().isEmpty) {
      return false;
    }

    if (pincodeController.text.trim().isEmpty) {
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
  // REQUEST DATA
  // ============================================================

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstNameController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'business_name': businessNameController.text.trim(),
      'mobile_number': businessNumberController.text.trim(),
      'email': businessEmailController.text.trim(),
      'mcc': businessMCCController.text.trim(),
      'seller_identifier': sellerIdentifierController.text.trim(),

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

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();

    businessNameController.dispose();
    businessNumberController.dispose();
    businessEmailController.dispose();
    businessMCCController.dispose();

    sellerIdentifierController.dispose();
    dateOfIncorporationController.dispose();

    shopAddressController.dispose();
    cityController.dispose();
    pincodeController.dispose();

    super.onClose();
  }
}