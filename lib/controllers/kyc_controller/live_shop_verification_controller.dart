import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lekra/controllers/permission_controller.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/repositories/vender_kyc_repo.dart';

class LiveShopVerificationController extends GetxController
    implements GetxService {
  final VenderKycRepo venderKycRepo;

  LiveShopVerificationController({required this.venderKycRepo});

  bool isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();

  // ============================================================
  // SHOP PHOTOS
  // ============================================================

  File? shopLivePhoto;

  File? insideShopPhoto;

  // ============================================================
  // VERIFICATION STATUS
  // ============================================================

  bool shopSignboardVisible = false;

  bool locationCaptured = false;

  DateTime? capturedAt;

  String? shopLivePhotoPath;
  String? insideShopPhotoPath;

  // ============================================================
  // LOCATION
  // ============================================================

  double? get latitude {
    return Get.find<PermissionController>().latitude;
  }

  double? get longitude {
    return Get.find<PermissionController>().longitude;
  }

  // ============================================================
  // CAMERA
  // ============================================================

  bool isCapturingShopPhoto = false;

  bool isCapturingInsidePhoto = false;

  // ============================================================
  // CAPTURE SHOP PHOTO
  // ============================================================

  Future<void> captureShopPhoto() async {
    if (isCapturingShopPhoto) {
      return;
    }

    try {
      isCapturingShopPhoto = true;
      update();

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      shopLivePhoto = File(image.path);

      // Remove old server image from UI.
      shopLivePhotoPath = null;

      capturedAt = DateTime.now();

      update();
    } catch (e) {
      Get.snackbar(
        'Camera Error',
        'Unable to capture shop photo.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCapturingShopPhoto = false;
      update();
    }
  }

  // ============================================================
  // CAPTURE INSIDE SHOP PHOTO
  // ============================================================

  Future<void> captureInsideShopPhoto() async {
    if (isCapturingInsidePhoto) {
      return;
    }

    try {
      isCapturingInsidePhoto = true;
      update();

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      insideShopPhoto = File(image.path);

      update();
    } catch (e) {
      Get.snackbar(
        'Camera Error',
        'Unable to capture inside shop photo.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCapturingInsidePhoto = false;
      update();
    }
  }

  // ============================================================
  // REMOVE PHOTOS
  // ============================================================

  void removeShopPhoto() {
    shopLivePhoto = null;
    shopLivePhotoPath = null;
    update();
  }

  void removeInsideShopPhoto() {
    insideShopPhoto = null;
    insideShopPhotoPath = null;
    update();
  }

  // ============================================================
  // SHOP SIGNBOARD
  // ============================================================

  void setShopSignboardVisible(bool value) {
    shopSignboardVisible = value;
    update();
  }

  // ============================================================
  // LOCATION
  // ============================================================

  Future<bool> captureLiveLocation(
    BuildContext context,
  ) async {
    final PermissionController permissionController =
        Get.find<PermissionController>();

    final bool success =
        await permissionController.requestLocationPermissionAndFetch(context);

    if (!success) {
      locationCaptured = false;
      update();
      return false;
    }

    locationCaptured = permissionController.latitude != null &&
        permissionController.longitude != null;

    update();

    return locationCaptured;
  }

  // ============================================================
  // LOCATION STRING
  // ============================================================

  String get locationText {
    final lat = latitude;
    final lng = longitude;

    if (lat == null || lng == null) {
      return 'Location not captured';
    }

    return '${lat.toStringAsFixed(6)}, '
        '${lng.toStringAsFixed(6)}';
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  bool validateShopVerification() {
    if (shopLivePhoto == null) {
      return false;
    }

    if (!shopSignboardVisible) {
      return false;
    }

    if (!locationCaptured) {
      return false;
    }

    return true;
  }

  // ============================================================
  //! Api Call
  // ============================================================

  //* submit Vender Live shop verification  venderKycLiveShopVerification()
  Future<ResponseModel> venderKycLiveShopVerification() async {
    log('----------- venderKycLiveShopVerification Called ----------');

    isLoading = true;
    update();

    try {
      final response = await venderKycRepo.venderKycLiveShopVerification(
        documentType: 'shop_live_photo',
        latitude: latitude!.toString(),
        longitude: longitude!.toString(),
        documentFilePath: shopLivePhoto!.path,
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
              'venderKycLiveShopVerification submitted successfully',
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
        'ERROR AT venderKycLiveShopVerification(): $e',
        stackTrace: stackTrace,
      );

      return ResponseModel(
        false,
        'Error while submitting venderKycLiveShopVerification(): $e',
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  // ============================================================
  // CLEAR
  // ============================================================

  void clearForm() {
    shopLivePhoto = null;
    insideShopPhoto = null;
    shopSignboardVisible = false;
    locationCaptured = false;
    capturedAt = null;

    update();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    super.onClose();
  }
}
