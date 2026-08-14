import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lekra/controllers/kyc_controller/bank_details_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/kyc_form/components/screen/bankDetailsScreen/widget/account_type_selector.dart';
import 'package:lekra/views/screens/kyc_form/components/screen/bankDetailsScreen/widget/bank_detail_field.dart';
import 'package:lekra/views/screens/kyc_form/components/widget/uppper_case_text_formatter.dart';

class BankDetailsScreen extends StatefulWidget {
  final bool isComplete;
  final ValueChanged<bool> onCompleteChanged;

  const BankDetailsScreen({
    super.key,
    required this.isComplete,
    required this.onCompleteChanged,
  });

  @override
  State<BankDetailsScreen> createState() =>
      _BankDetailsScreenState();
}

class _BankDetailsScreenState
    extends State<BankDetailsScreen> {
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankDetailsController>(
      builder: (controller) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ==================================================
              // TITLE
              // ==================================================

              CustomText(
                'Bank Details',
                style: Helper(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: black,
                    ),
              ),

              SizedBox(height: 4.h),

              CustomText(
                'Enter your bank account details for settlement',
                style: Helper(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      fontSize: 13.sp,
                      color: greyDark,
                    ),
              ),

              SizedBox(height: 24.h),

              // ==================================================
              // ACCOUNT HOLDER NAME
              // ==================================================

              BankDetailField(
                controller:
                    controller.accountNameController,
                heading: 'Account Holder Name',
                hintText:
                    'Enter name as per bank account',
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter account holder name';
                  }

                  return null;
                },
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // ACCOUNT TYPE
              // ==================================================

              AccountTypeSelector(
                selectedValue:
                    controller.accountType,
                items: controller.accountTypeList,
                onChanged:
                    controller.setAccountType,
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // ACCOUNT NUMBER
              // ==================================================

              BankDetailField(
                controller:
                    controller.accountNumberController,
                heading: 'Account Number',
                hintText: 'Enter account number',
                keyboardType:
                    TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter account number';
                  }

                  if (value.trim().length < 6) {
                    return 'Please enter valid account number';
                  }

                  return null;
                },
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // CONFIRM ACCOUNT NUMBER
              // ==================================================

              BankDetailField(
                controller:
                    controller
                        .confirmAccountNumberController,
                heading: 'Confirm Account Number',
                hintText:
                    'Re-enter account number',
                keyboardType:
                    TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please confirm account number';
                  }

                  if (value.trim() !=
                      controller
                          .accountNumberController
                          .text
                          .trim()) {
                    return 'Account numbers do not match';
                  }

                  return null;
                },
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // IFSC
              // ==================================================

              BankDetailField(
                controller:
                    controller.ifscController,
                heading: 'IFSC Code',
                hintText: 'Enter IFSC code',
                keyboardType:
                    TextInputType.text,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: (value) {
                  final String ifsc =
                      value?.trim().toUpperCase() ?? '';

                  if (ifsc.isEmpty) {
                    return 'Please enter IFSC code';
                  }

                  if (!RegExp(
                    r'^[A-Z]{4}0[A-Z0-9]{6}$',
                  ).hasMatch(ifsc)) {
                    return 'Please enter valid IFSC code';
                  }

                  return null;
                },
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // BANK NAME
              // ==================================================

              BankDetailField(
                controller:
                    controller.bankNameController,
                heading: 'Bank Name',
                hintText: 'Enter bank name',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter bank name';
                  }

                  return null;
                },
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // BRANCH NAME
              // ==================================================

              BankDetailField(
                controller:
                    controller.branchNameController,
                heading: 'Branch Name',
                hintText: 'Enter branch name',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter branch name';
                  }

                  return null;
                },
              ),

              SizedBox(height: 18.h),

              // ==================================================
              // REGISTERED MOBILE
              // ==================================================

              BankDetailField(
                controller:
                    controller.registeredMobileController,
                heading: 'Registered Mobile Number',
                hintText: 'Enter bank registered mobile',
                keyboardType:
                    TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter mobile number';
                  }

                  if (value.trim().length != 10) {
                    return 'Please enter valid 10 digit mobile number';
                  }

                  return null;
                },
              ),

              SizedBox(height: 24.h),

              // ==================================================
              // SECURITY INFO
              // ==================================================

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color:
                      primaryColor.withValues(
                    alpha: 0.07,
                  ),
                  borderRadius:
                      BorderRadius.circular(10.r),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.account_balance_outlined,
                      color: primaryColor,
                      size: 19.r,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomText(
                        'Make sure the bank account belongs to the registered business or account holder.',
                        overflow: TextOverflow.clip,
                        style: Helper(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              fontSize: 11.sp,
                              color: primaryColor,
                              fontWeight:
                                  FontWeight.w500,
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
                  FocusScope.of(context).unfocus();

                  final bool valid =
                      formKey.currentState
                              ?.validate() ??
                          false;

                  if (!valid) {
                    return;
                  }

                  if (!controller
                      .validateBankDetails()) {
                    return;
                  }

                  // Navigation stays in FormController.
                  widget.onCompleteChanged(true);
                },
              ),

              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }
}

