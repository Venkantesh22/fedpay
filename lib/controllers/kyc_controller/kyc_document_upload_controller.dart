import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class KycDocumentUploadController extends GetxController
    implements GetxService {
  // ============================================================
  // DOCUMENT CONFIGURATION
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

  // ============================================================
  // SELECTED FILES
  // ============================================================

  final List<File?> kycDocuments = List<File?>.filled(
    7,
    null,
  );

  // ============================================================
  // UPLOADING STATE
  // ============================================================

  int? uploadingDocumentIndex;

  bool get isUploadingDocument =>
      uploadingDocumentIndex != null;

  // ============================================================
  // PICK DOCUMENT
  // ============================================================

  Future<void> pickKycDocument(int index) async {
    if (index < 0 || index >= kycDocuments.length) {
      return;
    }

    if (isUploadingDocument) {
      return;
    }

    try {
      uploadingDocumentIndex = index;
      update();

      final bool isPassportPhoto = index == 3;

      final FilePickerResult? result =
          await FilePicker.platform.pickFiles(
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

      // ========================================================
      // FILE SIZE VALIDATION
      // ========================================================

      const int maxFileSize = 10 * 1024 * 1024;

      final int fileSize = await file.length();

      if (fileSize > maxFileSize) {
        Get.snackbar(
          'File too large',
          'Please select a file smaller than 10 MB.',
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      // ========================================================
      // SAVE FILE
      // ========================================================

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
    } finally {
      uploadingDocumentIndex = null;
      update();
    }
  }

  // ============================================================
  // REMOVE DOCUMENT
  // ============================================================

  void removeKycDocument(int index) {
    if (index < 0 ||
        index >= kycDocuments.length) {
      return;
    }

    kycDocuments[index] = null;

    update();
  }

  // ============================================================
  // DOCUMENT STATUS
  // ============================================================

  bool isDocumentUploaded(int index) {
    if (index < 0 ||
        index >= kycDocuments.length) {
      return false;
    }

    return kycDocuments[index] != null;
  }

  // ============================================================
  // FILE NAME
  // ============================================================

  String getDocumentFileName(int index) {
    if (index < 0 ||
        index >= kycDocuments.length) {
      return '';
    }

    final File? file = kycDocuments[index];

    if (file == null) {
      return '';
    }

    return file.path.split(
      Platform.pathSeparator,
    ).last;
  }

  // ============================================================
  // DOCUMENT COUNT
  // ============================================================

  int get uploadedDocumentCount {
    return kycDocuments
        .where((file) => file != null)
        .length;
  }

  int get totalDocuments {
    return kycDocuments.length;
  }

  // ============================================================
  // REQUIRED DOCUMENTS
  // ============================================================

  bool isDocumentRequired(int index) {
    // First 4 are currently required.
    return index >= 0 && index <= 3;
  }

  // ============================================================
  // CHECK REQUIRED DOCUMENTS
  // ============================================================

  bool get allRequiredDocumentsUploaded {
    for (int i = 0; i < kycDocuments.length; i++) {
      if (isDocumentRequired(i) &&
          kycDocuments[i] == null) {
        return false;
      }
    }

    return true;
  }

  // ============================================================
  // COMPLETE SCREEN
  // ============================================================

  bool validateAndComplete() {
    if (!allRequiredDocumentsUploaded) {
      Get.snackbar(
        'Documents Required',
        'Please upload all required documents.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }

    return true;
  }

  // ============================================================
  // CLEAR FORM
  // ============================================================

  void clearForm() {
    for (int i = 0;
        i < kycDocuments.length;
        i++) {
      kycDocuments[i] = null;
    }

    uploadingDocumentIndex = null;

    update();
  }
}