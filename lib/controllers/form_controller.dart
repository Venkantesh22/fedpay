

import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/controllers/permission_controller.dart';
import 'package:lekra/data/models/district_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/status_model.dart';
import 'package:lekra/data/repositories/form_repo.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormController extends GetxController implements GetxService {
  final FormRepo formRepo;

  FormController({
    required this.formRepo,
  });

  // ============================================================
  // KYC STEP CONFIGURATION
  // ============================================================

  static const int totalSteps = 8;

  /// Current step: 0 -> 7
  int selectedIndex = 0;

  /// Whether each of the 8 steps has been completed.
  final List<bool> completed = List<bool>.filled(
    totalSteps,
    false,
  );

  /// Whether the review screen is currently displayed.
  bool isReviewScreen = false;

  /// Whether KYC has been submitted.
  bool isSubmitted = false;

  /// Loading state for API calls.
  bool isLoading = false;

  /// Current KYC status.
  String kycStatus = 'registration_started';

  // ============================================================
  // STEP NAMES
  // ============================================================

  static const List<String> stepNames = [
    'Basic',
    'Documents',
    'KYC Info',
    'Business',
    'Shop',
    'Selfie',
    'Bank',
    'Bank Doc',
  ];

  // ============================================================
  // STEP NAVIGATION
  // ============================================================

  void selectIndex(int index) {
    if (index < 0 || index >= totalSteps) {
      return;
    }

    selectedIndex = index;
    isReviewScreen = false;

    update();
  }

  void nextStep() {
    if (selectedIndex < totalSteps - 1) {
      completed[selectedIndex] = true;
      selectedIndex++;

      update();
    }
  }

  void previousStep() {
    if (selectedIndex > 0) {
      selectedIndex--;
      isReviewScreen = false;

      update();
    }
  }

  void goToReview() {
    if (!allStepsCompleted) {
      return;
    }

    isReviewScreen = true;
    update();
  }

  void backFromReview() {
    isReviewScreen = false;
    update();
  }

  // ============================================================
  // COMPLETION
  // ============================================================

  void setComplete(
    int index,
    bool value, {
    bool advanceIfTrue = false,
  }) {
    if (index < 0 || index >= totalSteps) {
      return;
    }

    completed[index] = value;

    if (advanceIfTrue && value) {
      if (selectedIndex < totalSteps - 1) {
        selectedIndex++;
      }
    }

    update();
  }

  void toggleComplete(int index) {
    if (index < 0 || index >= totalSteps) {
      return;
    }

    completed[index] = !completed[index];

    update();
  }

  void markAllComplete() {
    for (int i = 0; i < completed.length; i++) {
      completed[i] = true;
    }

    update();
  }

  bool get allStepsCompleted {
    return completed.every((element) => element);
  }

  bool isStepCompleted(int index) {
    if (index < 0 || index >= completed.length) {
      return false;
    }

    return completed[index];
  }

  // ============================================================
  // REGISTER / BASIC DETAILS
  // ============================================================

  final TextEditingController sellerIdentifierController =
      TextEditingController();

  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController businessNameController = TextEditingController();

  final TextEditingController businessNumberController =
      TextEditingController();

  final TextEditingController businessEmailController = TextEditingController();

  final TextEditingController businessMCCController = TextEditingController();

  final TextEditingController shopAddressController = TextEditingController();

  final TextEditingController cityController = TextEditingController();

  final TextEditingController pincodeController = TextEditingController();

  final TextEditingController addressLine1Controller = TextEditingController();

  final TextEditingController addressLine2Controller = TextEditingController();

  TextEditingController dateOfBirthController = TextEditingController();

  TextEditingController dateOfIncorporationController = TextEditingController();

  StateModel? selectState;
  DistrictModel? selectDistrict;

  // ============================================================
