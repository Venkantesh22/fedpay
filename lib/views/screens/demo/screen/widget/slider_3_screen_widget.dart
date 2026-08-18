import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/base/custom_image.dart';

class Slider3ScreenWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  const Slider3ScreenWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: white,
      ),
      child: Column(
        children: [
          CustomImage(
            height: MediaQuery.of(context).size.height / 6,
            path: image,
            fit: BoxFit.contain,
            radius: 16.r,
          ),
          sizedBoxHeight(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: Helper(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: sidlerTitle,
                      ),
                ),
                sizedBoxHeight(height: 8.h),
                CustomText(
                  subTitle,
                  maxLines: 2,
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: sidlerTitle,
                      ),
                ),
              ],
            ),
          ),
          sizedBoxHeight(height: 8.h),
        ],
      ),
    );
  }
}
