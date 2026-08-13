import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentDetailsController extends GetxController
    implements GetxService {
  // ============================================================
  // DOCUMENT DETAILS
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

    final tradeLicense =
        tradeLicenseNumberController.text.trim();

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
      'aadhaar_number':
          aadhaarNumberController.text.trim(),

      'pan_number':
          panNumberController.text.trim(),

      'gst_number':
          gstNumberController.text.trim(),

      'trade_license_number':
          tradeLicenseNumberController.text.trim(),

      'msme_number':
          msmeNumberController.text.trim(),
    };
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