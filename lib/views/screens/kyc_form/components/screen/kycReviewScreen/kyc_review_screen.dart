import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dashboard_controller.dart';

import 'package:lekra/controllers/kyc_controller/bank_details_controller.dart';
import 'package:lekra/controllers/kyc_controller/business_information_controller.dart';
import 'package:lekra/controllers/kyc_controller/document_details_controller.dart';
import 'package:lekra/controllers/kyc_controller/kyc_review_controller.dart';
import 'package:lekra/controllers/kyc_controller/kyc_document_upload_controller.dart';
import 'package:lekra/controllers/kyc_controller/live_shop_verification_controller.dart';
import 'package:lekra/controllers/kyc_controller/registration_kyc_form_controller.dart';
import 'package:lekra/controllers/kyc_controller/self_live_verification_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/kyc_form/components/screen/kycReviewScreen/widget/review_section_card.dart';
import 'package:lekra/views/screens/kyc_form/components/screen/kycSubmittedSuccessScreen/kyc_submitted_success_screen.dart';

class KycReviewScreen extends StatelessWidget {
  final bool isComplete;
  final ValueChanged<bool> onCompleteChanged;

  /// Callback used when the user taps Edit.
  ///
  /// 0 = Registration
  /// 1 = Documents
  /// 2 = Document Details
  /// 3 = Business
  /// 4 = Shop
  /// 5 = Selfie
  /// 6 = Bank
  /// 7 = Bank Document
  final ValueChanged<int> onEdit;

