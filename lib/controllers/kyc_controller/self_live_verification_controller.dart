import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SelfLiveVerificationController extends GetxController
    implements GetxService {
  final ImagePicker _imagePicker = ImagePicker();

  // ============================================================
  // SELF PHOTO
  // ============================================================

  File? selfLivePhoto;

  DateTime? capturedAt;

  // ============================================================
  // VERIFICATION STATUS
  // ============================================================

  bool livenessCompleted = false;

  bool photoToKycMatched = false;

  // ============================================================
  // LOADING
  // ============================================================

  bool isCapturing = false;

  bool isVerifying = false;

  // ============================================================
  // CAPTURE SELFIE
  // ============================================================

  Future<void> captureSelfLivePhoto() async {
    if (isCapturing) {
      return;
    }

    try {
      isCapturing = true;
      update();

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
        preferredCameraDevice: CameraDevice.front,
      );

      if (image == null) {
        return;
      }

      selfLivePhoto = File(image.path);
      capturedAt = DateTime.now();

      // New photo requires verification again.
      livenessCompleted = false;
      photoToKycMatched = false;

      update();
    } catch (e, st) {
      log(
        'ERROR captureSelfLivePhoto(): $e\n$st',
      );

      Get.snackbar(
        'Camera Error',
        'Unable to capture your live photo.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCapturing = false;
      update();
    }
  }

  // ============================================================
  // REMOVE PHOTO
  // ============================================================

  void removeSelfPhoto() {
    selfLivePhoto = null;
    capturedAt = null;

    livenessCompleted = false;
    photoToKycMatched = false;

    update();
  }

  // ============================================================
  // LIVENESS
  // ============================================================

  void setLivenessCompleted(bool value) {
    livenessCompleted = value;
    update();
  }

  // ============================================================
  // KYC PHOTO MATCH
  // ============================================================

  void setPhotoToKycMatched(bool value) {
    photoToKycMatched = value;
    update();
  }

  // ============================================================
  // RUN VERIFICATION
  // ============================================================

  Future<bool> verifySelfie() async {
    if (selfLivePhoto == null) {
      return false;
    }

    try {
      isVerifying = true;
      update();

      // ----------------------------------------------------------
      // Add your actual liveness / face-match API here later.
      // ----------------------------------------------------------

      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      // Temporary local success.
      livenessCompleted = true;
      photoToKycMatched = true;

      isVerifying = false;
      update();

      return true;
    } catch (e, st) {
      log(
        'ERROR verifySelfie(): $e\n$st',
      );

      isVerifying = false;
      update();

      return false;
    }
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  bool validateSelfVerification() {
    if (selfLivePhoto == null) {
      return false;
    }

    if (!livenessCompleted) {
      return false;
    }

    if (!photoToKycMatched) {
      return false;
    }

    return true;
  }

  // ============================================================
  // PHOTO NAME
  // ============================================================

  String get photoFileName {
    if (selfLivePhoto == null) {
      return '';
    }

    return selfLivePhoto!.path.split(
      Platform.pathSeparator,
    ).last;
  }

  // ============================================================
  // REQUEST DATA
  // ============================================================

  Map<String, dynamic> toMap() {
    return {
      'self_live_photo':
          selfLivePhoto?.path,
      'liveness_completed':
          livenessCompleted,
      'photo_to_kyc_matched':
          photoToKycMatched,
      'self_captured_at':
          capturedAt?.toIso8601String(),
    };
  }

  // ============================================================
  // CLEAR
  // ============================================================

  void clearForm() {
    selfLivePhoto = null;
    capturedAt = null;
    livenessCompleted = false;
    photoToKycMatched = false;
    isCapturing = false;
    isVerifying = false;

    update();
  }
}