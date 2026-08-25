import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/repositories/vender_kyc_repo.dart';

class KycDocumentUploadController extends GetxController
    implements GetxService {
  final VenderKycRepo venderKycRepo;

  KycDocumentUploadController({required this.venderKycRepo});

  // ============================================================
  // DOCUMENT CONFIGURATION
  // ============================================================

  bool isLoading = false;

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

  bool get isUploadingDocument => uploadingDocumentIndex != null;

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
    if (index < 0 || index >= kycDocuments.length) {
      return;
    }

    kycDocuments[index] = null;

    update();
  }

  // ============================================================
  // DOCUMENT STATUS
  // ============================================================

  bool isDocumentUploaded(int index) {
    if (index < 0 || index >= kycDocuments.length) {
      return false;
    }

    return kycDocuments[index] != null;
  }

  // ============================================================
  // FILE NAME
  // ============================================================

  String getDocumentFileName(int index) {
    if (index < 0 || index >= kycDocuments.length) {
      return '';
    }

    final File? file = kycDocuments[index];

    if (file == null) {
      return '';
    }

    return file.path
        .split(
          Platform.pathSeparator,
        )
        .last;
  }

  // ============================================================
  // DOCUMENT COUNT
  // ============================================================

  int get uploadedDocumentCount {
    return kycDocuments.where((file) => file != null).length;
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
      if (isDocumentRequired(i) && kycDocuments[i] == null) {
        return false;
      }
    }

    return true;
  }

  // ============================================================
  // COMPLETE SCREEN
  // ============================================================

  bool validateAndComplete() {
    return allRequiredDocumentsUploaded;
  }

  // ============================================================
  // CLEAR FORM
  // ============================================================

  void clearForm() {
    for (int i = 0; i < kycDocuments.length; i++) {
      kycDocuments[i] = null;
    }

    uploadingDocumentIndex = null;

    update();
  }

  // ============================================================
  // Call Api
  // ============================================================

  //* submit Vender kyc Document upload  venderKycKYCDocUpload()
  Future<ResponseModel> venderKycKYCDocUpload({
    required File? cancelledChequeImage,
    required File? bankStatementImage,
    required File? liveSelfieImage,
  }) async {
    log('----------- venderKycKYCDocUpload Called ----------');

    isLoading = true;
    update();

    try {
      // ----------------------------------------------------------
      // CHECK REQUIRED DOCUMENTS
      // ----------------------------------------------------------

      if (!allRequiredDocumentsUploaded) {
        return ResponseModel(
          false,
          'Please upload all required documents.',
        );
      }

      // ----------------------------------------------------------
      // LOG SELECTED DOCUMENTS
      // ----------------------------------------------------------

      for (int i = 0; i < kycDocuments.length; i++) {
        final file = kycDocuments[i];

        log(
          '[KYC DOCUMENT] '
          '${kycDocumentNames[i]} '
          '=> ${file?.path ?? 'NOT SELECTED'}',
        );
      }

      log(
        '[EXTRA DOCUMENT] cancelled_cheque => '
        '${cancelledChequeImage?.path ?? 'NOT SELECTED'}',
      );

      log(
        '[EXTRA DOCUMENT] bank_statement => '
        '${bankStatementImage?.path ?? 'NOT SELECTED'}',
      );

      log(
        '[EXTRA DOCUMENT] self_live_photo => '
        '${liveSelfieImage?.path ?? 'NOT SELECTED'}',
      );

      // ----------------------------------------------------------
      // BUILD MULTIPART DATA
      // ----------------------------------------------------------

      final Map<String, dynamic> data = {};

      // 1. Aadhaar Front
      if (kycDocuments[0] != null) {
        data['aadhaar_front'] = MultipartFile(
          kycDocuments[0]!.path,
          filename: _getFileName(kycDocuments[0]!),
        );
      }

      // 2. Aadhaar Back
      if (kycDocuments[1] != null) {
        data['aadhaar_back'] = MultipartFile(
          kycDocuments[1]!.path,
          filename: _getFileName(kycDocuments[1]!),
        );
      }

      // 3. PAN Card
      if (kycDocuments[2] != null) {
        data['pan_card'] = MultipartFile(
          kycDocuments[2]!.path,
          filename: _getFileName(kycDocuments[2]!),
        );
      }

      // 4. Passport Photo
      if (kycDocuments[3] != null) {
        data['passport_photo'] = MultipartFile(
          kycDocuments[3]!.path,
          filename: _getFileName(kycDocuments[3]!),
        );
      }

      // 5. GST Certificate
      if (kycDocuments[4] != null) {
        data['gst_certificate'] = MultipartFile(
          kycDocuments[4]!.path,
          filename: _getFileName(kycDocuments[4]!),
        );
      }

      // 6. Trade Licence
      if (kycDocuments[5] != null) {
        data['trade_licence'] = MultipartFile(
          kycDocuments[5]!.path,
          filename: _getFileName(kycDocuments[5]!),
        );
      }

      // 7. MSME Certificate
      if (kycDocuments[6] != null) {
        data['msme_certificate'] = MultipartFile(
          kycDocuments[6]!.path,
          filename: _getFileName(kycDocuments[6]!),
        );
      }

      // 8. Cancelled Cheque
      if (cancelledChequeImage != null) {
        data['cancelled_cheque'] = MultipartFile(
          cancelledChequeImage.path,
          filename: _getFileName(cancelledChequeImage),
        );
      }

      // 9. Bank Statement
      if (bankStatementImage != null) {
        data['bank_statement'] = MultipartFile(
          bankStatementImage.path,
          filename: _getFileName(bankStatementImage),
        );
      }

      // 10. Live Selfie
      if (liveSelfieImage != null) {
        data['self_live_photo'] = MultipartFile(
          liveSelfieImage.path,
          filename: _getFileName(liveSelfieImage),
        );
      }

      // ----------------------------------------------------------
      // LOG ALL KEYS BEFORE FORM DATA
      // ----------------------------------------------------------

      log('========== KYC MULTIPART REQUEST ==========');

      log('Total keys: ${data.length}');

      log(
        'Keys being sent: '
        '${data.keys.toList()}',
      );

      for (final entry in data.entries) {
        final value = entry.value;

        if (value is MultipartFile) {
          log(
            'KEY: ${entry.key} | '
            'FILE: ${value.filename}',
          );
        } else {
          log(
            'KEY: ${entry.key} | '
            'VALUE: $value',
          );
        }
      }

      log('==========================================');

      // ----------------------------------------------------------
      // CREATE FORM DATA
      // ----------------------------------------------------------

      final FormData formData = FormData(data);

      // ----------------------------------------------------------
      // LOG FORMDATA FIELDS
      // ----------------------------------------------------------

      log('========== FORM DATA FIELDS ==========');

      for (final field in formData.fields) {
        log(
          'FIELD KEY: ${field.key} | '
          'VALUE: ${field.value}',
        );
      }

      log('======================================');

      // ----------------------------------------------------------
      // LOG FORMDATA FILES
      // ----------------------------------------------------------

      log('========== FORM DATA FILES ==========');

      for (final file in formData.files) {
        log(
          'FILE KEY: ${file.key} | '
          'FILENAME: ${file.value.filename}',
        );
      }

      log('=====================================');

      // ----------------------------------------------------------
      // API CALL
      // ----------------------------------------------------------

      final response = await venderKycRepo.venderKycKYCDocUpload(
        data: formData,
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
          body['message']?.toString() ?? 'KYC documents uploaded successfully',
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
        'ERROR AT venderKycKYCDocUpload(): $e',
        stackTrace: stackTrace,
      );

      return ResponseModel(
        false,
        'Error while uploading KYC documents: $e',
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  String _getFileName(File? file) {
    return file?.path.split(Platform.pathSeparator).last ?? "";
  }
}
