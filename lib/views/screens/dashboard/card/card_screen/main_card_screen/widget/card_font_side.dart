import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/main_card_screen/widget/card_deactivated.dart';

class CardFontSide extends StatelessWidget {
  const CardFontSide({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(builder: (cardController) {
      return Stack(
        children: [
          CustomImage(
            path: Assets.imagesPrepaidCard,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 20,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        cardController.showPrepaidCardFullNumber
                            ? cardController
                                    .selectPrepaidCardModel?.formatCardNumber ??
                                ""
                            : cardController.selectPrepaidCardModel
                                    ?.formatCardNumberLastFourDigit ??
                                "",
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.left,
                        style:
                            Helper(context).textTheme.displayMedium?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: white,
                                ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          cardController.updateShowPrepaidCardFullNumber(
                              value: !cardController.showPrepaidCardFullNumber);
                        },
                        icon: Icon(
                            cardController.showPrepaidCardFullNumber
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: white.withValues(alpha: 0.70)))
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CARD HOLDER",
                            style:
                                Helper(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.3,
                                      color: white.withValues(alpha: 0.70),
                                    ),
                          ),
                          Text(
                            cardController.selectPrepaidCardModel?.nameOnCard ??
                                "",
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                            style: Helper(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: white,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "EXPIRY",
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.3,
                                color: white.withValues(alpha: 0.70),
                              ),
                        ),
                        Text(
                          cardController.selectPrepaidCardModel?.expiryDate ??
                              "",
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          style:
                              Helper(context).textTheme.displayMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: white,
                                  ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          CardDeactivated()
        ],
      );
    });
  }
}
