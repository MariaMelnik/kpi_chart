import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'stacked_history_chart_constraints.dart';
import 'stacked_history_chart_settings.dart';
import 'time_series_data.dart';

import 'package:collection/collection.dart';


const String _kDefaultConstrainTitle = "[no dis]";
typedef void SelectedCallback(DateTime selectedTime, DateTime startTime, DateTime endTime, StackedHistoryChartConstraints selectedConstraint);


class StackedHistoryChart extends StatelessWidget {
  /// Map where for each TimeSeriesData key appropriate KpiChartConstraints is defined.
  /// Map is sorted by keys (first value is data with earlier timestamp, last - data with latest).
  final SplayTreeMap<StackedHistoryChartSectorData, StackedHistoryChartConstraints> dataWithConstraints;
  final SelectedCallback? onSelected;

  StackedHistoryChart({
    Key? key,
    required List<TimeSeriesData> data,
    required StackedHistoryChartSettings decoration,
    this.onSelected
  }) :
      assert(data != null),
      assert(decoration != null),
      this.dataWithConstraints = getDataWithConstraints(data, decoration),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: _getChartBars(),
        titlesData: _titlesData,
        lineTouchData: _lineTouchData
      ),
    );
  }


  LineTouchData get _lineTouchData {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: _getTooltipItems
      ),
      touchCallback: _onTouch,
      handleBuiltInTouches: false,
    );
  }

  List<LineTooltipItem?> _getTooltipItems(List<LineBarSpot> touchedSpots) {
    // todo
    return [];
  }

  void _onTouch(LineTouchResponse touchResponse) {
    //todo
  }

  FlTitlesData get _titlesData {
    return FlTitlesData(
      bottomTitles: SideTitles(
          showTitles: true,
          getTitles: _getBottomTitle
      ),
      leftTitles: SideTitles(
          getTitles: _getLeftTitle
      ),
    );
  }


  // No need any left titles for this chart.
  String _getLeftTitle(_) => "";

  String _getBottomTitle(double val) {
    // todo
    return "";
  }

  List<LineChartBarData> _getChartBars() {
    List<LineChartBarData> result = [];

    final List<StackedHistoryChartSectorData> keys = dataWithConstraints.keys.toList();

    final zeroX = keys.first.start.millisecondsSinceEpoch;

    for (int i = 0; i< keys.length ; i++) {
      final timeSeriesData = keys[i];
      final start = timeSeriesData.start.millisecondsSinceEpoch - zeroX;
      final end = timeSeriesData.end.millisecondsSinceEpoch - zeroX;
      final color = dataWithConstraints[timeSeriesData]!.color;

      final barChart = LineChartBarData(
        dotData: FlDotData(show: false),
        spots: [
          FlSpot(start.toDouble() - 0.00001, 0),
          FlSpot(start.toDouble(), 1),
          FlSpot(end.toDouble() - 0.000001, 1),
          FlSpot(end.toDouble(), 0),
        ],
        colors: [color],
        belowBarData: BarAreaData(colors: [color], show: true)
      );
      result.add(barChart);
    }

    return result;
  }

  // void _onSelectionChanged(charts.SelectionModel<DateTime> model) {
  //   var selectedDatum = model.selectedDatum;
  //
  //   // time what user actually tapped
  //   DateTime timeSelected;
  //
  //   // start time of the range within same constraints as selected
  //   DateTime timeStart;
  //
  //   // end time of the range within same constraints as selected
  //   DateTime timeEnd;
  //
  //   if (selectedDatum.isNotEmpty) {
  //     timeSelected = (selectedDatum.first.datum as TimeSeriesData).timestamp;
  //
  //     TimeSeriesData keyInMap = dataWithConstraints.keys.firstWhere((d) => d.timestamp == timeSelected);
  //     StackedHistoryChartConstraints selectedConstraint = dataWithConstraints[keyInMap]!;
  //
  //     List<TimeSeriesData> keys = dataWithConstraints.keys.toList();
  //     int selectedIndex = keys.indexOf(keyInMap);
  //
  //     int lastGoodStartIndex = selectedIndex;
  //     for (int i = selectedIndex - 1; i >= 0; i--) {
  //       TimeSeriesData curData = dataWithConstraints.keys.toList()[i];
  //       if (dataWithConstraints[curData] == selectedConstraint) lastGoodStartIndex = i;
  //       else break;
  //     }
  //
  //     int lastGoodEndIndex = selectedIndex;
  //     for (int i = selectedIndex + 1; i < dataWithConstraints.keys.length; i++) {
  //       TimeSeriesData curData = dataWithConstraints.keys.toList()[i];
  //       if (dataWithConstraints[curData] == selectedConstraint) lastGoodEndIndex = i;
  //       else break;
  //     }
  //
  //     timeStart = dataWithConstraints.keys.toList()[lastGoodStartIndex].timestamp;
  //     timeEnd = dataWithConstraints.keys.toList()[lastGoodEndIndex].timestamp;
  //
  //     if (onSelected != null) {
  //       onSelected!(timeSelected, timeStart, timeEnd,selectedConstraint);
  //     }
  //   }
  // }



  /// Generates map where keys are sorted TimeSeriesData
  /// and values are appropriated constraints.
  ///
  /// If there is no appropriate constraint for some TimeSeriesData object,
  /// new constraint for will be created with minVal == maxVal == skipped value.
  /// Color of that constraint is transparent.
  ///
  /// If given [decoration] is null, returns empty SplayTreeMap.
  static SplayTreeMap<StackedHistoryChartSectorData, StackedHistoryChartConstraints> getDataWithConstraints(
      List<TimeSeriesData> data,
      StackedHistoryChartSettings? decoration
      ) {
    if (decoration == null) return SplayTreeMap<StackedHistoryChartSectorData, StackedHistoryChartConstraints>();

    List<StackedHistoryChartSectorData> sortedModifiedData = modifyData(data);
    var result = SplayTreeMap<StackedHistoryChartSectorData, StackedHistoryChartConstraints>();

    sortedModifiedData.forEach((StackedHistoryChartSectorData data) {
      StackedHistoryChartConstraints? constrain = decoration.constraints
          .firstWhereOrNull((c) => c.minVal <= data.val && c.maxVal > data.val);

      if (constrain != null) {
        result[data] = constrain;
      }

      else {
        StackedHistoryChartConstraints mockConstrain = StackedHistoryChartConstraints(
            maxVal: data.val,
            minVal: data.val,
            color: Colors.transparent,
            dis: _kDefaultConstrainTitle
        );

        result[data] = mockConstrain;
      }
    });

    return result;
  }

  /// In order to avoid any chart interpolation between values
  /// we need to modify original list of [TimeSeriesData].
  ///
  /// For each [TimeSeriesData] we add new [TimeSeriesData] with the same value
  /// and [timestamp] 1 microsecond less next value.
  static List<StackedHistoryChartSectorData> modifyData (List<TimeSeriesData> origData){
    List<TimeSeriesData> sortedData = List.from(origData);
    sortedData.sort();

    List<StackedHistoryChartSectorData> result = <StackedHistoryChartSectorData>[];

    sortedData.forEach((TimeSeriesData data) {
      final startTs = data.timestamp;
      DateTime endTs = startTs;

      int index = sortedData.indexOf(data);
      if (index < sortedData.length - 1) {
        TimeSeriesData next = sortedData[index+1];
        endTs = next.timestamp.subtract(Duration(milliseconds: 1));
      }

      final sectorData = StackedHistoryChartSectorData(
        start: startTs,
        end: endTs,
        val: data.val
      );

      result.add(sectorData);
    });


    return result;
  }
}

