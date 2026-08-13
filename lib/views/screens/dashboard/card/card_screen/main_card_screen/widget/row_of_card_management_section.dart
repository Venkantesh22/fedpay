import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_add_balance/card_add_balance_screen/card_add_balance_screen.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_balance_inquiry/card_balance_inquiry_screen.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_change_pin/card_change_pin_screen.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_mini_statements/card_mini_statements_screen.dart';

class RowOFCardManagementSection extends StatelessWidget {
  const RowOFCardManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rowOfCardManagementModeList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final rowOfCardManagementModel = rowOfCardManagementModeList[index];

        return GetBuilder<CardController>(builder: (cardController) {
          return GestureDetector(
            onTap: () {
              if (cardController.isLoading) {
                return showToast(
                    message: "Loading..", toastType: ToastType.warning);
              }
             
              navigate(context: context, page: rowOfCardManagementModel.page);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            SvgPicture.asset(
                              rowOfCardManagementModel.svgIcon,
                              fit: BoxFit.cover,
                            ),
                            cardController.selectPrepaidCardModel?.isActive ==
                                    false
                                ? Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: greyDark.withValues(alpha: 0.60),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Text(
                          rowOfCardManagementModel.title,
                          style:
                              Helper(context).textTheme.displayLarge?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: grey,
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

class RowOfCardManagementModel {
  final String svgIcon;
  final String title;
  final Widget page;

  RowOfCardManagementModel({
    required this.svgIcon,
    required this.title,
    required this.page,
  });
}

List<RowOfCardManagementModel> rowOfCardManagementModeList = [
  RowOfCardManagementModel(
    svgIcon: Assets.svgsCardTransactionHistory,
    title: "Mini Statements",
    page: CardMimiStatementsScreen(),
  ),
  RowOfCardManagementModel(
    svgIcon: Assets.svgsChangePin,
    title: "Change PIN",
    page: CardChangePinScreen(),
  ),
  RowOfCardManagementModel(
    svgIcon: Assets.svgsBalanceInquiry,
    title: "Balance Inquiry",
    page: CardBalanceInquiryScreen(),
  ),
  RowOfCardManagementModel(
    svgIcon: Assets.svgsAddBalance,
    title: "Add Balance",
    page: CardAddBalanceScreen(),
  ),
];
