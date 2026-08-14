import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class SelfVerificationPhotoCard extends StatelessWidget {
  final File? file;
  final VoidCallback onCapture;
  final VoidCallback onRemove;
  final bool isLoading;

  const SelfVerificationPhotoCard({
    super.key,
    required this.file,
    required this.onCapture,
    required this.onRemove,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 270.h,
      decoration: BoxDecoration(
        color: greyBackGround,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: file != null
              ? primaryColor
              : greyBorder,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: file != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  file!,
                  fit: BoxFit.cover,
                ),

                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(
                          alpha: 0.55,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20.r,
                        color: white,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    color: Colors.black.withValues(
                      alpha: 0.55,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 19,
                        ),
                        SizedBox(width: 7.w),
                        CustomText(
                          'Live photo captured',
                          style: TextStyle(
                            color: white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: isLoading ? null : onCapture,
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72.w,
                    height: 72.w,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(
                        alpha: 0.10,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 28.w,
                            height: 28.w,
                            child:
                                const CircularProgressIndicator(
                              strokeWidth: 2.5,
                            ),
                          )
                        : Icon(
                            Icons.face_retouching_natural,
                            size: 36.r,
                            color: primaryColor,
                          ),
                  ),

                  SizedBox(height: 16.h),

                  CustomText(
                    isLoading
                        ? 'Opening camera...'
                        : 'Take Live Selfie',
                    style: Helper(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                  ),

                  SizedBox(height: 5.h),

                  CustomText(
                    'Use the front camera and look directly at the camera',
                    textAlign: TextAlign.center,
                    style: Helper(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          fontSize: 11.sp,
                          color: greyText6,
                        ),
                  ),
                ],
              ),
            ),
    );
  }
}