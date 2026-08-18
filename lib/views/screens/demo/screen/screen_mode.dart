import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/demo/screen/widget/slider_2_scree_widget.dart';

class DemoScreenModel {
  final Widget title;
  final String subTitle;
  final Widget imageSection;
  final Widget? descr;

  DemoScreenModel(
      {required this.title,
      required this.subTitle,
      required this.imageSection,
      this.descr});
}

List<DemoScreenModel> getDemoData(BuildContext context) {
  return [
    DemoScreenModel(
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: SizedBox(
          width: double.infinity,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Accept Payments\nwith ",
              style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 26.sp,
                    color: sidlerTitle,
                  ),
              children: [
                TextSpan(
                  text: "Sound Box\n",
                  style: Helper(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 26.sp,
                        color: secondaryColor,
                      ),
                ),
                TextSpan(
                  text: "Merchant QR",
                  style: Helper(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 26.sp,
                        color: sidlerTitle,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      subTitle: "One QR for all UPI Apps.\nSimple, fast and secure payments.",
      imageSection: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.h),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: CustomImage(
                  path: Assets.imagesSilder1,
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Slider1Container(
                      context,
                      Assets.svgsSound,
                      "Instant\nVoice Alerts",
                    ),
                    Slider1Container(
                      context,
                      Assets.svgsQr2,
                      "One QR for\n All UPI Apps",
                    ),
                    Slider1Container(
                      context,
                      Assets.svgsSecure,
                      "Secure &\nReliable",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
    //* 2 screen

    DemoScreenModel(
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: SizedBox(
          width: double.infinity,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Introducing\n",
              style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 26.sp,
                    color: sidlerTitle,
                  ),
              children: [
                TextSpan(
                  text: "FedPay ",
                  style: Helper(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 26.sp,
                        color: sidlerTitle,
                      ),
                ),
                TextSpan(
                  text: "RuPay Card",
                  style: Helper(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 26.sp,
                        color: secondaryColor,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      subTitle: "One Card. Endless Possibilities.",
      imageSection: SizedBox(
        // height: MediaQuery.of(context).size.height / 3,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.h),
          child: Column(
            children: [
              CustomImage(
                path: Assets.imagesSilder2,
                width: double.infinity,
                height: 300.h,
                fit: BoxFit.contain,
              ),
              sizedBoxHeight(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Slider2ScreenWidget(
                      icon: Icons.shopping_bag_outlined,
                      title: "Shop\nAnywhere"),
                  Slider2ScreenWidget(
                      icon: Icons.language, title: "Pay\nOnline"),
                  Slider2ScreenWidget(
                      icon: Icons.payments_outlined, title: "Cash\nWithdrawal"),
                  Slider2ScreenWidget(
                      icon: Icons.flight_outlined, title: "Travel\nMore"),
                ],
              )
            ],
          ),
        ),
      ),
    ),
    DemoScreenModel(
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: SizedBox(
          width: double.infinity,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Accept Payments\nwith ",
              style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 26.sp,
                    color: sidlerTitle,
                  ),
              children: [
                TextSpan(
                  text: "Sound Box\n",
                  style: Helper(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 26.sp,
                        color: secondaryColor,
                      ),
                ),
                TextSpan(
                  text: "Merchant QR",
                  style: Helper(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 26.sp,
                        color: sidlerTitle,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      subTitle: "One QR for all UPI Apps.\nSimple, fast and secure payments.",
      imageSection: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.h),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: CustomImage(
                  path: Assets.imagesSilder1,
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Slider1Container(
                      context,
                      Assets.svgsSound,
                      "Instant\nVoice Alerts",
                    ),
                    Slider1Container(
                      context,
                      Assets.svgsQr2,
                      "One QR for\n All UPI Apps",
                    ),
                    Slider1Container(
                      context,
                      Assets.svgsSecure,
                      "Secure &\nReliable",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  ];
}

Container Slider1Container(
  BuildContext context,
  String icon,
  String title,
) {
  return Container(
    width: 100.w,
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(width: 2.w, color: greyBorder),
      color: white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48.w,
          height: 48.h,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: primaryColor,
          ),
          child: SvgPicture.asset(
            icon,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              white,
              BlendMode.srcIn,
            ),
          ),
        ),
        sizedBoxHeight(height: 12.h),
        CustomText(
          title,
          maxLines: 2,
          style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: sidlerTitle,
              ),
        ),
      ],
    ),
  );
}
