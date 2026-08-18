import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';
import 'package:lekra/views/screens/demo/screen/demo_screen.dart';
import 'package:lekra/views/screens/demo/screen/screen_mode.dart';

// ✅ import your actual Home page

class DemoDashboardScreen extends StatefulWidget {
  const DemoDashboardScreen({super.key});

  @override
  State<DemoDashboardScreen> createState() => _DemoDashboardScreenState();
}

class _DemoDashboardScreenState extends State<DemoDashboardScreen> {
  final PageController _pageController = PageController();
  List<Widget> pages = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BasicController>().demoPageSet = 0;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only initialize once
    if (!_isInitialized) {
      // ✅ Now it is safe to use getDemoData(context)
      final dataList = getDemoData(context);
      pages =
          dataList.map((data) => DemoScreen(demoScreenModel: data)).toList();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ✅ Added _onBack to slide left
  void _onBack(BasicController controller) {
    if (controller.demoPage > 0) {
      controller.demoPageSet = controller.demoPage - 1;
      _pageController.animateToPage(
        controller.demoPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onNext(BasicController controller) async {
    if (controller.demoPage < pages.length - 1) {
      controller.demoPageSet = controller.demoPage + 1;
      _pageController.animateToPage(
        controller.demoPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      await Get.find<BasicController>().setIsDemoSave(true);
      navigate(
          context: context, page: const LoginScreen(), isRemoveUntil: true);
    }
  }

  void _onSkip() async {
    await Get.find<BasicController>().setIsDemoSave(true);
    navigate(context: context, page: const LoginScreen(), isRemoveUntil: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Stack to overlay skip button on top of pages
      body: Stack(
        children: [
          GetBuilder<BasicController>(
            builder: (controller) {
              return PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  controller.demoPageSet = index;
                },
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: pages[index],
                ),
              );
            },
          ),

          // 🔹 Skip Button (Top Right)
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, right: 20),
                child: TextButton(
                  onPressed: _onSkip,
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child:
                      GetBuilder<BasicController>(builder: (basicController) {
                    return Text(basicController.demoPage < pages.length - 1
                        ? "Skip"
                        : "Done");
                  }),
                ),
              ),
            ),
          ),
        ],
      ),

      // 🔹 Bottom Indicators + NEXT Button
      bottomNavigationBar: SafeArea(
        child: GetBuilder<BasicController>(
          builder: (controller) {
            final demoData = getDemoData(context);
            bool isFirstPage = controller.demoPage == 0;
            bool isLastPage = controller.demoPage == demoData.length - 1;
            return SizedBox(
              height: 80.h,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20.w, right: 20.w, bottom: 0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, 
                          children: [
                            // 1️⃣ Left Arrow (Back)
                            // Using Visibility to hide it on the first page, but keep the layout centered
                            Visibility(
                              visible: !isFirstPage,
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              child: IconButton(
                                onPressed: () => _onBack(controller),
                                icon:
                                    Icon(Icons.arrow_back, color: primaryColor),
                              ),
                            ),

                            // 2️⃣ Center Dots
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                demoData.length,
                                (index) {
                                  bool isSelected =
                                      controller.demoPage == index;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: 10.h,
                                    width: isSelected ? 24.w : 10.w,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 4.w),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? primaryColor
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // 3️⃣ Right Arrow (Next/Done)
                            FloatingActionButton(
                              elevation: 0,
                              mini: true,
                              backgroundColor: primaryColor,
                              onPressed: () => _onNext(controller),
                              child: Icon(
                                isLastPage ? Icons.check : Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      sizedBoxHeight(height: 10.h)
                    ],
                  ),
                  Positioned(
                    bottom: -500.h,
                    top: 50.h,
                    right: -350.w,
                    left: 10.w,
                    child: Container(
                      height: 1000.h,
                      width: 1000.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: secondaryColor),
                    ),
                  ),
                  Positioned(
                    bottom: -400.h,
                    top: 30.h,
                    left: -100.w,
                    right: 30.w,
                    child: Container(
                      height: 500.h,
                      width: 500.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: backgroundLight),
                    ),
                  ),
                  Positioned(
                    bottom: -400.w,
                    top: 25.h,
                    left: -130.w,
                    right: 80.w,
                    child: Container(
                      height: 500.h,
                      width: 500.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: primaryColor),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
