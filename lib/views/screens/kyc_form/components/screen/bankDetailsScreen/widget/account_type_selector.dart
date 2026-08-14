import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';

import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class AccountTypeSelector extends StatelessWidget {
  final String selectedValue;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const AccountTypeSelector({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Account Type',
          style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: black,
              ),
        ),

        SizedBox(height: 10.h),

        Row(
          children: items.map((item) {
            final bool selected = item == selectedValue;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: item == items.last ? 0 : 10.w,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () => onChanged(item),
                  child: AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? primaryColor.withValues(
                              alpha: 0.08,
                            )
                          : white,
                      borderRadius:
                          BorderRadius.circular(12.r),
                      border: Border.all(
                        color: selected
                            ? primaryColor
                            : greyBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: selected
                              ? primaryColor
                              : greyText6,
                          size: 19.r,
                        ),
                        SizedBox(width: 8.w),
                        CustomText(
                          item,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected
                                ? primaryColor
                                : greyText6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}