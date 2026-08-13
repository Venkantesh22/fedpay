import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lekra/controllers/kyc_controller/form_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class DocumentDetailsScreen extends StatefulWidget {
  final bool isComplete;
  final ValueChanged<bool> onCompleteChanged;

  const DocumentDetailsScreen({
    super.key,
    required this.isComplete,
    required this.onCompleteChanged,
  });

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormController>(
      builder: (formController) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // TITLE
              // ==================================================

              CustomText(
                'Document Details',
                style: Helper(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
              ),

              SizedBox(height: 4.h),

              CustomText(
                'Enter details as per your documents',
                style: Helper(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: greyDark,
                    ),
              ),

              SizedBox(height: 24.h),

              // ==================================================
              // AADHAAR NUMBER
              // ==================================================

              AppTextFieldWithHeading(
                controller: formController.aadhaarNumberController,
                heading: 'Aadhaar Number',
                hindText: 'Enter 12 digit Aadhaar number',
                isRequired: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final String text = value?.trim() ?? '';

                  if (text.isEmpty) {
                    return 'Please enter Aadhaar number';
                  }

                  if (text.length != 12) {
                    return 'Aadhaar number must be 12 digits';
                  }

                  return null;
                },
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // PAN NUMBER
              // ==================================================

              AppTextFieldWithHeading(
                controller: formController.panNumberController,
                heading: 'PAN Number',
                hindText: 'Enter PAN number',
                isRequired: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9]'),
                  ),
                  LengthLimitingTextInputFormatter(10),
                  UpperCaseTextFormatter(),
                ],
                validator: (value) {
                  final String pan = value?.trim().toUpperCase() ?? '';

                  if (pan.isEmpty) {
                    return 'Please enter PAN number';
                  }

                  if (!RegExp(
                    r'^[A-Z]{5}[0-9]{4}[A-Z]$',
                  ).hasMatch(pan)) {
                    return 'Please enter a valid PAN number';
                  }

                  return null;
                },
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // GSTIN
              // ==================================================

              AppTextFieldWithHeading(
                controller: formController.gstNumberController,
                heading: 'GSTIN',
                hindText: 'Enter GSTIN (if applicable)',
                isRequired: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(15),
                  UpperCaseTextFormatter(),
                ],
                validator: (value) {
                  final String gstin = value?.trim().toUpperCase() ?? '';

                  if (gstin.isEmpty) {
                    return null;
                  }

                  if (gstin.length != 15) {
                    return 'GSTIN must be 15 characters';
                  }

                  return null;
                },
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // TRADE LICENCE
              // ==================================================

              AppTextFieldWithHeading(
                controller: formController.tradeLicenseNumberController,
                heading: 'Trade Licence Number',
                hindText: 'Enter trade licence number (if applicable)',
                isRequired: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  return null;
                },
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // MSME / UDYAM
              // ==================================================

              AppTextFieldWithHeading(
                controller: formController.msmeNumberController,
                heading: 'MSME / Udyam Registration Number',
                hindText: 'Enter MSME number (if applicable)',
                isRequired: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  return null;
                },
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
                    const Color(0xFFE91E63),
                  ],
                ),
                onTap: () {
                  final bool isValid =
                      formKey.currentState?.validate() ?? false;

                  if (!isValid) {
                    return;
                  }

                  final bool success = formController.completeDocumentDetails();

                  if (!success) {
                    return;
                  }

                  widget.onCompleteChanged(true);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// UPPERCASE FORMATTER
// ============================================================

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
