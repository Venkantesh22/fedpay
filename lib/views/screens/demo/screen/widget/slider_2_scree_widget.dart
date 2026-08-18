import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class Slider2ScreenWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  const Slider2ScreenWidget({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: Center(
            child: Icon(
              icon,
              color: white,
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
    );
  }
}
