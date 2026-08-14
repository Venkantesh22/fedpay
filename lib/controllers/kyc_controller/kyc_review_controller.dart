import 'package:get/get.dart';

class KycReviewController extends GetxController
    implements GetxService {
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

  Future<bool> submitKyc() async {
    if (!declarationAccepted) {
      return false;
    }

    try {
      setSubmitting(true);

      // ========================================================
      // TODO:
      // Call your final KYC submit API here.
      // ========================================================

      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      setSubmitting(false);

      return true;
    } catch (e) {
      setSubmitting(false);

      return false;
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