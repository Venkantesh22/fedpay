import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lekra/controllers/kyc_controller/self_live_verification_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/kyc_form/components/screen/selfLiveVerificationScreen/widget/self_verification_photo_card.dart';

class SelfLiveVerificationScreen extends StatefulWidget {
  final bool isComplete;
  final ValueChanged<bool> onCompleteChanged;

  const SelfLiveVerificationScreen({
    super.key,
    required this.isComplete,
    required this.onCompleteChanged,
  });

  @override
  State<SelfLiveVerificationScreen> createState() =>
      _SelfLiveVerificationScreenState();
}

class _SelfLiveVerificationScreenState
    extends State<SelfLiveVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelfLiveVerificationController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // TITLE
            // ==================================================

            CustomText(
              'Self Live Verification',
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
            ),

            SizedBox(height: 4.h),

            CustomText(
              'Capture a live selfie to verify your identity',
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    color: greyDark,
                  ),
            ),

            SizedBox(height: 24.h),

            // ==================================================
            // SELFIE PHOTO
            // ==================================================

            CustomText(
              'Live Selfie',
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: black,
                  ),
            ),

            SizedBox(height: 4.h),

            CustomText(
              'Make sure your face is clearly visible',
              style: Helper(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11.sp,
                    color: greyText6,
                  ),
            ),

            SizedBox(height: 12.h),

            SelfVerificationPhotoCard(
              file: controller.selfLivePhoto,
              onCapture: controller.captureSelfLivePhoto,
              onRemove: controller.removeSelfPhoto,
              isLoading: controller.isCapturing,
            ),

            SizedBox(height: 22.h),

            // ==================================================
            // VERIFICATION CHECKLIST
            // ==================================================

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: primaryColorLight,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: primaryColor.withValues(
                    alpha: 0.15,
                  ),
                ),
              ),
              child: Column(
                children: [
                  _verificationRow(
                    context,
                    title: 'Live photo captured',
                    completed: controller.selfLivePhoto != null,
                    icon: Icons.camera_alt_outlined,
                  ),
                  SizedBox(height: 12.h),
                  _verificationRow(
                    context,
                    title: 'Liveness verified',
                    completed: controller.livenessCompleted,
                    icon: Icons.face_outlined,
                  ),
                  SizedBox(height: 12.h),
                  _verificationRow(
                    context,
                    title: 'Matched with KYC photo',
                    completed: controller.photoToKycMatched,
                    icon: Icons.verified_user_outlined,
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
                      'Remove sunglasses, face the camera directly, '
                      'and make sure you are in a well-lit place.',
                      overflow: TextOverflow.clip,
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
            // VERIFY BUTTON
            // ==================================================

            if (controller.selfLivePhoto != null &&
                (!controller.livenessCompleted ||
                    !controller.photoToKycMatched))
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: controller.isVerifying
                      ? null
                      : () async {
                          await controller.verifySelfie();
                        },
                  icon: controller.isVerifying
                      ? SizedBox(
                          width: 17.w,
                          height: 17.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          Icons.verified_outlined,
                          color: primaryColor,
                          size: 18.r,
                        ),
                  label: CustomText(
                    controller.isVerifying ? 'Verifying...' : 'Verify Selfie',
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

            SizedBox(height: 16.h),

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
                final bool valid = controller.validateSelfVerification();

                if (!valid) {
                  _showValidationMessage(
                    context,
                    controller,
                  );
                  return;
                }

                widget.onCompleteChanged(true);
              },
            ),

            SizedBox(height: 20.h),
          ],
        );
      },
    );
  }

  Widget _verificationRow(
    BuildContext context, {
    required String title,
    required bool completed,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: completed
                ? primaryColor.withValues(alpha: 0.12)
                : greyBackGround,
            shape: BoxShape.circle,
          ),
          child: Icon(
            completed ? Icons.check_rounded : icon,
            color: completed ? primaryColor : greyDark,
            size: 19.r,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: CustomText(
            title,
            style: Helper(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  fontWeight: completed ? FontWeight.w600 : FontWeight.w500,
                  color: completed ? black : greyText6,
                ),
          ),
        ),
        if (completed)
          Icon(
            Icons.check_circle,
            color: primaryColor,
            size: 19.r,
          ),
      ],
    );
  }

  void _showValidationMessage(
    BuildContext context,
    SelfLiveVerificationController controller,
  ) {
    String message;

    if (controller.selfLivePhoto == null) {
      message = 'Please capture your live selfie.';
    } else if (!controller.livenessCompleted) {
      message = 'Please complete liveness verification.';
    } else if (!controller.photoToKycMatched) {
      message = 'Your selfie has not been matched with KYC.';
    } else {
      message = 'Please complete self verification.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
