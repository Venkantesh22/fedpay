import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class DocumentUploadCardWidget extends StatelessWidget {
  final int index;
  final String title;
  final String subtitle;
  final File? file;
  final bool isRequired;

  final VoidCallback onUpload;
  final VoidCallback onRemove;

  const DocumentUploadCardWidget({
    super.key,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.file,
    required this.isRequired,
    required this.onUpload,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final bool uploaded = file != null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: uploaded
              ? primaryColor.withValues(alpha: 0.35)
              : grey.withValues(alpha: 0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // =====================================================
          // DOCUMENT ICON
          // =====================================================

          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              _getDocumentIcon(index),
              size: 21.r,
              color: primaryColor,
            ),
          ),

          SizedBox(width: 10.w),

          // =====================================================
          // TITLE + SUBTITLE
          // =====================================================

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: CustomText(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Helper(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                      ),
                    ),

                    if (isRequired) ...[
                      SizedBox(width: 3.w),
                      CustomText(
                        '*',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 3.h),

                CustomText(
                  uploaded
                      ? _getShortFileName(file!)
                      : subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Helper(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: uploaded
                            ? primaryColor
                            : greyDark,
                      ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // =====================================================
          // UPLOAD / REPLACE
          // =====================================================

          if (uploaded)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: onUpload,
                  borderRadius: BorderRadius.circular(7.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: CustomText(
                      'Replace',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 5.w),

                InkWell(
                  onTap: onRemove,
                  child: Icon(
                    Icons.close,
                    size: 17.r,
                    color: Colors.red,
                  ),
                ),
              ],
            )
          else
            InkWell(
              onTap: onUpload,
              borderRadius: BorderRadius.circular(7.r),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 7.h,
                ),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(7.r),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.35),
                  ),
                ),
                child: CustomText(
                  'Upload',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // =============================================================
  // DOCUMENT ICON
  // =============================================================

  IconData _getDocumentIcon(int index) {
    switch (index) {
      case 0:
      case 1:
        return Icons.badge_outlined;

      case 2:
        return Icons.credit_card_outlined;

      case 3:
        return Icons.person_outline;

      case 4:
        return Icons.description_outlined;

      case 5:
        return Icons.article_outlined;

      case 6:
        return Icons.verified_outlined;

      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  // =============================================================
  // FILE NAME
  // =============================================================

  String _getShortFileName(File file) {
    final String fileName =
        file.path.split(Platform.pathSeparator).last;

    if (fileName.length <= 22) {
      return fileName;
    }

    return '${fileName.substring(0, 18)}...';
  }
}