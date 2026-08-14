import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class KycSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const KycSectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title,
          style: Helper(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: black,
              ),
        ),
        SizedBox(height: 3.h),
        CustomText(
          subtitle,
          style: Helper(context)
              .textTheme
              .bodySmall
              ?.copyWith(
                fontSize: 11.sp,
                color: greyText6,
              ),
        ),
      ],
    );
  }
}