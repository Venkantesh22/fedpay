import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lekra/controllers/kyc_controller/business_information_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_dropdown.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class BusinessInformationScreen extends StatefulWidget {
  final bool isComplete;
  final ValueChanged<bool> onCompleteChanged;

  const BusinessInformationScreen({
    super.key,
    required this.isComplete,
    required this.onCompleteChanged,
  });

  @override
  State<BusinessInformationScreen> createState() =>
      _BusinessInformationScreenState();
}

class _BusinessInformationScreenState extends State<BusinessInformationScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusinessInformationController>(
      builder: (businessController) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // TITLE
              // ==================================================

              CustomText(
                'Business Information',
                style: Helper(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
              ),

              SizedBox(height: 4.h),

              CustomText(
                'Provide information about your business',
                style: Helper(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: greyDark,
                    ),
              ),

              SizedBox(height: 24.h),

              // ==================================================
              // BUSINESS CATEGORY
              // ==================================================

              CustomDropDownList<String>(
                heading: 'Business Category',
                isRequired: true,
                items: businessController.businessCategoryList,
                value: businessController.businessCategory,
                hintText: 'Select business category',
                bgColor: primaryColorLight,
                borderColor: primaryColor,
                onChanged: businessController.setBusinessCategory,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select business category';
                  }

                  return null;
                },
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // NATURE OF BUSINESS
              // ==================================================

              AppTextFieldWithHeading(
                controller: businessController.natureOfBusinessController,
                heading: 'Nature of Business',
                hindText: 'Enter Nature of Business',
                isRequired: true,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                borderColor: primaryColor,
                bgColor: primaryColorLight,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z ]'),
                  ),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Nature of Business';
                  }
                  return null;
                },
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // TRANSACTION VOLUME
              // ==================================================

              CustomDropDownList<String>(
                heading: 'Expected Monthly Transaction Volume',
                isRequired: true,
                items: businessController.transactionVolumeList,
                value: businessController.expectedMonthlyTransactionVolume,
                hintText: 'Select monthly transaction volume',
                bgColor: primaryColorLight,
                borderColor: primaryColor,
                onChanged:
                    businessController.setExpectedMonthlyTransactionVolume,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select transaction volume';
                  }

                  return null;
                },
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // OWNERSHIP TYPE
              // ==================================================

              CustomDropDownList<String>(
                heading: 'Business Ownership Type',
                isRequired: true,
                items: businessController.businessOwnershipTypeList,
                value: businessController.businessOwnershipType,
                hintText: 'Select ownership type',
                bgColor: primaryColorLight,
                borderColor: primaryColor,
                onChanged: businessController.setBusinessOwnershipType,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select ownership type';
                  }

                  return null;
                },
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // BUSINESS DESCRIPTION
              // ==================================================

              AppTextFieldWithHeading(
                controller: businessController.businessDescriptionController,
                heading: 'Business Description',
                hindText: 'Enter a brief description of your business',
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                isRequired: true,
                textInputAction: TextInputAction.newline,
                bgColor: primaryColorLight,
                borderColor: primaryColor,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(500),
                ],
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // BUSINESS START DATE
              // ==================================================

              AppTextFieldWithHeading(
                controller: businessController.businessStartDateController,
                heading: 'Business Start Date',
                hindText: 'Select business start date',
                isRequired: true,
                readOnly: true,
                bgColor: primaryColorLight,
                borderColor: primaryColor,
                suffix: Icon(
                  Icons.calendar_today_outlined,
                  size: 19.r,
                  color: primaryColor,
                ),
                onTap: () async {
                  final DateTime now = DateTime.now();

                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: DateTime(1900),
                    lastDate: now,
                  );

                  if (pickedDate == null) {
                    return;
                  }

                  // 1. Format the date to yyyy-MM-dd
                  String formattedDate =
                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

                  // 2. Set the formatted string to the text field controller so it displays on the screen
                  businessController.businessStartDateController.text =
                      formattedDate;
                  businessController.update();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please select business start date';
                  }

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
                    secondaryColor,
                  ],
                ),
                onTap: () {
                  FocusScope.of(context).unfocus();

                  if (formKey.currentState?.validate() ?? false) {
                    return businessController
                        .venderKycBusinessInfo()
                        .then((value) {
                      if (value.isSuccess) {
                        showToast(
                            message: value.message, typeCheck: value.isSuccess);
                        widget.onCompleteChanged(true);
                      } else {
                        showToast(
                            message: value.message, typeCheck: value.isSuccess);
                      }
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
