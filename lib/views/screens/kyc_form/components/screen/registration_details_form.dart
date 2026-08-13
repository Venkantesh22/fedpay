import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/kyc_controller/form_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_dropdown.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class RegistrationDetailForm extends StatefulWidget {
  final bool isComplete;
  final ValueChanged<bool> onCompleteChanged;

  const RegistrationDetailForm({
    super.key,
    required this.isComplete,
    required this.onCompleteChanged,
  });

  @override
  State<RegistrationDetailForm> createState() => _RegistrationDetailFormState();
}

class _RegistrationDetailFormState extends State<RegistrationDetailForm> {
  final formKey = GlobalKey<FormState>();

  // ============================================================
  // REMOVE DUPLICATE VALUES
  // ============================================================

  List<String> uniqueNames(List<String> items) {
    final seen = <String>{};
    final output = <String>[];

    for (final item in items) {
      if (item.isEmpty) {
        continue;
      }

      if (!seen.contains(item)) {
        seen.add(item);
        output.add(item);
      }
    }

    return output;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormController>(
      builder: (formController) {
        return GetBuilder<BasicController>(
          builder: (basicController) {
            // ----------------------------------------------------
            // DISTRICT LIST
            // ----------------------------------------------------

            final districtNames = uniqueNames(
              basicController.districtList
                  .map(
                    (district) => district.districtName ?? '',
                  )
                  .toList(),
            );

            final safeDistrictValue = districtNames.contains(
              formController.selectDistrict?.districtName ?? '',
            )
                ? formController.selectDistrict?.districtName
                : null;

            // ----------------------------------------------------
            // STATE LIST
            // ----------------------------------------------------

            // final stateNames = uniqueNames(
            //   basicController.stateList
            //       .map(
            //         (state) =>
            //             state.stateName ?? '',
            //       )
            //       .toList(),
            // );

            // final safeStateValue =
            //     stateNames.contains(
            //   formController.selectState?.stateName ?? '',
            // )
            //         ? formController.selectState?.stateName
            //         : null;

            return Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // HEADER
                  // =================================================

                  CustomText(
                    "Registration & Basic Details",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                  ),

                  sizedBoxHeight(height: 2),

                  CustomText(
                    "Enter your basic and shop details",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: greyDark,
                        ),
                  ),

                  sizedBoxHeight(height: 32),

                  // =================================================
                  // FIRST NAME
                  // =================================================

                  AppTextFieldWithHeading(
                    controller: formController.firstNameController,
                    hindText: "Enter first name",
                    heading: "First Name",
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
                        return 'Please enter first name';
                      }

                      return null;
                    },
                  ),

                  sizedBoxHeight(height: 24),

                  // =================================================
                  // LAST NAME
                  // =================================================

                  AppTextFieldWithHeading(
                    controller: formController.lastNameController,
                    hindText: "Enter last name",
                    heading: "Last Name",
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
                        return 'Please enter last name';
                      }

                      return null;
                    },
                  ),

                  sizedBoxHeight(height: 24),

                  // =================================================
                  // MOBILE NUMBER
                  // =================================================

                  AppTextFieldWithHeading(
                    controller: formController.businessNumberController,
                    hindText: "Enter mobile number",
                    heading: "Mobile Number",
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter mobile number';
                      }

                      if (value.length != 10) {
                        return 'Please enter valid 10 digit mobile number';
                      }

                      return null;
                    },
                  ),

                  sizedBoxHeight(height: 24),

                  // =================================================
                  // EMAIL
                  // =================================================

                  AppTextFieldWithHeading(
                    controller: formController.businessEmailController,
                    hindText: "Enter email address",
                    heading: "Email Address",
                    isRequired: true,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter email address';
                      }

                      final emailRegex = RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      );

                      if (!emailRegex.hasMatch(
                        value.trim(),
                      )) {
                        return 'Please enter a valid email address';
                      }

                      return null;
                    },
                  ),

                  sizedBoxHeight(height: 24),

                  // =================================================
                  // BUSINESS / SHOP NAME
                  // =================================================

                  AppTextFieldWithHeading(
                    controller: formController.businessNameController,
                    hindText: "Enter business or shop name",
                    heading: "Business / Shop Name",
                    isRequired: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter business or shop name';
                      }

                      return null;
                    },
                  ),

                  sizedBoxHeight(height: 24),

                  // =================================================
                  // SHOP ADDRESS
                  // =================================================

                  AppTextFieldWithHeading(
                    controller: formController.shopAddressController,
                    hindText: "Enter complete shop address",
                    heading: "Shop Address",
                    isRequired: true,
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                    maxLines: 3,
                    minLines: 3,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter shop address';
                      }

                      return null;
                    },
                  ),

                  sizedBoxHeight(height: 24),

                  // =================================================
                  // PIN CODE
                  // =================================================

                  AppTextFieldWithHeading(
                    controller: formController.pincodeController,
                    hindText: "Enter PIN code",
                    heading: "PIN Code",
                    isRequired: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter PIN code';
                      }

                      if (value.length != 6) {
                        return 'Please enter valid 6 digit PIN code';
                      }

                      return null;
                    },
                  ),

                  sizedBoxHeight(height: 24),

                  // =================================================
                  // CITY
                  // =================================================

                  AppTextFieldWithHeading(
                    controller: formController.cityController,
                    hindText: "Enter city",
                    heading: "City",
                    isRequired: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter city';
                      }

                      return null;
                    },
                  ),
                  sizedBoxHeight(height: 24),

                  // =================================================
                  // STATE
                  // =================================================

                  CustomDropDownList<String>(
                    value: safeDistrictValue,
                    items: districtNames,
                    heading: "State",
                    hintText: "Select state",
                    isRequired: true,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select State';
                      }
                      return null;
                    },
                    onChanged: (v) async {
                      basicController.setSelectStateModel(stateName: v);
                      formController.selectState =
                          basicController.selectStateModel;
                      formController.update();
                    },
                  ),

                  // CustomDropdown(
                  //   heading: "State",
                  //   hintText: "Select state",
                  //   isRequired: true,

                  //   items: stateNames,

                  //   selectedValue: safeStateValue,

                  //   onChanged: (value) {
                  //     if (value == null) {
                  //       return;
                  //     }

                  //     final selectedState =
                  //         basicController.stateList
                  //             .firstWhere(
                  //       (state) =>
                  //           state.stateName == value,
                  //     );

                  //     formController.selectState =
                  //         selectedState;

                  //     // Reset district when state changes
                  //     formController.selectDistrict =
                  //         null;

                  //     formController.update();
                  //   },
                  // ),

                  sizedBoxHeight(height: 32),

                  // =================================================
                  // CONTINUE
                  // =================================================

                  CustomButton(
                    radius: 24.r,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        primaryColor,
                        secondaryColor,
                      ],
                    ),
                    textStyle: Helper(context).textTheme.titleSmall?.copyWith(
                          color: white,
                        ),
                    onTap: () {
                      final isValid = formKey.currentState?.validate() ?? false;

                      if (!isValid) {
                        return;
                      }

                      // State validation
                      if (formController.selectState == null) {
                        showToast(
                          message: "Please select state",
                          typeCheck: false,
                        );
                        return;
                      }

                      // District validation
                      if (formController.selectDistrict == null) {
                        showToast(
                          message: "Please select district",
                          typeCheck: false,
                        );
                        return;
                      }

                      // Mark current step completed
                      widget.onCompleteChanged(true);
                    },
                    child: CustomText(
                      "Continue",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: white,
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
