import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lekra/controllers/report_contoller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';

class HourlyPoint {
  final DateTime time;
  final double value;
  HourlyPoint(this.time, this.value);
}

class TodayHourlyGraph extends StatefulWidget {
  final List<double>? hoursData;
  final String title;
  const TodayHourlyGraph({
    super.key,
    this.hoursData,
    this.title = "Latest Transaction Report",
  });

  @override
  State<TodayHourlyGraph> createState() => _TodayHourlyGraphState();
}

class _TodayHourlyGraphState extends State<TodayHourlyGraph> {
  late TooltipBehavior _tooltipBehavior;
  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior =
        TooltipBehavior(enable: true, format: 'point.x : ₹point.y');
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: const InteractiveTooltip(enable: true),
      markerSettings: const TrackballMarkerSettings(
        markerVisibility: TrackballVisibilityMode.visible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (reportController) {
      // defensive local alias
      final points = reportController.graphDataList;

      // safe totals
      final rawTotal = reportController.totalRawAmount; // NEW FIELD

      // safe peak: use fold to avoid reduce on empty
      final peak = points.isEmpty
          ? 0.0
          : points
              .map((e) => e.value)
              .fold<double>(double.negativeInfinity, (prev, v) => max(prev, v));

      // when loading show skeleton; when loaded but empty show friendly placeholder
      final bool showEmptyPlaceholder =
          !reportController.isLoading && points.isEmpty;

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding:  EdgeInsets.all(12.0.w),
          child: Column(
            children: [
              // Title row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomText(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  CustomText(
                    "Today",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              sizedBoxHeight(height: 12),

              // Chart or placeholder
              CustomShimmer(
                isLoading: reportController.isLoading,
                child: SizedBox(
                  height: 260.h,
                  child: showEmptyPlaceholder
                      ? Center(
                          child: Text(
                            "No transactions to display",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : SfCartesianChart(
                          margin:  EdgeInsets.only(
                              top: 8.h, bottom: 8.h, left: 0, right: 8.w),
                          tooltipBehavior: _tooltipBehavior,
                          trackballBehavior: _trackballBehavior,
                          primaryXAxis: DateTimeAxis(
                            edgeLabelPlacement: EdgeLabelPlacement.shift,
                            intervalType: DateTimeIntervalType.hours,
                            dateFormat: DateFormat('HH:mm'),
                            majorGridLines: const MajorGridLines(width: 0),
                            interval: 3,
                          ),
                          primaryYAxis: NumericAxis(
                            numberFormat: NumberFormat.compactCurrency(
                              decimalDigits: 0,
                              locale: 'en_IN',
                              symbol: '₹',
                            ),
                            labelFormat: '{value}',
                            axisLine: const AxisLine(width: 0),
                            majorTickLines: const MajorTickLines(size: 0),
                          ),
                          series: <CartesianSeries>[
                            SplineAreaSeries<HourlyPoint, DateTime>(
                              dataSource: points,
                              xValueMapper: (d, i) => d.time,
                              yValueMapper: (d, i) => d.value,
                              color: primaryColor.withValues(alpha: 0.10),
                              borderColor:
                                  Theme.of(context).colorScheme.primary,
                              borderWidth: 2,
                              splineType: SplineType.natural,
                              markerSettings: const MarkerSettings(
                                  isVisible: true, width: 4, height: 4),
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: false),
                              enableTooltip: true,
                            ),
                          ],
                          zoomPanBehavior: ZoomPanBehavior(
                              enablePanning: true, enablePinching: true),
                        ),
                ),
              ),

              sizedBoxHeight(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomShimmer(
                    isLoading: reportController.isLoading,
                    child: Text(
                      "Total: ₹${rawTotal.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  CustomShimmer(
                    isLoading: reportController.isLoading,
                    child: Text(
                      "Peak: ₹${(peak.isInfinite ? 0.0 : peak).toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
