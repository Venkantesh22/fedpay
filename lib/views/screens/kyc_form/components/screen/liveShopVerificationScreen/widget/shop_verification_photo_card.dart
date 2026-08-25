import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class ShopVerificationPhotoCard extends StatelessWidget {
  final File? file;
  final String? imageUrl;
  final VoidCallback onCapture;
  final VoidCallback onRemove;
  final bool isLoading;
  final IconData icon;

  const ShopVerificationPhotoCard({
    super.key,
    required this.file,
    required this.onCapture,
    required this.onRemove,
    required this.isLoading,
    required this.icon,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasLocalFile = file != null;

    final bool hasRemoteImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    final bool hasImage = hasLocalFile || hasRemoteImage;

    return Container(
      width: double.infinity,
      height: 190.h,
      decoration: BoxDecoration(
        color: greyBackGround,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: hasImage ? primaryColor : greyBorder,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? Stack(
              fit: StackFit.expand,
              children: [
                // ==================================================
                // IMAGE
                // ==================================================

                if (hasLocalFile)
                  Image.file(
                    file!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 40.r,
                          color: greyDark,
                        ),
                      );
                    },
                  )
                else if (hasRemoteImage)
                  Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (
                      context,
                      child,
                      loadingProgress,
                    ) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 40.r,
                          color: greyDark,
                        ),
                      );
                    },
                  )
                else
                  Icon(
                    icon,
                    size: 40.r,
                    color: primaryColor,
                  ),

                // ==================================================
                // REMOVE
                // ==================================================

                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: GestureDetector(
                    onTap: isLoading ? null : onRemove,
                    child: Container(
                      width: 34.w,
                      height: 34.w,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18.r,
                        color: white,
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // CAPTURED
                // ==================================================

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    color: Colors.black.withValues(
                      alpha: 0.55,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 6.w),
                        CustomText(
                          hasLocalFile ? 'Photo captured' : 'Uploaded photo',
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(
                        alpha: 0.10,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            icon,
                            size: 28.r,
                            color: primaryColor,
                          ),
                  ),
                  SizedBox(height: 12.h),
                  CustomText(
                    isLoading ? 'Opening camera...' : 'Capture Photo',
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    'Use camera to capture a live photo',
                    style: Helper(context).textTheme.bodySmall?.copyWith(
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
