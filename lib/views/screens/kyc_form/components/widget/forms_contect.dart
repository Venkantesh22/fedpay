import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lekra/controllers/form_controller.dart';

import 'package:lekra/views/screens/kyc_form/components/Personal_details_form.dart';
import 'package:lekra/views/screens/kyc_form/components/bank_details_form.dart';
import 'package:lekra/views/screens/kyc_form/components/business_form_section.dart';



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

            PersonalDetailsForm(
              isComplete:
                  formController.completed[0],
              onCompleteChanged: (value) {
                _completeStep(
                  formController,
                  0,
                  value,
                );
              },
            ),

            // ==================================================
            // STEP 2 - KYC DOCUMENTS
            // ==================================================

            // KycDocumentUploadForm(
            //   isComplete:
            //       formController.completed[1],
            //   onCompleteChanged: (value) {
            //     _completeStep(
            //       formController,
            //       1,
            //       value,
            //     );
            //   },
            // ),

            // // ==================================================
            // // STEP 3 - DOCUMENT DETAILS
            // // ==================================================

            // DocumentDetailsForm(
            //   isComplete:
            //       formController.completed[2],
            //   onCompleteChanged: (value) {
            //     _completeStep(
            //       formController,
            //       2,
            //       value,
            //     );
            //   },
            // ),

            // // ==================================================
            // // STEP 4 - BUSINESS
            // // ==================================================

            // BusinessForm(
            //   isComplete:
            //       formController.completed[3],
            //   onCompleteChanged: (value) {
            //     _completeStep(
            //       formController,
            //       3,
            //       value,
            //     );
            //   },
            // ),

            // // ==================================================
            // // STEP 5 - SHOP VERIFICATION
            // // ==================================================

            // ShopVerificationForm(
            //   isComplete:
            //       formController.completed[4],
            //   onCompleteChanged: (value) {
            //     _completeStep(
            //       formController,
            //       4,
            //       value,
            //     );
            //   },
            // ),

            // // ==================================================
            // // STEP 6 - SELF VERIFICATION
            // // ==================================================

            // SelfVerificationForm(
            //   isComplete:
            //       formController.completed[5],
            //   onCompleteChanged: (value) {
            //     _completeStep(
            //       formController,
            //       5,
            //       value,
            //     );
            //   },
            // ),

            // // ==================================================
            // // STEP 7 - BANK DETAILS
            // // ==================================================

            // BankDetailsForm(
            //   isComplete:
            //       formController.completed[6],
            //   onCompleteChanged: (value) {
            //     _completeStep(
            //       formController,
            //       6,
            //       value,
            //     );
            //   },
            // ),

            // // ==================================================
            // // STEP 8 - BANK DOCUMENT
            // // ==================================================

            // BankDocumentUploadForm(
            //   isComplete:
            //       formController.completed[7],
            //   onCompleteChanged: (value) {
            //     _completeStep(
            //       formController,
            //       7,
            //       value,
            //     );
            //   },
            // ),
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