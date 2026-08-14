import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lekra/controllers/permission_controller.dart';

class LiveShopVerificationController extends GetxController
    implements GetxService {
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
    update();
  }

  void removeInsideShopPhoto() {
    insideShopPhoto = null;
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

    final bool success = await permissionController
        .requestLocationPermissionAndFetch(context);

    if (!success) {
      locationCaptured = false;
      update();
      return false;
    }

    locationCaptured =
        permissionController.latitude != null &&
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
  // FORM DATA
  // ============================================================

  Map<String, dynamic> toMap() {
    return {
      'shop_latitude': latitude,
      'shop_longitude': longitude,
      'shop_signboard_visible': shopSignboardVisible,
      'shop_captured_at':
          capturedAt?.toIso8601String(),
      'shop_live_photo':
          shopLivePhoto?.path,
      'inside_shop_photo':
          insideShopPhoto?.path,
    };
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