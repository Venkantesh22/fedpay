import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lekra/controllers/kyc_controller/form_controller.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class HeadingsBar extends StatelessWidget {
  const HeadingsBar({super.key});

  

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormController>(
      builder: (formController) {
        return SizedBox(
          height: 70.h,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: List.generate(
              formController.headings.length,
                (index) {
                  final bool isCurrent = formController.selectedIndex == index;

                  final bool isCompleted = formController.completed[index];

                  return SizedBox(
                    width: 80.w,
                    child: InkWell(
                      onTap: () {
                        formController.selectIndex(index);
                      },
                      borderRadius: BorderRadius.circular(8.r),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 22.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // --------------------------------
                                // LINE TO NEXT STEP
                                // --------------------------------
                                if (index != formController.headings.length - 1)
                                  Positioned(
                                    left: 40.w,
                                    right: 0,
                                    top: 10.h,
                                    child: Container(
                                      height: 1.h,
                                      color:
                                          index < formController.selectedIndex
                                              ? primaryColor
                                              : grey.withValues(
                                                  alpha: 0.25,
                                                ),
                                    ),
                                  ),

                                // --------------------------------
                                // LINE FROM PREVIOUS STEP
                                // --------------------------------
                                if (index != 0)
                                  Positioned(
                                    left: 0,
                                    right: 40.w,
                                    top: 10.h,
                                    child: Container(
                                      height: 1.h,
                                      color:
                                          index <= formController.selectedIndex
                                              ? primaryColor
                                              : grey.withValues(
                                                  alpha: 0.25,
                                                ),
                                    ),
                                  ),

                                // --------------------------------
                                // STEP CIRCLE
                                // --------------------------------
                                Center(
                                  child: AnimatedContainer(
                                    duration: const Duration(
                                      milliseconds: 250,
                                    ),
                                    width: 20.w,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isCurrent || isCompleted
                                          ? primaryColor
                                          : white,
                                      border: Border.all(
                                        width: 1,
                                        color: isCurrent || isCompleted
                                            ? primaryColor
                                            : grey.withValues(
                                                alpha: 0.4,
                                              ),
                                      ),
                                    ),
                                    child: Center(
                                      child: isCompleted && !isCurrent
                                          ? Icon(
                                              Icons.check,
                                              size: 12.r,
                                              color: Colors.white,
                                            )
                                          : CustomText(
                                              '${index + 1}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 9.sp,
                                                fontWeight: FontWeight.w700,
                                                color: isCurrent
                                                    ? Colors.white
                                                    : grey,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 5.h),

                          // --------------------------------
                          // STEP TITLE
                          // --------------------------------
                          SizedBox(
                            width: 80.w,
                            child: CustomText(
                              formController.headings[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: isCurrent
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isCurrent ? primaryColor : greyDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
