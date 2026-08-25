import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/repositories/vender_kyc_repo.dart';

class DocumentDetailsController extends GetxController implements GetxService {
  final VenderKycRepo venderKycRepo;
  DocumentDetailsController({required this.venderKycRepo});

  bool isLoading = false;

  // ============================================================
  // DOCUMENT DETAILS
  // ============================================================

  final TextEditingController aadhaarNumberController = TextEditingController();

  final TextEditingController panNumberController = TextEditingController();

  final TextEditingController gstNumberController = TextEditingController();

  final TextEditingController tradeLicenseNumberController =
      TextEditingController();

  final TextEditingController msmeNumberController = TextEditingController();

  // ============================================================
  // VALIDATION
  // ============================================================

  bool validateDocumentDetails() {
    // ----------------------------
    // Aadhaar
    // ----------------------------

    final aadhaar = aadhaarNumberController.text.trim();

    if (aadhaar.isEmpty) {
      return false;
    }

    if (aadhaar.length != 12) {
      return false;
    }

    // ----------------------------
    // PAN
    // ----------------------------

    final pan = panNumberController.text.trim();

    if (pan.isEmpty) {
      return false;
    }

    // ----------------------------
    // GST
    // ----------------------------

    final gst = gstNumberController.text.trim();

    if (gst.isEmpty) {
      return false;
    }

    // ----------------------------
    // Trade Licence
    // ----------------------------

    final tradeLicense = tradeLicenseNumberController.text.trim();

    if (tradeLicense.isEmpty) {
      return false;
    }

    // ----------------------------
    // MSME
    // ----------------------------

    final msme = msmeNumberController.text.trim();

    if (msme.isEmpty) {
      return false;
    }

    return true;
  }

  // ============================================================
  // FORM DATA
  // ============================================================

  Map<String, dynamic> toMap() {
    return {
      'aadhaar_number': aadhaarNumberController.text.trim(),
      'pan_number': panNumberController.text.trim(),
      'gst_number': gstNumberController.text.trim(),
      'trade_license_number': tradeLicenseNumberController.text.trim(),
      'msme_number': msmeNumberController.text.trim(),
    };
  }

  //* submit Vender kyc document details   venderKycDocumentDetails()
  Future<ResponseModel> venderKycDocumentDetails() async {
    log('----------- venderKycDocumentDetails Called ----------');

    isLoading = true;
    update();

    try {
      final Map<String, dynamic> data = {
        "section": "document_numbers",
        "aadhaar_number": aadhaarNumberController.text.trim(),
        "pan_number": panNumberController.text.trim(),
        "gstin": gstNumberController.text.trim(),
        "trade_licence_number": tradeLicenseNumberController.text.trim(),
        "msme_registration_number": msmeNumberController.text.trim(),
      };

      final response = await venderKycRepo.venderKycDocumentDetails(
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
              'venderKycDocumentDetails() details submitted successfully',
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
        'ERROR AT venderKycDocumentDetails(): $e',
        stackTrace: stackTrace,
      );

      return ResponseModel(
        false,
        'Error while submitting venderKycDocumentDetails details: $e',
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
    aadhaarNumberController.clear();
    panNumberController.clear();
    gstNumberController.clear();
    tradeLicenseNumberController.clear();
    msmeNumberController.clear();

    update();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    aadhaarNumberController.dispose();
    panNumberController.dispose();
    gstNumberController.dispose();
    tradeLicenseNumberController.dispose();
    msmeNumberController.dispose();

    super.onClose();
  }
}
