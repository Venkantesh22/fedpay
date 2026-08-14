import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class ReviewSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<ReviewItem> items;
  final VoidCallback onEdit;

  const ReviewSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: greyBorder.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        children: [
          // ====================================================
          // HEADER
          // ====================================================

          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(
                    alpha: 0.08,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 20.r,
                ),
              ),

              SizedBox(width: 10.w),

              Expanded(
                child: CustomText(
                  title,
                  style: Helper(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: black,
                      ),
                ),
              ),

              TextButton(
                onPressed: onEdit,
                child: Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          Divider(
            height: 1,
            color: greyBorder.withValues(alpha: 0.45),
          ),

          SizedBox(height: 8.h),

          // ====================================================
          // VALUES
          // ====================================================

          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.symmetric(
                vertical: 6.h,
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: CustomText(
                      item.label,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: greyText6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    flex: 6,
                    child: CustomText(
                      item.value.isEmpty
                          ? '-'
                          : item.value,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewItem {
  final String label;
  final String value;

  const ReviewItem({
    required this.label,
    required this.value,
  });
}