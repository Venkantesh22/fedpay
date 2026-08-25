import 'dart:developer';

import 'package:get/get.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/repositories/vender_kyc_repo.dart';

class KycReviewController extends GetxController implements GetxService {
  final VenderKycRepo venderKycRepo;

  KycReviewController({required this.venderKycRepo});

  // ============================================================
  // DECLARATION
  // ============================================================

  bool declarationAccepted = false;

  bool isSubmitting = false;

  // ============================================================
  // DECLARATION
  // ============================================================

  void setDeclarationAccepted(bool value) {
    declarationAccepted = value;
    update();
  }

  // ============================================================
  // SUBMIT STATUS
  // ============================================================

  void setSubmitting(bool value) {
    isSubmitting = value;
    update();
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  bool validateBeforeSubmit() {
    return declarationAccepted && !isSubmitting;
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  //* submit Vender kyc   venderKycBasicDetails()
  Future<ResponseModel> venderKycFinalSubmit() async {
    log('----------- venderKycBasicDetails Called ----------');

    setSubmitting(true);

    update();

    try {
      final Map<String, dynamic> data = {
        "declaration_accepted": declarationAccepted
      };

      final response = await venderKycRepo.venderKycFinalSubmit(
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
              'venderKycFinalSubmit submitted successfully',
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
        'ERROR AT venderKycFinalSubmit(): $e',
        stackTrace: stackTrace,
      );

      return ResponseModel(
        false,
        'Error while submitting venderKycFinalSubmit(): $e',
      );
    } finally {
      setSubmitting(false);
      update();
    }
  }


  // ============================================================
  // CLEAR
  // ============================================================

  void clearForm() {
    declarationAccepted = false;
    isSubmitting = false;

    update();
  }
}