// KYC DOCUMENT UPLOAD
// ============================================================

  final List<String> kycDocumentNames = [
    'Aadhaar Front',
    'Aadhaar Back',
    'PAN Card',
    'Passport-size Photo',
    'GST Certificate',
    'Trade Licence',
    'MSME / Udyam Certificate',
  ];

  final List<String> kycDocumentDescriptions = [
    'Upload front side',
    'Upload back side',
    'Upload PAN card',
    'Upload passport-size photo',
    'Upload GST certificate',
    'Upload trade licence',
    'Upload Udyam certificate',
  ];

  /// Stores selected files.
  /// Index:
  /// 0 = Aadhaar Front
  /// 1 = Aadhaar Back
  /// 2 = PAN Card
  /// 3 = Passport Photo
  /// 4 = GST Certificate
  /// 5 = Trade Licence
  /// 6 = MSME / Udyam
  final List<File?> kycDocuments = List<File?>.filled(
    7,
    null,
  );

  /// Currently uploading document
  int? uploadingDocumentIndex;

  /// Whether a document is currently being uploaded
  bool get isUploadingDocument => uploadingDocumentIndex != null;

// ============================================================
// PICK KYC DOCUMENT
// ============================================================

  Future<void> pickKycDocument(int index) async {
    if (index < 0 || index >= kycDocuments.length) {
      return;
    }

    try {
      final bool isPassportPhoto = index == 3;

      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: isPassportPhoto
            ? [
                'jpg',
                'jpeg',
                'png',
              ]
            : [
                'pdf',
                'jpg',
                'jpeg',
                'png',
              ],
      );

      if (result == null ||
          result.files.isEmpty ||
          result.files.first.path == null) {
        return;
      }

      final String path = result.files.first.path!;

      final File file = File(path);

      // ----------------------------------------------------------
      // FILE SIZE VALIDATION
      // ----------------------------------------------------------

      final int fileSize = await file.length();

      // Maximum 10 MB
      const int maxFileSize = 10 * 1024 * 1024;

      if (fileSize > maxFileSize) {
        Get.snackbar(
          'File too large',
          'Please select a file smaller than 10 MB.',
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      // ----------------------------------------------------------
      // SAVE FILE
      // ----------------------------------------------------------

      kycDocuments[index] = file;

      update();
    } catch (e) {
      log(
        'ERROR pickKycDocument(): $e',
      );

      Get.snackbar(
        'Error',
        'Unable to select document.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

// ============================================================
// REMOVE KYC DOCUMENT
// ============================================================

  void removeKycDocument(int index) {
    if (index < 0 || index >= kycDocuments.length) {
      return;
    }

    kycDocuments[index] = null;

    update();
  }

// ============================================================
// CHECK DOCUMENT UPLOADED
// ============================================================

  bool isKycDocumentUploaded(int index) {
    if (index < 0 || index >= kycDocuments.length) {
      return false;
    }

    return kycDocuments[index] != null;
  }

// ============================================================
// GET FILE NAME
// ============================================================

  String getKycDocumentFileName(int index) {
    if (index < 0 || index >= kycDocuments.length) {
      return '';
    }

    final File? file = kycDocuments[index];

    if (file == null) {
      return '';
    }

    return file.path.split(Platform.pathSeparator).last;
  }

// ============================================================
// DOCUMENT COUNT
// ============================================================

  int get uploadedDocumentCount {
    return kycDocuments.where((file) => file != null).length;
  }

// ============================================================
// ALL DOCUMENTS UPLOADED
// ============================================================

  bool get allKycDocumentsUploaded {
    return kycDocuments.every(
      (file) => file != null,
    );
  }

// ============================================================
// DOCUMENT STEP COMPLETE
// ============================================================

  bool completeKycDocumentStep() {
    if (!allKycDocumentsUploaded) {
      Get.snackbar(
        'Documents Required',
        'Please upload all required documents.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }

    completed[1] = true;

    update();

    return true;
  }

// ============================================================
// CLEAR KYC DOCUMENTS
// ============================================================

  void clearKycDocuments() {
    for (int i = 0; i < kycDocuments.length; i++) {
      kycDocuments[i] = null;
    }

    uploadingDocumentIndex = null;

    update();
  }

  // ============================================================
  // BASIC DROPDOWNS
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

//! ============================================================
//! DOCUMENT DETAILS - SCREEN 3
//! ============================================================

  // ============================================================
// DOCUMENT DETAILS - SCREEN 3
// ============================================================

final TextEditingController aadhaarNumberController =
    TextEditingController();

final TextEditingController panNumberController =
    TextEditingController();

final TextEditingController gstNumberController =
    TextEditingController();

final TextEditingController tradeLicenseNumberController =
    TextEditingController();

final TextEditingController msmeNumberController =
    TextEditingController();

// ============================================================
// DOCUMENT DETAILS VALIDATION
// ============================================================

  bool validateDocumentDetails() {
    if (aadhaarNumberController.text.trim().isEmpty) {
      return false;
    }

    if (aadhaarNumberController.text.trim().length != 12) {
      return false;
    }

    if (panNumberController.text.trim().isEmpty) {
      return false;
    }

    return true;
  }

// ============================================================
// COMPLETE DOCUMENT DETAILS
// ============================================================

  bool completeDocumentDetails() {
    if (!validateDocumentDetails()) {
      return false;
    }

    completed[2] = true;

    update();

    return true;
  }

// ============================================================
// CLEAR DOCUMENT DETAILS
// ============================================================

  void clearDocumentDetails() {
    aadhaarNumberController.clear();
    panNumberController.clear();
    gstNumberController.clear();
    tradeLicenseNumberController.clear();
    msmeNumberController.clear();

    completed[2] = false;

    update();
  }

  // ============================================================
  // BUSINESS DETAILS
  // ============================================================

  String? businessCategory;
  String? natureOfBusiness;
  String? expectedMonthlyTransactionVolume;
  String? businessOwnershipType;

  final TextEditingController businessDescriptionController =
      TextEditingController();

  final TextEditingController businessStartDateController =
      TextEditingController();

  final List<String> businessCategoryList = [];

  final List<String> natureOfBusinessList = [];

  final List<String> transactionVolumeList = [
    'Below ₹50,000',
    '₹50,000 - ₹1 Lakh',
    '₹1 Lakh - ₹5 Lakh',
    '₹5 Lakh - ₹10 Lakh',
    'Above ₹10 Lakh',
  ];

  final List<String> businessOwnershipTypeList = [
    'Owned',
    'Rented',
    'Other',
  ];

  // ============================================================
  // DOCUMENT FILES
  // ============================================================

  String? aadhaarFrontPath;
  String? aadhaarBackPath;
  String? panCardPath;
  String? passportPhotoPath;
  String? gstCertificatePath;
  String? tradeLicensePath;
  String? msmeCertificatePath;

  // ============================================================
  // SHOP VERIFICATION
  // ============================================================

  String? shopLivePhotoPath;
  String? insideShopPhotoPath;

  bool shopSignboardVisible = false;
  bool shopLocationCaptured = false;

  double? shopLatitude;
  double? shopLongitude;

  DateTime? shopCapturedAt;

  // ============================================================
  // SELF VERIFICATION
  // ============================================================

  String? selfLivePhotoPath;

  bool livenessCompleted = false;
  bool photoToKycMatched = false;

  DateTime? selfCapturedAt;

  // ============================================================
  // BANK DETAILS
  // ============================================================

  final TextEditingController settlementAccountNameController =
      TextEditingController();

  final TextEditingController settlementAccountNumberController =
      TextEditingController();

  final TextEditingController confirmAccountNumberController =
      TextEditingController();

  final TextEditingController settlementAccountIFSCController =
      TextEditingController();

  final TextEditingController bankNameController = TextEditingController();

  final TextEditingController branchNameController = TextEditingController();

  final TextEditingController bankRegisteredMobileController =
      TextEditingController();

  String accountType = 'Savings';

  // ============================================================
  // BANK DOCUMENT
  // ============================================================

  String? cancelledChequePath;
  String? bankStatementPath;

  // ============================================================
  // DECLARATION
  // ============================================================

  bool declarationAccepted = false;

  void setDeclaration(bool value) {
    declarationAccepted = value;
    update();
  }

  // ============================================================
  // DOCUMENT SETTERS
  // ============================================================

  void setAadhaarFront(String? path) {
    aadhaarFrontPath = path;
    update();
  }

  void setAadhaarBack(String? path) {
    aadhaarBackPath = path;
    update();
  }

  void setPanCard(String? path) {
    panCardPath = path;
    update();
  }

  void setPassportPhoto(String? path) {
    passportPhotoPath = path;
    update();
  }

  void setGstCertificate(String? path) {
    gstCertificatePath = path;
    update();
  }

  void setTradeLicense(String? path) {
    tradeLicensePath = path;
    update();
  }

  void setMsmeCertificate(String? path) {
    msmeCertificatePath = path;
    update();
  }

  // ============================================================
  // SHOP VERIFICATION SETTERS
  // ============================================================

  void setShopLivePhoto(String? path) {
    shopLivePhotoPath = path;
    update();
  }

  void setInsideShopPhoto(String? path) {
    insideShopPhotoPath = path;
    update();
  }

  void setShopSignboardVisible(bool value) {
    shopSignboardVisible = value;
    update();
  }

  void setShopLocation({
    required double latitude,
    required double longitude,
  }) {
    shopLatitude = latitude;
    shopLongitude = longitude;
    shopLocationCaptured = true;
    shopCapturedAt = DateTime.now();

    update();
  }

  // ============================================================
  // SELF VERIFICATION SETTERS
  // ============================================================

  void setSelfLivePhoto(String? path) {
    selfLivePhotoPath = path;
    selfCapturedAt = DateTime.now();

    update();
  }

  void setLivenessCompleted(bool value) {
    livenessCompleted = value;
    update();
  }

  void setPhotoToKycMatched(bool value) {
    photoToKycMatched = value;
    update();
  }

  // ============================================================
  // BANK SETTERS
  // ============================================================

  void setAccountType(String value) {
    accountType = value;
    update();
  }

  void setCancelledCheque(String? path) {
    cancelledChequePath = path;
    update();
  }

  void setBankStatement(String? path) {
    bankStatementPath = path;
    update();
  }

  // ============================================================
  // DROPDOWN SETTERS
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

  void setBusinessCategory(String? value) {
    businessCategory = value;
    update();
  }

  void setNatureOfBusiness(String? value) {
    natureOfBusiness = value;
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

  // ============================================================
  // STEP VALIDATION
  // ============================================================

  bool validateStep(int step) {
    switch (step) {
      // --------------------------------------------------------
      // STEP 1 - BASIC
      // --------------------------------------------------------
      case 0:
        return firstNameController.text.trim().isNotEmpty &&
            lastNameController.text.trim().isNotEmpty &&
            businessNumberController.text.trim().isNotEmpty &&
            businessEmailController.text.trim().isNotEmpty &&
            businessNameController.text.trim().isNotEmpty &&
            shopAddressController.text.trim().isNotEmpty &&
            pincodeController.text.trim().length == 6 &&
            cityController.text.trim().isNotEmpty &&
            selectState != null;

      // --------------------------------------------------------
      // STEP 2 - DOCUMENTS
      // --------------------------------------------------------
      case 1:
        return aadhaarFrontPath != null &&
            aadhaarBackPath != null &&
            panCardPath != null &&
            passportPhotoPath != null;

      // --------------------------------------------------------
      // STEP 3 - DOCUMENT NUMBERS
      // --------------------------------------------------------
      case 2:
        return aadhaarNumberController.text.trim().isNotEmpty &&
            panNumberController.text.trim().isNotEmpty;

      // --------------------------------------------------------
      // STEP 4 - BUSINESS
      // --------------------------------------------------------
      case 3:
        return businessCategory != null &&
            natureOfBusiness != null &&
            businessDescriptionController.text.trim().isNotEmpty &&
            businessStartDateController.text.trim().isNotEmpty &&
            expectedMonthlyTransactionVolume != null &&
            businessOwnershipType != null;

      // --------------------------------------------------------
      // STEP 5 - SHOP
      // --------------------------------------------------------
      case 4:
        return shopLivePhotoPath != null;

      // --------------------------------------------------------
      // STEP 6 - SELFIE
      // --------------------------------------------------------
      case 5:
        return selfLivePhotoPath != null;

      // --------------------------------------------------------
      // STEP 7 - BANK
      // --------------------------------------------------------
      case 6:
        return settlementAccountNameController.text.trim().isNotEmpty &&
            bankNameController.text.trim().isNotEmpty &&
            settlementAccountNumberController.text.trim().isNotEmpty &&
            confirmAccountNumberController.text.trim() ==
                settlementAccountNumberController.text.trim() &&
            settlementAccountIFSCController.text.trim().isNotEmpty;

      // --------------------------------------------------------
      // STEP 8 - BANK DOCUMENT
      // --------------------------------------------------------
      case 7:
        return cancelledChequePath != null || bankStatementPath != null;

      default:
        return false;
    }
  }

  // ============================================================
  // NEXT STEP WITH VALIDATION
  // ============================================================

  bool continueToNextStep() {
    if (!validateStep(selectedIndex)) {
      return false;
    }

    completed[selectedIndex] = true;

    if (selectedIndex < totalSteps - 1) {
      selectedIndex++;
      update();
      return true;
    }

    update();
    return true;
  }

  // ============================================================
  // REVIEW VALIDATION
  // ============================================================

  bool validateBeforeSubmit() {
    for (int i = 0; i < totalSteps; i++) {
      if (!validateStep(i)) {
        selectedIndex = i;
        isReviewScreen = false;
        update();
        return false;
      }
    }

    if (!declarationAccepted) {
      return false;
    }

    return true;
  }

  // ============================================================
  // API
  // ============================================================

  // Future<ResponseModel> postUploadKYC(
  //   BuildContext context,
  // ) async {
  //   log('----------- postUploadKYC Called ----------');

  //   ResponseModel responseModel;

  //   isLoading = true;
  //   update();

  //   try {
  //     final sharedPreferences = await SharedPreferences.getInstance();

  //     final permissionController = Get.find<PermissionController>();

  //     if (permissionController.latitude == null ||
  //         permissionController.longitude == null) {
  //       await permissionController.requestLocationPermissionAndFetch(context);
  //     }

  //     final Map<String, dynamic> data = {
  //       'api_token': sharedPreferences.getString(
  //         AppConstants.apiToken,
  //       ),

  //       // BASIC
  //       'seller_identifier': sellerIdentifierController.text.trim(),

  //       'first_name': firstNameController.text.trim(),

  //       'last_name': lastNameController.text.trim(),

  //       'business_name': businessNameController.text.trim(),

  //       'mobile_number': businessNumberController.text.trim(),

  //       'email': businessEmailController.text.trim(),

  //       'mcc': businessMCCController.text.trim(),

  //       'turnover_type': turnoverType,

  //       'acceptance_type': acceptanceType,

  //       'ownership_type': ownershipType,

  //       'state_id': selectState?.stateId,

  //       'district_id': selectDistrict?.districtId,

  //       'city': cityController.text.trim(),

  //       'pincode': pincodeController.text.trim(),

  //       'address_line1': addressLine1Controller.text.trim(),

  //       'address_line2': addressLine2Controller.text.trim(),

  //       // KYC NUMBERS
  //       'aadhaar_number': aadhaarNumberController.text.trim(),

  //       'pan_number': panNumberController.text.trim(),

  //       'gst_number': gstNumberController.text.trim(),

  //       'trade_license_number': tradeLicenseNumberController.text.trim(),

  //       'msme_number': msmeNumberController.text.trim(),

  //       // BUSINESS
  //       'business_category': businessCategory,

  //       'nature_of_business': natureOfBusiness,

  //       'business_description': businessDescriptionController.text.trim(),

  //       'business_start_date': businessStartDateController.text.trim(),

  //       'expected_monthly_transaction_volume': expectedMonthlyTransactionVolume,

  //       'business_ownership_type': businessOwnershipType,

  //       // BANK
  //       'settlement_account_name': settlementAccountNameController.text.trim(),

  //       'settlement_account_number':
  //           settlementAccountNumberController.text.trim(),

  //       'settlement_account_ifsc': settlementAccountIFSCController.text.trim(),

  //       'bank_name': bankNameController.text.trim(),

  //       'branch_name': branchNameController.text.trim(),

  //       'account_type': accountType,

  //       'bank_registered_mobile': bankRegisteredMobileController.text.trim(),

  //       // EXISTING
  //       'dob': dateOfBirthController.text.trim(),

  //       'doi': dateOfIncorporationController.text.trim(),

  //       // LOCATION
  //       'latitude': permissionController.latitude,

  //       'longitude': permissionController.longitude,

  //       // DECLARATION
  //       'declaration_accepted': declarationAccepted,
  //     };

  //     final Response response = await formRepo.postUploadKYC(
  //       data: FormData(data),
  //     );

  //     if (response.statusCode == 200 && response.body['status'] == 'success') {
  //       responseModel = ResponseModel(
  //         true,
  //         response.body['message'] ?? 'KYC submitted successfully',
  //       );

  //       kycStatus = 'kyc_submitted';
  //       isSubmitted = true;

  //       update();
  //     } else {
  //       String errorMessage = 'seller_identifier';

  //       if (response.body['errors'] is Map) {
  //         final errors = response.body['errors'] as Map;

  //         if (errors.isNotEmpty) {
  //           final firstKey = errors.keys.first;

  //           errorMessage = errors[firstKey][0].toString();
  //         }
  //       } else {
  //         errorMessage = response.body['message'] ?? 'Unknown Error';
  //       }

  //       responseModel = ResponseModel(
  //         false,
  //         errorMessage,
  //       );
  //     }
  //   } catch (e) {
  //     log(
  //       'ERROR AT postUploadKYC(): $e',
  //     );

  //     responseModel = ResponseModel(
  //       false,
  //       'Error while postUploadKYC $e',
  //     );
  //   }

  //   isLoading = false;
  //   update();

  //   return responseModel;
  // }

  // ============================================================
  // RESET FORM
  // ============================================================

  void resetForm() {
    selectedIndex = 0;

    for (int i = 0; i < completed.length; i++) {
      completed[i] = false;
    }

    isReviewScreen = false;
    isSubmitted = false;
    declarationAccepted = false;
    kycStatus = 'registration_started';

    // BASIC
    sellerIdentifierController.clear();
    firstNameController.clear();
    lastNameController.clear();
    businessNameController.clear();
    businessNumberController.clear();
    businessEmailController.clear();
    businessMCCController.clear();
    shopAddressController.clear();
    cityController.clear();
    pincodeController.clear();
    addressLine1Controller.clear();
    addressLine2Controller.clear();

    // KYC
    aadhaarNumberController.clear();
    panNumberController.clear();
    gstNumberController.clear();
    tradeLicenseNumberController.clear();
    msmeNumberController.clear();

    // BUSINESS
    businessDescriptionController.clear();
    businessStartDateController.clear();

    // BANK
    settlementAccountNameController.clear();
    settlementAccountNumberController.clear();
    confirmAccountNumberController.clear();
    settlementAccountIFSCController.clear();
    bankNameController.clear();
    branchNameController.clear();
    bankRegisteredMobileController.clear();

    // DROPDOWNS
    turnoverType = null;
    acceptanceType = null;
    ownershipType = null;

    businessCategory = null;
    natureOfBusiness = null;
    expectedMonthlyTransactionVolume = null;
    businessOwnershipType = null;

    accountType = 'Savings';

    // DOCUMENTS
    aadhaarFrontPath = null;
    aadhaarBackPath = null;
    panCardPath = null;
    passportPhotoPath = null;
    gstCertificatePath = null;
    tradeLicensePath = null;
    msmeCertificatePath = null;

    // SHOP
    shopLivePhotoPath = null;
    insideShopPhotoPath = null;
    shopSignboardVisible = false;
    shopLocationCaptured = false;
    shopLatitude = null;
    shopLongitude = null;
    shopCapturedAt = null;

    // SELF
    selfLivePhotoPath = null;
    livenessCompleted = false;
    photoToKycMatched = false;
    selfCapturedAt = null;

    // BANK DOCUMENT
    cancelledChequePath = null;
    bankStatementPath = null;

    selectState = null;
    selectDistrict = null;

    update();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    sellerIdentifierController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    businessNameController.dispose();
    businessNumberController.dispose();
    businessEmailController.dispose();
    businessMCCController.dispose();
    shopAddressController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();

    dateOfBirthController.dispose();
    dateOfIncorporationController.dispose();

    aadhaarNumberController.dispose();
    panNumberController.dispose();
    gstNumberController.dispose();
    tradeLicenseNumberController.dispose();
    msmeNumberController.dispose();

    businessDescriptionController.dispose();
    businessStartDateController.dispose();

    settlementAccountNameController.dispose();
    settlementAccountNumberController.dispose();
    confirmAccountNumberController.dispose();
    settlementAccountIFSCController.dispose();
    bankNameController.dispose();
    branchNameController.dispose();
    bankRegisteredMobileController.dispose();

    super.onClose();
  }
}
