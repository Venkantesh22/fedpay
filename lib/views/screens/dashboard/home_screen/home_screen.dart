import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/report_contoller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/graph.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/income_overview_section.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/kyc_pending_card.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/merchant_profile_card.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/quick_acitons_section/quick_actions_section.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/transaction_history_section.dart';
import 'package:lekra/views/screens/kyc_form/kyc_form_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isReload;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeScreen(
      {super.key, this.isReload = false, required this.scaffoldKey});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log("initState tap");

      final auth = Get.find<AuthController>();
      final reportContro = Get.find<ReportController>();

      if (widget.isReload) {
        auth.checkBalance().then((value) {
          if (value.isSuccess) {
            if (auth.userModel?.isKYCDone ?? false) {
              Get.find<BasicController>().postGenerateQR();
            }

            final dateFormat = DateFormat('yyyy-MM-dd');

            Get.find<ReportController>()
                .fetchYesBankMerchantCollection(
              fromdate: dateFormat.format(getDateTime()),
              todate: dateFormat.format(getDateTime()),
            )
                .then((value) {
              if (value.isSuccess) {
                reportContro.convertTODataForGraph(
                    reportContro.yesBankMerchantCollectionList);
              }
            });

            reportContro.fetchTransactionReport(
                fromdate: dateFormat.format(getDateTime()),
                todate: dateFormat.format(getDateTime()),
                isShowOnly10: true);
          } else {
            auth.logout(context);
            navigate(context: context, page: LoginScreen());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 2,
        leading: IconButton(
            onPressed: () {
              widget.scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: primaryColor,
            )),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              AppConstants.appName,
              style: Helper(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            CustomText(
              "UPI Merchant",
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ],
        ),
        // actions: [
        //   GestureDetector(
        //       onTap: () {
        //         navigate(context: context, page: const WalletScreen());
        //       },
        //       child: Icon(
        //         Icons.account_balance_wallet_outlined,
        //         size: 24,
        //         color: primaryColor,
        //       )),
        //   sizedBoxWidth(
        //     width: 28,
        //   )
        // ],
      ),
      body: GetBuilder<AuthController>(builder: (authController) {
        if (authController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          // scroll the last transaction above the floating navigation bar.
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // RechargeAndPaySection(),
              // SizedBox(
              //   height: 20,
              // ),

//* Profile controller
              MerchantProfileCard(),
              sizedBoxHeight(height: 24),
//* Kyc verification section
              !(authController.userModel?.isKYCDone ?? false)
                  ? KycPendingCard(
                      kycStatus: "Not apply",
                      onTap: () {
                        navigate(context: context, page: KycFormScreen());
                      },
                    )
                  : SizedBox(),

              //* Quick action section

              sizedBoxHeight(height: 18),
              QuickActionsSection(),

              // SizedBox(height: 20.h),
              // IncomeOverviewSection(),
              // TodayHourlyGraph(),
              SizedBox(
                height: 31,
              ),
              TransactionHistoryWidget()
            ],
          ),
        );
      }),
    );
  }
}
