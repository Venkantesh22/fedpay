import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class BankDocumentUploadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final File? file;

  final VoidCallback onUpload;
  final VoidCallback onRemove;

  final bool isLoading;

  const BankDocumentUploadCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.file,
    required this.onUpload,
    required this.onRemove,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: file != null
              ? primaryColor
              : greyBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
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
                  file != null
                      ? Icons.check_circle_outline
                      : Icons.account_balance_outlined,
                  color: primaryColor,
                  size: 22.r,
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title,
                      style: Helper(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            fontSize: 14.sp,
                            fontWeight:
                                FontWeight.w700,
                            color: black,
                          ),
                    ),

                    SizedBox(height: 3.h),

                    CustomText(
                      subtitle,
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
            ],
          ),

          SizedBox(height: 14.h),

          // ====================================================
          // FILE SELECTED
          // ====================================================

          if (file != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: primaryColor.withValues(
                  alpha: 0.06,
                ),
                borderRadius:
                    BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    _fileIcon(file!),
                    color: primaryColor,
                    size: 22.r,
                  ),

                  SizedBox(width: 9.w),

                  Expanded(
                    child: CustomText(
                      _fileName(file!),
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight:
                            FontWeight.w600,
                        color: greyText6,
                      ),
                    ),
                  ),

                  SizedBox(width: 6.w),

                  IconButton(
                    visualDensity:
                        VisualDensity.compact,
                    onPressed: onRemove,
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20.r,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed:
                    isLoading ? null : onUpload,
                icon: isLoading
                    ? SizedBox(
                        width: 17.w,
                        height: 17.w,
                        child:
                            const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        Icons.upload_file_outlined,
                        color: primaryColor,
                        size: 19.r,
                      ),
                label: CustomText(
                  isLoading
                      ? 'Selecting...'
                      : 'Upload Document',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 13.sp,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: primaryColor,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _fileName(File file) {
    return file.path
        .split(Platform.pathSeparator)
        .last;
  }

  IconData _fileIcon(File file) {
    final extension = file.path
        .split('.')
        .last
        .toLowerCase();

    if (extension == 'pdf') {
      return Icons.picture_as_pdf_outlined;
    }

    return Icons.image_outlined;
  }
}