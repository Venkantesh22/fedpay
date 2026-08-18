import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/demo/screen/screen_mode.dart';

class DemoScreen extends StatelessWidget {
  final DemoScreenModel demoScreenModel;

  const DemoScreen({
    super.key,
    required this.demoScreenModel,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.h,
          ),
          CustomImage(
            path: Assets.imagesFedpayLogoWithBg,
            height: 60.h,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 20.h,
          ),
          demoScreenModel.title,
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, ),
            child: Text(
              demoScreenModel.subTitle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: greyText,
                  ),
            ),
          ),
          demoScreenModel.imageSection
        ],
      ),
    );
  }
}
