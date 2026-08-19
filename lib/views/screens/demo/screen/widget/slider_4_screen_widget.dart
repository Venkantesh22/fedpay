import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class Slider4ScreenWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  const Slider4ScreenWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.w,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: primaryColor,
            ),
            child: Center(
              child: Icon(
                icon,
                color: white,
              ),
            ),
          ),
          sizedBoxWidth(width: 8.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title,
                overflow: TextOverflow.ellipsis,
                style: Helper(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: sidlerTitle,
                    ),
              ),
              CustomText(
                subTitle,
                overflow: TextOverflow.ellipsis,
                style: Helper(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                      color: sidlerTitle,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
