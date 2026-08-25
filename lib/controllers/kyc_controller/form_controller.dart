import 'dart:developer';

import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/kyc_controller/bank_details_controller.dart';
import 'package:lekra/controllers/kyc_controller/business_information_controller.dart';
import 'package:lekra/controllers/kyc_controller/document_details_controller.dart';
import 'package:lekra/controllers/kyc_controller/live_shop_verification_controller.dart';
import 'package:lekra/controllers/kyc_controller/registration_kyc_form_controller.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/vender_kyc/vender_kyc_details_model.dart';
import 'package:lekra/data/models/vender_kyc/vender_kyc_status_model.dart';
import 'package:lekra/data/repositories/vender_kyc_repo.dart';
import 'package:lekra/services/constants.dart';

class FormController extends GetxController implements GetxService {
  final VenderKycRepo venderKycRepo;

  FormController({required this.venderKycRepo,});

  // ============================================================
  // KYC STEP CONFIGURATION
  // ============================================================

  bool isLoading = false;

  static const int totalSteps = 9;
  int selectedIndex = 0;

  final List<String> headings = [
    'Basic',
    'KYC Info',
    'Business',
    'Shop',
    'Bank',
    'KYC Doc',
    'Bank Doc',
    'Selfie',
    'Review',
  ];

  final List<String> sectionKeys = [
    'basic_details',
    'document_numbers',
    'business_info',
    'shop_live',
    'bank_details',
    'kyc_documents',
    'bank_documents',
    'self_live',
    'review',
  ];

  /// Completion status for each step.
  final List<bool> completed = List<bool>.filled(totalSteps, false);

  // ============================================================
  // NAVIGATION
  // ============================================================

  void selectIndex(int index) {
    if (index < 0 || index >= totalSteps) {
      return;
    }

    selectedIndex = index;
    update();
  }

  void nextStep() {
    if (selectedIndex >= totalSteps - 1) {
      return;
    }

    completed[selectedIndex] = true;
    selectedIndex++;

    update();
  }