  const KycReviewScreen({
    super.key,
    required this.isComplete,
    required this.onCompleteChanged,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KycReviewController>(
      builder: (reviewController) {
        final registrationController =
            Get.find<RegistrationKycFromController>();

        final documentUploadController =
            Get.find<KycDocumentUploadController>();

        final documentDetailsController = Get.find<DocumentDetailsController>();

        final businessController = Get.find<BusinessInformationController>();

        final shopController = Get.find<LiveShopVerificationController>();

        final selfieController = Get.find<SelfLiveVerificationController>();

        final bankController = Get.find<BankDetailsController>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // TITLE
            // ==================================================

            CustomText(
              'Review Your Details',
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: black,
                  ),
            ),

            SizedBox(height: 4.h),

            CustomText(
              'Please review all details before submitting your KYC',
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    color: greyDark,
                  ),
            ),

            SizedBox(height: 20.h),

            // ==================================================
            // REGISTRATION
            // ==================================================

            ReviewSectionCard(
              title: 'Basic & Shop Details',
              icon: Icons.person_outline,
              onEdit: () => onEdit(0),
              items: [
                ReviewItem(
                  label: 'First Name',
                  value: registrationController.firstNameController.text,
                ),
                ReviewItem(
                  label: 'Last Name',
                  value: registrationController.lastNameController.text,
                ),
                ReviewItem(
                  label: 'Mobile Number',
                  value: registrationController.businessNumberController.text,
                ),
                ReviewItem(
                  label: 'Email',
                  value: registrationController.businessEmailController.text,
                ),
                ReviewItem(
                  label: 'Business Name',
                  value: registrationController.businessNameController.text,
                ),
                ReviewItem(
                  label: 'City',
                  value: registrationController.cityController.text,
                ),
                ReviewItem(
                  label: 'PIN Code',
                  value: registrationController.pincodeController.text,
                ),
              ],
            ),

            // ==================================================
            // KYC DOCUMENTS
            // ==================================================

            ReviewSectionCard(
              title: 'KYC Documents',
              icon: Icons.description_outlined,
              onEdit: () => onEdit(1),
              items: [
                ReviewItem(
                  label: 'Documents Uploaded',
                  value: '${documentUploadController.uploadedDocumentCount}',
                ),
                ReviewItem(
                  label: 'Total Documents',
                  value: '${documentUploadController.totalDocuments}',
                ),
                ReviewItem(
                  label: 'Status',
                  value: documentUploadController.allRequiredDocumentsUploaded
                      ? 'Completed'
                      : 'Incomplete',
                ),
              ],
            ),

            // ==================================================
            // DOCUMENT DETAILS
            // ==================================================

            ReviewSectionCard(
              title: 'Document Details',
              icon: Icons.badge_outlined,
              onEdit: () => onEdit(2),
              items: [
                ReviewItem(
                  label: 'Aadhaar',
                  value: _maskNumber(
                    documentDetailsController.aadhaarNumberController.text,
                  ),
                ),
                ReviewItem(
                  label: 'PAN',
                  value: documentDetailsController.panNumberController.text,
                ),
                ReviewItem(
                  label: 'GSTIN',
                  value: documentDetailsController.gstNumberController.text,
                ),
                ReviewItem(
                  label: 'Trade Licence',
                  value: documentDetailsController
                      .tradeLicenseNumberController.text,
                ),
                ReviewItem(
                  label: 'MSME / Udyam',
                  value: documentDetailsController.msmeNumberController.text,
                ),
              ],
            ),

            // ==================================================
            // BUSINESS INFORMATION
            // ==================================================

            ReviewSectionCard(
              title: 'Business Information',
              icon: Icons.business_outlined,
              onEdit: () => onEdit(3),
              items: [
                ReviewItem(
                  label: 'Category',
                  value: businessController.businessCategory ?? '',
                ),
                ReviewItem(
                  label: 'Nature',
                  value: businessController.natureOfBusiness ?? '',
                ),
                ReviewItem(
                  label: 'Description',
                  value: businessController.businessDescriptionController.text,
                ),
                ReviewItem(
                  label: 'Start Date',
                  value: businessController.businessStartDateController.text,
                ),
                ReviewItem(
                  label: 'Monthly Volume',
                  value:
                      businessController.expectedMonthlyTransactionVolume ?? '',
                ),
                ReviewItem(
                  label: 'Ownership',
                  value: businessController.businessOwnershipType ?? '',
                ),
              ],
            ),

            // ==================================================
            // SHOP VERIFICATION
            // ==================================================

            ReviewSectionCard(
              title: 'Shop Verification',
              icon: Icons.storefront_outlined,
              onEdit: () => onEdit(4),
              items: [
                ReviewItem(
                  label: 'Shop Photo',
                  value: shopController.shopLivePhoto != null
                      ? 'Captured'
                      : 'Not captured',
                ),
                ReviewItem(
                  label: 'Signboard',
                  value: shopController.shopSignboardVisible
                      ? 'Visible'
                      : 'Not confirmed',
                ),
                ReviewItem(
                  label: 'Inside Shop',
                  value: shopController.insideShopPhoto != null
                      ? 'Captured'
                      : 'Optional / Not uploaded',
                ),
                ReviewItem(
                  label: 'Location',
                  value: shopController.locationCaptured
                      ? shopController.locationText
                      : 'Not captured',
                ),
              ],
            ),

            // ==================================================
            // SELFIE
            // ==================================================

            ReviewSectionCard(
              title: 'Self Verification',
              icon: Icons.face_outlined,
              onEdit: () => onEdit(5),
              items: [
                ReviewItem(
                  label: 'Selfie',
                  value: selfieController.selfLivePhoto != null
                      ? 'Captured'
                      : 'Not captured',
                ),
                ReviewItem(
                  label: 'Liveness',
                  value: selfieController.livenessCompleted
                      ? 'Completed'
                      : 'Pending',
                ),
                ReviewItem(
                  label: 'KYC Match',
                  value: selfieController.photoToKycMatched
                      ? 'Matched'
                      : 'Pending',
                ),
              ],
            ),

            // ==================================================
            // BANK DETAILS
            // ==================================================

            ReviewSectionCard(
              title: 'Bank Details',
              icon: Icons.account_balance_outlined,
              onEdit: () => onEdit(6),
              items: [
                ReviewItem(
                  label: 'Account Holder',
                  value: bankController.accountNameController.text,
                ),
                ReviewItem(
                  label: 'Bank',
                  value: bankController.bankNameController.text,
                ),
                ReviewItem(
                  label: 'Account Number',
                  value: _maskNumber(
                    bankController.accountNumberController.text,
                  ),
                ),
                ReviewItem(
                  label: 'IFSC',
                  value: bankController.ifscController.text,
                ),
                ReviewItem(
                  label: 'Account Type',
                  value: bankController.accountType,
                ),
              ],
            ),

            // ==================================================
            // BANK DOCUMENT
            // ==================================================

            // Add your BankDocumentUploadController import
            // and summary here if required.

            SizedBox(height: 4.h),

            // ==================================================
            // DECLARATION
            // ==================================================

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: primaryColor.withValues(
                  alpha: 0.06,
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: primaryColor.withValues(
                    alpha: 0.15,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: reviewController.declarationAccepted,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      reviewController.setDeclarationAccepted(
                        value ?? false,
                      );
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: CustomText(
                        'I confirm that all the information '
                        'and documents provided are accurate '
                        'and I authorize verification of my KYC.',
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                          color: greyText6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // ==================================================
            // SUBMIT
            // ==================================================

            CustomButton(
              title: reviewController.isSubmitting
                  ? 'Submitting...'
                  : 'Submit KYC',
              height: 48.h,
              radius: 8.r,
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  secondaryColor,
                ],
              ),
              onTap: reviewController.isSubmitting
                  ? null
                  : () async {
                      // if (!reviewController.validateBeforeSubmit()) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(
                      //       content: Text(
                      //         'Please accept the declaration before submitting.',
                      //       ),
                      //     ),
                      //   );
                      //   return;
                      // }

                      // final success = await reviewController.submitKyc();

                      // if (!success) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(
                      //       content: Text(
                      //         'Unable to submit KYC.',
                      //       ),
                      //     ),
                      //   );
                      //   return;
                      // }

                      onCompleteChanged(true);
                      navigate(
                          context: context,
                          page: KycSubmittedSuccessScreen(
                            onGoToDashboard: () {
                              Get.find<DashBoardController>().dashPage = 0;
                              navigate(
                                  context: context, page: DashboardScreen());
                            },
                          ));
                    },
            ),

            SizedBox(height: 20.h),
          ],
        );
      },
    );
  }

  static String _maskNumber(String value) {
    final clean = value.trim();

    if (clean.isEmpty) {
      return '';
    }

    if (clean.length <= 4) {
      return clean;
    }

    return '•••• ${clean.substring(clean.length - 4)}';
  }
}
