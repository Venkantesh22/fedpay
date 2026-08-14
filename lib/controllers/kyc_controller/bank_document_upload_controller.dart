import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class BankDocumentUploadController extends GetxController
    implements GetxService {
  // ============================================================
  // BANK DOCUMENTS
  // ============================================================

  File? cancelledCheque;

  File? bankStatement;

  // ============================================================
  // UPLOAD STATE
  // ============================================================

  int? uploadingDocumentIndex;

  bool get isUploading => uploadingDocumentIndex != null;

  // 0 = Cancelled Cheque
  // 1 = Bank Statement

  // ============================================================
  // DOCUMENT NAMES
  // ============================================================

  final List<String> documentNames = [
    'Cancelled Cheque',
    'Bank Statement',
  ];

  final List<String> documentDescriptions = [
    'Upload a clear cancelled cheque',
    'Upload recent bank statement',
  ];

  // ============================================================
  // PICK DOCUMENT
  // ============================================================

  Future<void> pickDocument(int index) async {
    if (index < 0 || index > 1) {
      return;
    }

    if (isUploading) {
      return;
    }

    try {
      uploadingDocumentIndex = index;
      update();

      final FilePickerResult? result =
          await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: [
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
      // FILE SIZE
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
      // SAVE DOCUMENT
      // ========================================================

      if (index == 0) {
        cancelledCheque = file;
      } else {
        bankStatement = file;
      }

      update();
    } catch (e, st) {
      log(
        'ERROR pickDocument(): $e\n$st',
      );

      Get.snackbar(
        'Upload Error',
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

  void removeDocument(int index) {
    if (index == 0) {
      cancelledCheque = null;
    } else if (index == 1) {
      bankStatement = null;
    }

    update();
  }

  // ============================================================
  // GET DOCUMENT
  // ============================================================

  File? getDocument(int index) {
    if (index == 0) {
      return cancelledCheque;
    }

    if (index == 1) {
      return bankStatement;
    }

    return null;
  }

  // ============================================================
  // DOCUMENT UPLOADED
  // ============================================================

  bool isDocumentUploaded(int index) {
    return getDocument(index) != null;
  }

  // ============================================================
  // FILE NAME
  // ============================================================

  String getFileName(int index) {
    final File? file = getDocument(index);

    if (file == null) {
      return '';
    }

    return file.path.split(
      Platform.pathSeparator,
    ).last;
  }

  // ============================================================
  // UPLOAD COUNT
  // ============================================================

  int get uploadedDocumentCount {
    int count = 0;

    if (cancelledCheque != null) {
      count++;
    }

    if (bankStatement != null) {
      count++;
    }

    return count;
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  /// Existing flow allows either:
  /// Cancelled Cheque OR Bank Statement.
  bool get isVerified {
    return cancelledCheque != null ||
        bankStatement != null;
  }

  bool validateBankDocuments() {
    if (!isVerified) {
      Get.snackbar(
        'Bank Document Required',
        'Please upload a cancelled cheque or bank statement.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }

    return true;
  }

  // ============================================================
  // REQUEST DATA
  // ============================================================

  Map<String, dynamic> toMap() {
    return {
      'cancelled_cheque':
          cancelledCheque?.path,
      'bank_statement':
          bankStatement?.path,
    };
  }

  // ============================================================
  // CLEAR
  // ============================================================

  void clearForm() {
    cancelledCheque = null;
    bankStatement = null;
    uploadingDocumentIndex = null;

    update();
  }
}