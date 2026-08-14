import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/kyc_controller/registration_kyc_form_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_dropdown.dart';
import 'package:lekra/views/base/common_button.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> _uniqueNames(List<String> items) {
    final Set<String> seen = {};
    final List<String> result = [];

    for (final item in items) {
      final value = item.trim();

      if (value.isEmpty) {
        continue;
      }

      if (seen.add(value)) {
        result.add(value);
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationKycFromController>(
      builder: (registrationController) {
        return GetBuilder<BasicController>(
          builder: (basicController) {
            final List<String> stateNames = _uniqueNames(
              basicController.statusList
                  .map((state) => state.stateName ?? '')
                  .toList(),
            );

            final List<String> districtNames = _uniqueNames(
              basicController.districtList
                  .map((district) => district.districtName ?? '')
                  .toList(),
            );

            final String? selectedStateName = stateNames.contains(
              registrationController.selectState?.stateName,
            )
                ? registrationController.selectState?.stateName
                : null;

            final String? selectedDistrictName = districtNames.contains(
              registrationController.selectDistrict?.districtName,
            )
                ? registrationController.selectDistrict?.districtName
                : null;

            return Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // HEADER
                  // ==================================================

                  CustomText(
                    'Registration & Basic Details',
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                  ),

                  SizedBox(height: 4.h),

                  CustomText(
                    'Enter your basic and shop details',
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: greyDark,
                        ),
                  ),

                  SizedBox(height: 28.h),

                  // ==================================================
                  // FIRST NAME
                  // ==================================================

                  AppTextFieldWithHeading(
                    controller: registrationController.firstNameController,
                    heading: 'First Name',
                    hindText: 'Enter first name',
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

                  SizedBox(height: 20.h),

                  // ==================================================
                  // LAST NAME
                  // ==================================================

                  AppTextFieldWithHeading(
                    controller: registrationController.lastNameController,
                    heading: 'Last Name',
                    hindText: 'Enter last name',
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

                  SizedBox(height: 20.h),

                  // ==================================================
                  // MOBILE
                  // ==================================================

                  AppTextFieldWithHeading(
                    controller: registrationController.businessNumberController,
                    heading: 'Mobile Number',
                    hindText: 'Enter mobile number',
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    prefixText: '+91',
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

                      if (value.trim().length != 10) {
                        return 'Please enter valid 10 digit mobile number';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: 20.h),

                  // ==================================================
                  // EMAIL
                  // ==================================================

                  AppTextFieldWithHeading(
                    controller: registrationController.businessEmailController,
                    heading: 'Email Address',
                    hindText: 'Enter email address',
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

                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter valid email address';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: 20.h),

                  // ==================================================
                  // BUSINESS / SHOP NAME
                  // ==================================================

                  AppTextFieldWithHeading(
                    controller: registrationController.businessNameController,
                    heading: 'Business / Shop Name',
                    hindText: 'Enter business or shop name',
                    isRequired: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter business/shop name';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20.h),

                  // ==================================================
                  // SHOP ADDRESS
                  // ==================================================

                  AppTextFieldWithHeading(
                    controller: registrationController.shopAddressController,
                    heading: 'Shop Address',
                    hindText: 'Enter complete shop address',
                    isRequired: true,
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                    minLines: 3,
                    maxLines: 3,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter shop address';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20.h),

                  // ==================================================
                  // PIN CODE
                  // ==================================================

                  AppTextFieldWithHeading(
                    controller: registrationController.pincodeController,
                    heading: 'PIN Code',
                    hindText: 'Enter PIN code',
                    isRequired: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter PIN code';
                      }

                      if (value.trim().length != 6) {
                        return 'Please enter valid 6 digit PIN code';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: 20.h),

                  // ==================================================
                  // CITY
                  // ==================================================

                  AppTextFieldWithHeading(
                    controller: registrationController.cityController,
                    heading: 'City',
                    hindText: 'Enter city',
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

                  SizedBox(height: 20.h),

                  // ==================================================
                  // STATE
                  // ==================================================

                  CustomDropDownList<String>(
                    value: selectedStateName,
                    items: stateNames,
                    heading: 'State',
                    hintText: 'Select state',
                    isRequired: true,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select state';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value == null || value.isEmpty) {
                        return;
                      }

                      final selectedState =
                          basicController.statusList.firstWhere(
                        (state) => state.stateName == value,
                      );

                      registrationController.setState(
                        selectedState,
                      );

                      basicController.setSelectStateModel(
                        stateName: value,
                      );
                    },
                  ),

                  SizedBox(height: 20.h),

                  // ==================================================
                  // DISTRICT
                  // ==================================================

                  CustomDropDownList<String>(
                    value: selectedDistrictName,
                    items: districtNames,
                    heading: 'District',
                    hintText: 'Select district',
                    isRequired: true,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select district';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value == null || value.isEmpty) {
                        return;
                      }

                      final selectedDistrict =
                          basicController.districtList.firstWhere(
                        (district) => district.districtName == value,
                      );

                      registrationController.setDistrict(
                        selectedDistrict,
                      );
                    },
                  ),

                  SizedBox(height: 28.h),

                  // ==================================================
                  // CONTINUE
                  // ==================================================

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
                          fontWeight: FontWeight.w600,
                        ),
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      final bool valid =
                          formKey.currentState?.validate() ?? false;

                      if (!valid) {
                        return;
                      }

                      if (!registrationController.validateRegistration()) {
                        showToast(
                          message: 'Please complete all registration details',
                          typeCheck: false,
                        );
                        return;
                      }

                      // This only tells FormController
                      // to move to the next KYC screen.
                      widget.onCompleteChanged(true);
                    },
                    child: CustomText(
                      'Continue',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
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
