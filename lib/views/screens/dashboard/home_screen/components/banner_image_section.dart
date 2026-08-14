import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/views/base/custom_image.dart';

class BannerImage extends StatelessWidget {
  const BannerImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomImage(
      path: Assets.imagesBanner,
      height: 160.h,
      width: double.infinity,
      fit: BoxFit.cover,
      radius: 16.r,
    );
  }
}
