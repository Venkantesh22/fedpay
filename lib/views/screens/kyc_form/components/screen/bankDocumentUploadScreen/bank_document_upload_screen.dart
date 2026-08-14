import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lekra/controllers/kyc_controller/bank_document_upload_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/kyc_form/components/screen/bankDocumentUploadScreen/widget/bank_document_upload_card.dart';

class BankDocumentUploadScreen extends StatefulWidget {
  final bool isComplete;
  final ValueChanged<bool> onCompleteChanged;

  const BankDocumentUploadScreen({
    super.key,
    required this.isComplete,
    required this.onCompleteChanged,
  });

  @override
  State<BankDocumentUploadScreen> createState() =>
      _BankDocumentUploadScreenState();
}

class _BankDocumentUploadScreenState extends State<BankDocumentUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankDocumentUploadController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // TITLE
            // ==================================================

            CustomText(
              'Bank Document Upload & Verification',
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: black,
                  ),
            ),

            SizedBox(height: 4.h),

            CustomText(
              'Upload a valid bank document for account verification',
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    color: greyDark,
                  ),
            ),

            SizedBox(height: 24.h),

            // ==================================================
            // DOCUMENTS
            // ==================================================

            ...List.generate(
              controller.documentNames.length,
              (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: BankDocumentUploadCard(
                    title: controller.documentNames[index],
                    subtitle: controller.documentDescriptions[index],
                    file: controller.getDocument(index),
                    isLoading: controller.uploadingDocumentIndex == index,
                    onUpload: () {
                      controller.pickDocument(
                        index,
                      );
                    },
                    onRemove: () {
                      controller.removeDocument(
                        index,
                      );
                    },
                  ),
                );
              },
            ),

            SizedBox(height: 4.h),

            // ==================================================
            // STATUS
            // ==================================================

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: controller.isVerified
                    ? primaryColor.withValues(
                        alpha: 0.07,
                      )
                    : Colors.orange.withValues(
                        alpha: 0.07,
                      ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    controller.isVerified
                        ? Icons.verified_outlined
                        : Icons.info_outline,
                    color: controller.isVerified ? primaryColor : Colors.orange,
                    size: 19.r,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomText(
                      controller.isVerified
                          ? 'Bank document uploaded successfully.'
                          : 'Upload either a cancelled cheque or a bank statement to continue.',
                      overflow: TextOverflow.clip,
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 11.sp,
                            color: controller.isVerified
                                ? primaryColor
                                : Colors.orange,
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
                final bool valid = controller.validateBankDocuments();

                if (!valid) {
                  return;
                }

                // Navigation remains in FormController.
                widget.onCompleteChanged(true);
              },
            ),

            SizedBox(height: 20.h),
          ],
        );
      },
    );
  }
}
