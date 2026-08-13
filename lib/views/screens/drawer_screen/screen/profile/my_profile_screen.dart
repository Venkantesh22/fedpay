import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/drawer_screen/drawer_screen.dart';
import 'package:lekra/views/screens/drawer_screen/screen/profile/components/image_and_company_info.dart';
import 'package:lekra/views/screens/drawer_screen/screen/profile/components/permanent_address_section.dart';
import 'package:lekra/views/screens/drawer_screen/screen/profile/components/personal_infor_section.dart';
import 'package:lekra/views/screens/drawer_screen/screen/profile/components/present_address_section.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar_drawer.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final basicController = Get.find<BasicController>();
      final authController = Get.find<AuthController>();

      authController.shopNameController.text =
          authController.userModel?.shopName ?? "";
      authController.officeAddressController.text =
          authController.userModel?.officeAddress ?? "";
      authController.addressController.text =
          authController.userModel?.address ?? "";
      authController.cityController.text = authController.userModel?.city ?? "";
      authController.pincodeController.text =
          authController.userModel?.pinCode.toString() ?? "";
      authController.phoneNumberController.text =
          authController.userModel?.mobile.toString() ?? "";
      authController.memberTypeController.text = "Retailer";
      authController.userNameController.text =
          authController.userModel?.fullName ?? "";
      authController.emailController.text =
          authController.userModel?.email ?? "";

      basicController.fetchStatusList().then((value1) {
        if (value1.isSuccess) {
          if (authController.userModel?.stateId != null) {
            final idx = basicController.statusList.indexWhere(
                (s) => s.stateId == authController.userModel?.stateId);
            basicController.selectStateModel =
                idx != -1 ? basicController.statusList[idx] : null;

            log("select state ${basicController.selectStateModel?.stateName ?? ""}");

            basicController.fetchDistrictByState().then((value) {
              if (value.isSuccess) {
                if (authController.userModel?.districtId != null) {
                  final _idx = basicController.districtList.indexWhere((d) =>
                      d.districtId == authController.userModel?.districtId);
                  basicController.selectDistrictModel =
                      _idx != -1 ? basicController.districtList[_idx] : null;
                } else {
                  basicController.selectDistrictModel = null;
                }
              } else {
                showToast(message: value.message, typeCheck: value.isSuccess);
              }
            });
          } else {
            basicController.selectStateModel = null;
          }
        } else {
          showToast(message: value1.message, typeCheck: value1.isSuccess);
        }
      });

      basicController.update();
      authController.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const DrawerScreen(),
      appBar: CustomAppbarDrawer(
        backGround: contactUsBackground,
        scaffoldKey: scaffoldKey,
        title: "My Profile",
        centerTitle: false,
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            const ImageAndCompanyInfo(),
            const PersonalInforSection(),
            const PermanentAddressSection(),
            const PresentAddressSection(),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GetBuilder<AuthController>(builder: (authController) {
                return CustomButton(
                  isLoading: authController.isLoading,
                  onTap: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      
                      bool isSuccess = true;

                      // 1. Upload photo first (if changed)
                      if (authController.profileImage != null) {
                        final photoResponse = await authController.postUpdateProfilePhoto();
                        if (!photoResponse.isSuccess) {
                          isSuccess = false;
                          showToast(message: photoResponse.message, typeCheck: false);
                        }
                      }

                      // 2. If photo upload didn't fail, update profile data
                      if (isSuccess) {
                        final profileResponse = await authController.postUpdateProfile();
                        showToast(message: profileResponse.message, typeCheck: profileResponse.isSuccess);
                        isSuccess = profileResponse.isSuccess;
                      }

                      // 3. Navigate ONLY ONCE at the very end if everything worked
                      if (isSuccess) {
                        // Ensure the dashboard opens on the "Home" tab (index 0)
                        Get.find<DashBoardController>().dashPage = 0; 
                        
                        // Navigate to DashboardScreen, NOT HomeScreen!
                        navigate(context: context, page: const DashboardScreen());
                      }
                    }
                  },
                  title: "Update Profile",
                  textStyle: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: white,
                      ),
                );
              }),
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      )),
    );
  }
}
