import 'package:flutter/material.dart';
import 'package:kpi_chart/stacked_history_chart.dart';

class StackedHistoryChartMockData {
//  static List<TimeSeriesData> data = [
//    TimeSeriesData(timestamp: DateTime(2019, 5, 1, 0, 15), val: 10),
//    TimeSeriesData(timestamp: DateTime(2019, 5, 1, 1, 15), val: 13),
//    TimeSeriesData(timestamp: DateTime(2019, 5, 1, 2, 15), val: 19),
//    TimeSeriesData(timestamp: DateTime(2019, 5, 1, 3, 15), val: 25),
//    TimeSeriesData(timestamp: DateTime(2019, 5, 1, 4, 15), val: 28),
//    TimeSeriesData(timestamp: DateTime(2019, 5, 1, 5, 15), val: 100),
////    TimeSeriesData(timestamp: DateTime(2019, 5, 1, 5, 16), val: 30),
//    TimeSeriesData(timestamp: DateTime(2019, 5, 1, 6, 15), val: 115),
//    TimeSeriesData(timestamp: DateTime(2019, 5, 1, 6, 15), val: 60),
//    TimeSeriesData(timestamp: DateTime(2019, 5, 1, 7, 15), val: 5),
////    TimeSeriesData(timestamp: DateTime(2019, 5, 1, 7, 15), val: 70),
//    TimeSeriesData(timestamp: DateTime(2019, 5, 1, 8, 15), val: 5),
////    TimeSeriesData(timestamp: DateTime(2019, 5, 1, 8, 15), val: 100),
//    TimeSeriesData(timestamp: DateTime(2019, 5, 1, 9, 15), val: 5),
////    TimeSeriesData(timestamp: DateTime(2019, 5, 1, 9, 15), val: 115),
//  ];

  static List<TimeSeriesData> data = [
    TimeSeriesData(timestamp: DateTime(2020, 4, 1, 0, 0), val: 20),
    TimeSeriesData(timestamp: DateTime(2020, 4, 1, 0, 1), val: 30),
    TimeSeriesData(timestamp: DateTime(2020, 4, 1, 0, 2), val: 40),
    TimeSeriesData(timestamp: DateTime(2020, 4, 1, 0, 3), val: 25),
    TimeSeriesData(timestamp: DateTime(2020, 4, 1, 0, 4), val: 45),
    TimeSeriesData(timestamp: DateTime(2020, 4, 1, 0, 5), val: 30),
  ];


  static List<StackedHistoryChartConstraints> constraints = [
    StackedHistoryChartConstraints(dis: "30-50", minVal:30.0, maxVal: 50, color: Color(0xff0097a7)),
    StackedHistoryChartConstraints(dis: "50-60", minVal: 50, maxVal: 60, color: Color(0xff43a047)),
    StackedHistoryChartConstraints(dis: "65-77", minVal: 65, maxVal: 77, color: Color(0xffc2185b)),
  ];

//  static List<StackedHistoryChartConstraints> constraints = [
//    StackedHistoryChartConstraints(dis: "max: 13", maxVal: 13.1, color: Colors.green),
//    StackedHistoryChartConstraints(dis: "18-30", minVal: 18, maxVal: 30, color: Colors.yellow),
//    StackedHistoryChartConstraints(dis: "25-60", minVal: 25, maxVal: 60, color: Colors.purple),
////    KpiChartConstraints(dis: "27-29", minVal: 27, maxVal: 29, color: Colors.black),
//    StackedHistoryChartConstraints(dis: "58-90", minVal: 58, maxVal: 90, color: Colors.blue),
//    StackedHistoryChartConstraints(dis: "min: 93", minVal: 93, color: Colors.red),
//  ];

  static StackedHistoryChartSettings decoration = StackedHistoryChartSettings(constraints: constraints);
}