  void previousStep() {
    if (selectedIndex <= 0) {
      return;
    }

    selectedIndex--;

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

    if (advanceIfTrue && value && selectedIndex < totalSteps - 1) {
      selectedIndex++;
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

  bool isStepCompleted(int index) {
    if (index < 0 || index >= completed.length) {
      return false;
    }

    return completed[index];
  }

  bool get allStepsCompleted {
    return completed.every((step) => step);
  }

  // ============================================================
  // RESET
  // ============================================================

  void resetForm() {
    selectedIndex = 0;

    for (int i = 0; i < completed.length; i++) {
      completed[i] = false;
    }

    update();
  }

  void applyKycStatus() {
    final verifiedSections =
        venderKycStatusModel?.correctionRemarks?.verifiedSections ?? [];

    final bool kycDocumentGroupCompleted =
        verifiedSections.contains('self_live');

    for (int i = 0; i < completed.length; i++) {
      final String section = sectionKeys[i];

      // ----------------------------------------------------------
      // KYC DOC + BANK DOC + SELFIE
      // ----------------------------------------------------------

      if (section == 'kyc_documents' ||
          section == 'bank_documents' ||
          section == 'self_live') {
        completed[i] = kycDocumentGroupCompleted;
        continue;
      }

      // ----------------------------------------------------------
      // NORMAL SECTIONS
      // ----------------------------------------------------------

      completed[i] = verifiedSections.contains(section);
    }

    selectedIndex = getNextIncompleteStep();

    update();
  }

  int getNextIncompleteStep() {
    for (int i = 0; i < completed.length; i++) {
      if (!completed[i]) {
        return i;
      }
    }

    // Everything except review is completed.
    return totalSteps - 1;
  }

  // ============================================================
  //! Api Call
  // ============================================================

  // registration_started
  //kyc_submitted
  //correction_required
  //(approved,rejected)
  VenderKycStatusModel? venderKycStatusModel;

  Future<ResponseModel> venderKycStatus() async {
    log('----------- venderKycStatus Called ----------');

    isLoading = true;
    update();

    try {
      final response = await venderKycRepo.venderKycStatus();

      final body = response.body;

      if (response.statusCode == 200 &&
          body is Map &&
          body['status']?.toString().toLowerCase() == 'success') {
        venderKycStatusModel = VenderKycStatusModel.fromJson(
          Map<String, dynamic>.from(body),
        );

        applyKycStatus();

        return ResponseModel(
          true,
          body['message']?.toString() ?? 'KYC status fetched successfully',
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
        'ERROR AT venderKycStatus(): $e',
        stackTrace: stackTrace,
      );

      return ResponseModel(
        false,
        'Error while fetching KYC status: $e',
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  VenderKycDetails? venderKycDetails;
  Future<ResponseModel> venderKycDetail() async {
    log('----------- venderKycDetail Called ----------');

    isLoading = true;
    update();

    try {
      final response = await venderKycRepo.venderKycDetail();

      final body = response.body;

      if (response.statusCode == 200 &&
          body is Map &&
          body['status']?.toString().toLowerCase() == 'success') {
        venderKycDetails = VenderKycDetails.fromJson(
          Map<String, dynamic>.from(body["data"]),
        );

        updateDataOfKycToSection();

        return ResponseModel(
          true,
          body['message']?.toString() ??
              'venderKycDetail status fetched successfully',
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
        'ERROR AT venderKycDetail(): $e',
        stackTrace: stackTrace,
      );

      return ResponseModel(
        false,
        'Error while fetching venderKycDetail: $e',
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> updateBasicDetailsFromKyc() async {
    final basicController = Get.find<BasicController>();

    final registrationController = Get.find<RegistrationKycFromController>();

    final data = venderKycDetails;

    if (data == null) {
      return;
    }

    // ============================================================
    // BASIC DETAILS
    // ============================================================

    registrationController.firstNameController.text = data.firstName ?? '';

    registrationController.lastNameController.text = data.lastName ?? '';

    registrationController.businessNumberController.text =
        data.mobileNumber ?? '';

    registrationController.businessEmailController.text = data.email ?? '';

    registrationController.businessNameController.text = data.shopName ?? '';

    registrationController.shopAddressController.text = data.shopAddress ?? '';

    registrationController.pincodeController.text = data.pinCode ?? '';

    // ============================================================
    // LOAD STATE LIST
    // ============================================================

    await basicController.fetchStatusList();

    // ============================================================
    // FIND STATE FROM API LIST

    // ============================================================

    if ((data.state ?? '').isNotEmpty) {
      final stateMatches = basicController.statusList.where(
        (item) =>
            item.stateName?.trim().toLowerCase() ==
            data.state!.trim().toLowerCase(),
      );

      if (stateMatches.isNotEmpty) {
        final selectedState = stateMatches.first;

        registrationController.setState(selectedState);

        basicController.setSelectStateModel(
          stateName: selectedState.stateName,
        );

        // ==========================================================
        // LOAD DISTRICTS FOR SELECTED STATE
        // ==========================================================

        await basicController.fetchDistrictByState();

        // ==========================================================
        // FIND CITY / DISTRICT
        // ==========================================================

        if ((data.city ?? '').isNotEmpty) {
          final districtMatches = basicController.districtList.where(
            (item) =>
                item.districtName?.trim().toLowerCase() ==
                data.city!.trim().toLowerCase(),
          );

          if (districtMatches.isNotEmpty) {
            final selectedDistrict = districtMatches.first;

            registrationController.setDistrict(
              selectedDistrict,
            );
          }
        }
      }
    }

    registrationController.update();
    update();
  }

  void updateKycInfoFromKyc() {
    final controller = Get.find<DocumentDetailsController>();

    controller.aadhaarNumberController.text =
        venderKycDetails?.aadhaarNumber ?? '';

    controller.panNumberController.text = venderKycDetails?.panNumber ?? '';

    controller.gstNumberController.text = venderKycDetails?.gstin ?? '';

    controller.tradeLicenseNumberController.text =
        venderKycDetails?.tradeLicenceNumber ?? '';

    controller.msmeNumberController.text =
        venderKycDetails?.msmeRegistrationNumber ?? '';

    controller.update();
    update();
  }

  void updateBusinessInfoFromKyc() {
    final controller = Get.find<BusinessInformationController>();

    controller.businessCategory = venderKycDetails?.businessCategory ?? '';

    controller.natureOfBusinessController.text =
        venderKycDetails?.natureOfBusiness ?? '';

    controller.businessDescriptionController.text =
        venderKycDetails?.businessDescription ?? '';

    final date = venderKycDetails?.businessStartDate?.toLocal();

    controller.businessStartDateController.text = date != null
        ? "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"
        : '';

    controller.expectedMonthlyTransactionVolume =
        venderKycDetails?.expectedMonthlyVolume ?? '';

    controller.businessOwnershipType = venderKycDetails?.ownershipType;
  }

//*  Bank details section
  void updateBankDetailsFromKyc() {
    final controller = Get.find<BankDetailsController>();

    controller.accountNameController.text =
        venderKycDetails?.accountHolderName ?? '';

    controller.bankNameController.text = venderKycDetails?.bankName ?? '';

    controller.accountNumberController.text =
        venderKycDetails?.accountNumber ?? '';

    controller.ifscController.text = venderKycDetails?.ifscCode ?? '';

    controller.branchNameController.text = venderKycDetails?.branchName ?? '';

    controller.registeredMobileController.text =
        venderKycDetails?.bankRegisteredMobile ?? '';

    controller.setAccountType(venderKycDetails?.accountType ?? "");
    update();
    controller.update();
  }

  //* Shop verification

  void updateShopInfoFromKyc() {
    final controller = Get.find<LiveShopVerificationController>();

    controller.shopSignboardVisible = true;
    controller.locationCaptured = true;

    controller.shopLivePhotoPath =
        getRemoteImageUrl(venderKycDetails?.shopLivePhotoPath ?? "");
    log("image a of show ${venderKycDetails?.shopLivePhotoPath ?? ""}");

    update();
    controller.update();
  }

//   void updateBankDocumentsFromKyc() {
//   final controller =
//       Get.find<BankDocumentUploadController>();

//   controller.cancelledCheque =
//       getRemoteImageUrl(
//         venderKycDetails?.c,
//       );

//   controller.bankStatementPath =
//       getRemoteImageUrl(
//         venderKycDetails?.bankStatementPath,
//       );

//   controller.update();
// }

  void updateDataOfKycToSection() {
    final verifiedSections =
        venderKycStatusModel?.correctionRemarks?.verifiedSections ?? [];

    isDocSectionComplete = verifiedSections.contains('self_live');
    isShopVerifiedSectionComplete = verifiedSections.contains('shop_live');

    // ============================================================
    // BASIC
    // ============================================================

    if (verifiedSections.contains('basic_details')) {
      updateBasicDetailsFromKyc();
    }

    // ============================================================
    // KYC INFO
    // ============================================================

    if (verifiedSections.contains('document_numbers')) {
      updateKycInfoFromKyc();
    }

    // ============================================================
    // BUSINESS
    // ============================================================

    if (verifiedSections.contains('business_info')) {
      updateBusinessInfoFromKyc();
    }

    // ============================================================
    // SHOP
    // ============================================================

    // if (verifiedSections.contains('shop_live')) {
    //   updateShopInfoFromKyc();
    // }

    // ============================================================
    // BANK
    // ============================================================

    if (verifiedSections.contains('bank_details')) {
      updateBankDetailsFromKyc();
    }

    // ============================================================
    // KYC DOCUMENTS
    // ============================================================

    // if (verifiedSections.contains('kyc_documents')) {
    //
    // }

    // // ============================================================
    // // BANK DOCUMENTS
    // // ============================================================

    // if (verifiedSections.contains('bank_documents')) {
    //
    // }

    // // ============================================================
    // // SELFIE
    // // ============================================================

    // if (verifiedSections.contains('self_live')) {
    //   updateSelfieFromKyc();
    // updateKycDocumentsFromKyc();
    // updateBankDocumentsFromKyc();
    // }

    update();
  }

  String? getRemoteImageUrl(String? path) {
    if (path == null || path.trim().isEmpty) {
      return null;
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    return '${AppConstants.baseUrl}/$path';
  }

  bool isDocSectionComplete = false;
  bool isShopVerifiedSectionComplete = false;
}
