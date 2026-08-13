import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/main_card_screen/widget/card_deactivated.dart';

class CardBackSide extends StatelessWidget {
  const CardBackSide({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(builder: (cardController) {
      return Stack(
        children: [
          CustomImage(
            path: Assets.imagesPrepaidCardBack,
            fit: BoxFit.cover,
          ),
          Positioned(
            right: 46,
            bottom: 0,
            top: 18,
            child: Center(
              child: Text(
                cardController.showPrepaidCardFullNumber
                    ? cardController.selectPrepaidCardModel?.cvv ?? "***"
                    : "***",
                overflow: TextOverflow.clip,
                style: Helper(context).textTheme.displayMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: black,
                    ),
              ),
            ),
          ),
          CardDeactivated(),
        ],
      );
    });
  }
}
