import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lekra/controllers/kyc_controller/kyc_document_upload_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/kyc_form/components/screen/kyc_document_upload/widget/document_upload_card_widget.dart';

class KycDocumentUploadScreen extends StatelessWidget {
  final bool isComplete;
  final ValueChanged<bool> onCompleteChanged;

  const KycDocumentUploadScreen({
    super.key,
    required this.isComplete,
    required this.onCompleteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KycDocumentUploadController>(
      builder: (documentController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====================================================
            // TITLE
            // ====================================================

            CustomText(
              'KYC Document Upload',
              style: Helper(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
            ),

            SizedBox(height: 4.h),

            CustomText(
              'Upload clear and valid documents',
              style: Helper(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: greyDark,
                  ),
            ),

            SizedBox(height: 20.h),

            // ====================================================
            // DOCUMENT LIST
            // ====================================================

            ...List.generate(
              documentController.kycDocumentNames.length,
              (index) {
                return Padding(
                  padding:
                      EdgeInsets.only(bottom: 10.h),
                  child: DocumentUploadCardWidget(
                    index: index,
                    title:
                        documentController.kycDocumentNames[index],
                    subtitle:
                        documentController.kycDocumentDescriptions[index],
                    file:
                        documentController.kycDocuments[index],
                    isRequired:
                        documentController.isDocumentRequired(index),
                    onUpload: () {
                      documentController
                          .pickKycDocument(index);
                    },
                    onRemove: () {
                      documentController
                          .removeKycDocument(index);
                    },
                  ),
                );
              },
            ),

            SizedBox(height: 8.h),

            // ====================================================
            // UPLOAD COUNT
            // ====================================================

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: primaryColor.withValues(
                  alpha: 0.08,
                ),
                borderRadius:
                    BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18.r,
                    color: primaryColor,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomText(
                      '${documentController.uploadedDocumentCount}'
                      ' of '
                      '${documentController.totalDocuments}'
                      ' documents selected. '
                      'You can replace documents before submission.',
                      style: Helper(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            fontSize: 11.sp,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // ====================================================
            // CONTINUE
            // ====================================================

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
                final bool success =
                    documentController
                        .validateAndComplete();

                if (!success) {
                  return;
                }

                // Only navigation is handled outside
                // this screen.
                onCompleteChanged(true);
              },
            ),
          ],
        );
      },
    );
  }
}