import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lekra/controllers/kyc_controller/live_shop_verification_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/kyc_form/components/screen/liveShopVerificationScreen/widget/kyc_section_title.dart';
import 'package:lekra/views/screens/kyc_form/components/screen/liveShopVerificationScreen/widget/shop_verification_photo_card.dart';

class LiveShopVerificationScreen extends StatefulWidget {
  final bool isComplete;
  final ValueChanged<bool> onCompleteChanged;

  const LiveShopVerificationScreen({
    super.key,
    required this.isComplete,
    required this.onCompleteChanged,
  });

  @override
  State<LiveShopVerificationScreen> createState() =>
      _LiveShopVerificationScreenState();
}

class _LiveShopVerificationScreenState
    extends State<LiveShopVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveShopVerificationController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // TITLE
            // ==================================================

            CustomText(
              'Live Shop Verification',
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
            ),

            SizedBox(height: 4.h),

            CustomText(
              'Capture your shop and verify your live location',
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    color: greyDark,
                  ),
            ),

            SizedBox(height: 24.h),

            // ==================================================
            // SHOP FRONT PHOTO
            // ==================================================

            const KycSectionTitle(
              title: 'Shop Front Photo',
              subtitle: 'Capture a clear photo of your shop front',
            ),

            SizedBox(height: 12.h),

            ShopVerificationPhotoCard(
              file: controller.shopLivePhoto,
              onCapture: controller.captureShopPhoto,
              onRemove: controller.removeShopPhoto,
              isLoading: controller.isCapturingShopPhoto,
              icon: Icons.storefront_outlined,
            ),

            SizedBox(height: 22.h),

            // ==================================================
            // INSIDE SHOP PHOTO
            // ==================================================

            const KycSectionTitle(
              title: 'Inside Shop Photo',
              subtitle: 'Capture the interior of your shop',
            ),

            SizedBox(height: 12.h),

            ShopVerificationPhotoCard(
              file: controller.insideShopPhoto,
              onCapture: controller.captureInsideShopPhoto,
              onRemove: controller.removeInsideShopPhoto,
              isLoading: controller.isCapturingInsidePhoto,
              icon: Icons.store_outlined,
            ),

            SizedBox(height: 22.h),

            // ==================================================
            // SIGNBOARD
            // ==================================================

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: primaryColorLight,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(
                        alpha: 0.10,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.signpost_outlined,
                      color: primaryColor,
                      size: 21.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Shop Signboard Visible',
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: black,
                              ),
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          'Make sure your business name is clearly visible.',
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 11.sp,
                                color: greyText6,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: controller.shopSignboardVisible,
                    activeThumbColor: primaryColor,
                    onChanged: controller.setShopSignboardVisible,
                  ),
                ],
              ),
            ),

            SizedBox(height: 22.h),

            // ==================================================
            // LIVE LOCATION
            // ==================================================

            const KycSectionTitle(
              title: 'Live Location',
              subtitle:
                  'Your current location will be captured for verification',
            ),

            SizedBox(height: 12.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color:
                      controller.locationCaptured ? primaryColor : greyBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(
                            alpha: 0.10,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          controller.locationCaptured
                              ? Icons.location_on
                              : Icons.location_on_outlined,
                          color: primaryColor,
                          size: 23.r,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              controller.locationCaptured
                                  ? 'Location Captured'
                                  : 'Location Required',
                              style: Helper(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: black,
                                  ),
                            ),
                            SizedBox(height: 3.h),
                            CustomText(
                              controller.locationText,
                              style:
                                  Helper(context).textTheme.bodySmall?.copyWith(
                                        fontSize: 11.sp,
                                        color: greyText6,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        controller.captureLiveLocation(
                          context,
                        );
                      },
                      icon: Icon(
                        Icons.my_location,
                        size: 18.r,
                        color: primaryColor,
                      ),
                      label: CustomText(
                        controller.locationCaptured
                            ? 'Refresh Location'
                            : 'Capture Live Location',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: primaryColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // ==================================================
            // INFORMATION
            // ==================================================

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: primaryColor.withValues(
                  alpha: 0.07,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: primaryColor,
                    size: 18.r,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomText(
                      'Please capture the shop front clearly, '
                      'make sure the business signboard is visible, '
                      'and capture your current live location.',
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 11.sp,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // ==================================================
            // CONTINUE
            // ==================================================

            CustomButton(
              title: 'Continue',
              height: 48.h,
              radius: 8.r,
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  secondaryColor,
                ],
              ),
              onTap: () {
                final bool valid = controller.validateShopVerification();

                if (!valid) {
                  _showValidationMessage(
                    context,
                    controller,
                  );
                  return;
                }

                // Only FormController handles navigation.
                widget.onCompleteChanged(true);
              },
            ),

            SizedBox(height: 20.h),
          ],
        );
      },
    );
  }

  // ============================================================
  // VALIDATION MESSAGE
  // ============================================================

  void _showValidationMessage(
    BuildContext context,
    LiveShopVerificationController controller,
  ) {
    String message;

    if (controller.shopLivePhoto == null) {
      message = 'Please capture the shop front photo.';
    } else if (!controller.shopSignboardVisible) {
      message = 'Please confirm that the shop signboard is visible.';
    } else if (!controller.locationCaptured) {
      message = 'Please capture your live location.';
    } else {
      message = 'Please complete shop verification.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
