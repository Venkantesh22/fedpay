import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/drawer_screen/screen/payment_sound_notficantion/payment_sound_notification_screen.dart';
import 'package:lekra/views/screens/kyc_form/kyc_form_screen.dart';
import 'package:lekra/views/screens/transcation_history/transaction_history_screen.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key, t});

  @override
  Widget build(BuildContext context) {
    final List<_QuickActionItem> actions = [
      _QuickActionItem(
        title: 'Collect\nPayment',
        icon: Icons.qr_code_scanner_rounded,
        iconColor: const Color(0xFF16A36A),
        backgroundColor: const Color(0xFFEFFBF5),
        onTap: () {
          navigate(context: context, page: KycFormScreen());
        },
      ),
      _QuickActionItem(
        title: 'Sound Box',
        icon: Icons.volume_up_rounded,
        iconColor: const Color(0xFF7C3AED),
        backgroundColor: const Color(0xFFF5F0FF),
        onTap: () {
          navigate(context: context, page: PaymentSoundNotificationScreen());
        },
      ),
      _QuickActionItem(
        title: 'Transaction\nHistory',
        icon: Icons.receipt_long_outlined,
        iconColor: const Color(0xFF2563EB),
        backgroundColor: const Color(0xFFEEF5FF),
        onTap: () {
          navigate(
            context: context,
            page: TransactionHistoryScreen(
              fromDateValue: DateTime(2024, 1, 1),
              todateValue: getDateTime(),
            ),
          );
        },
      ),
      _QuickActionItem(
        title: 'Bank',
        icon: Icons.account_balance_outlined,
        iconColor: const Color(0xFFF59E0B),
        backgroundColor: const Color(0xFFFFF7E8),
        onTap: () {},
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Quick Actions',
          style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: black,
              ),
        ),
        SizedBox(height: 14.h),
        Row(
          children: List.generate(
            actions.length,
            (index) {
              final action = actions[index];

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == actions.length - 1 ? 0 : 10.w,
                  ),
                  child: _QuickActionCard(
                    item: action,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final _QuickActionItem item;

  const _QuickActionCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(
                      0,
                      2,
                    ),
                    blurRadius: 4,
                    spreadRadius: -1,
                    color: black.withValues(alpha: 0.03),
                  ),
                  BoxShadow(
                    offset: Offset(
                      0,
                      4,
                    ),
                    blurRadius: 6,
                    spreadRadius: -1,
                    color: black.withValues(alpha: 0.05),
                  ),
                ]),
            child: Container(
              width: 58.w,
              height: 58.w,
              decoration: BoxDecoration(
                color: item.backgroundColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                item.icon,
                color: item.iconColor,
                size: 27.r,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 34.h,
            child: CustomText(
              item.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.2,
                fontWeight: FontWeight.w600,
                color: black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionItem {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const _QuickActionItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.onTap,
  });
}
