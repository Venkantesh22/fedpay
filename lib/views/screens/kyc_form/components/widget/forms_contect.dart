import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lekra/controllers/kyc_controller/form_controller.dart';
import 'package:lekra/views/screens/kyc_form/components/screen/business_information/business_information_screen.dart';
import 'package:lekra/views/screens/kyc_form/components/screen/kyc_document_upload/kyc_document_upload_screen.dart';
import 'package:lekra/views/screens/kyc_form/components/screen/liveShopVerificationScreen/live_shop_verification_screen.dart';
import 'package:lekra/views/screens/kyc_form/components/screen/registration_details_form.dart';

class FormsContent extends StatelessWidget {
  const FormsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormController>(
      builder: (formController) {
        return IndexedStack(
          index: formController.selectedIndex,
          children: [
            // ==================================================
            // STEP 1 - BASIC DETAILS
            // ==================================================

            RegistrationDetailForm(
              isComplete: formController.completed[0],
              onCompleteChanged: (value) {
                _completeStep(
                  formController,
                  0,
                  value,
                );
              },
            ),

            KycDocumentUploadScreen(
              isComplete: formController.completed[1],
              onCompleteChanged: (value) {
                _completeStep(
                  formController,
                  0,
                  value,
                );
              },
            ),
            // DocuentDetailsScreen(
            KycDocumentUploadScreen(
              isComplete: formController.completed[2],
              onCompleteChanged: (value) {
                _completeStep(
                  formController,
                  0,
                  value,
                );
              },
            ),
            BusinessInformationScreen(
              isComplete: formController.completed[3],
              onCompleteChanged: (value) {
                _completeStep(
                  formController,
                  0,
                  value,
                );
              },
            ),

            LiveShopVerificationScreen(
              isComplete: formController.completed[4],
              onCompleteChanged: (value) {
                _completeStep(
                  formController,
                  4,
                  value,
                );
              },
            ),
          ],
        );
      },
    );
  }

  static void _completeStep(
    FormController controller,
    int index,
    bool value,
  ) {
    controller.setComplete(
      index,
      value,
    );

    if (value && index < 7) {
      controller.selectIndex(index + 1);
    }
  }
}
