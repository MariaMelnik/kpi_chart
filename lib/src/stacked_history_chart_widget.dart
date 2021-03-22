import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'stacked_history_chart_constraints.dart';
import 'stacked_history_chart_settings.dart';
import 'stacked_history_chart_utils.dart';
import 'time_series_data.dart';


const String _kDefaultConstrainTitle = "[no dis]";
typedef void SelectedCallback(DateTime selectedTime, DateTime startTime, DateTime endTime, StackedHistoryChartConstraints selectedConstraint);


class StackedHistoryChart extends StatelessWidget {
  /// Map where for each TimeSeriesData key appropriate KpiChartConstraints is defined.
  /// Map is sorted by keys (first value is data with earlier timestamp, last - data with latest).
  final SplayTreeMap<TimeSeriesData, StackedHistoryChartConstraints> dataWithConstraints;
  final SelectedCallback onSelected;

  StackedHistoryChart({Key key, @required List<TimeSeriesData> data, @required StackedHistoryChartSettings decoration, this.onSelected}) :
      assert(data != null),
      assert(decoration != null),
      this.dataWithConstraints = getDataWithConstraints(data, decoration),
      super(key: key);

  /// In order to avoid any chart interpolation between values we need to modify original list of [TimeSeriesData].
  ///
  /// For each [TimeSeriesData] we add new [TimeSeriesData] with the same value and [timestamp] 1 microsecond less next value.
  static List<TimeSeriesData> modifyData (List<TimeSeriesData> origData){
    if (origData == null) return null;

    List<TimeSeriesData> sortedData = List.from(origData);
    sortedData.sort();

    List<TimeSeriesData> result = List<TimeSeriesData>();

    sortedData.forEach((TimeSeriesData data) {
      result.add(data); // add "start" of the period with value

      int index = sortedData.indexOf(data);
      if (index < sortedData.length - 1) {
        TimeSeriesData next = sortedData[index+1];

        DateTime endTs = next.timestamp.subtract(Duration(milliseconds: 1));
        TimeSeriesData end = TimeSeriesData(timestamp: endTs, val: data.val);
        result.add(end); // add "end" of the period with value
      }
    });

    return result;
  }

  /// Generates map where keys are sorted TimeSeriesData and values are appropriated constraints.
  /// If there is no appropriate constraint for some TimeSeriesData object, new constraint for
  /// will be created with minVal == maxVal == skipped value. Color of that constraint is transparent.
  ///
  /// If given [decoration] is null, returns empty SplayTreeMap.
  static SplayTreeMap<TimeSeriesData, StackedHistoryChartConstraints> getDataWithConstraints(List<TimeSeriesData> data, StackedHistoryChartSettings decoration) {
    if (decoration == null) return SplayTreeMap<TimeSeriesData, StackedHistoryChartConstraints>();

    List<TimeSeriesData> sortedModifiedData = modifyData(data);
    var result = SplayTreeMap<TimeSeriesData, StackedHistoryChartConstraints>();
    
    sortedModifiedData.forEach((TimeSeriesData data) {
      StackedHistoryChartConstraints constrain = decoration.constraints
          .firstWhere((c) => c.minVal <= data.val && c.maxVal > data.val, orElse: () => null);
      if (constrain != null) result[data] = constrain;
      else {
        StackedHistoryChartConstraints mockConstrain = StackedHistoryChartConstraints(
          maxVal: data.val,
          minVal: data.val,
          color: Colors.transparent,
          dis: "[no dis]"
        );

        result[data] = mockConstrain;
      }
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    charts.TimeSeriesChart chart = charts.TimeSeriesChart(
      _getSeries(),
      animate: false,
      primaryMeasureAxis: charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
      defaultRenderer: charts.LineRendererConfig(includeArea: true, areaOpacity: 1.0),
      selectionModels: [charts.SelectionModelConfig(
        type: charts.SelectionModelType.info,
        changedListener: _onSelectionChanged
      )],
    );

    return chart;
  }


  void _onSelectionChanged(charts.SelectionModel<DateTime> model) {
    var selectedDatum = model.selectedDatum;

    // time what user actually tapped
    DateTime timeSelected;

    // start time of the range within same constraints as selected
    DateTime timeStart;

    // end time of the range within same constraints as selected
    DateTime timeEnd;

    if (selectedDatum.isNotEmpty) {
      timeSelected = (selectedDatum.first.datum as TimeSeriesData).timestamp;

      TimeSeriesData keyInMap = dataWithConstraints.keys.firstWhere((d) => d.timestamp == timeSelected);
      StackedHistoryChartConstraints selectedConstraint = dataWithConstraints[keyInMap];

      List<TimeSeriesData> keys = dataWithConstraints.keys.toList();
      int selectedIndex = keys.indexOf(keyInMap);

      int lastGoodStartIndex = selectedIndex;
      for (int i = selectedIndex - 1; i >= 0; i--) {
        TimeSeriesData curData = dataWithConstraints.keys.toList()[i];
        if (dataWithConstraints[curData] == selectedConstraint) lastGoodStartIndex = i;
        else break;
      }

      int lastGoodEndIndex = selectedIndex;
      for (int i = selectedIndex + 1; i < dataWithConstraints.keys.length; i++) {
        TimeSeriesData curData = dataWithConstraints.keys.toList()[i];
        if (dataWithConstraints[curData] == selectedConstraint) lastGoodEndIndex = i;
        else break;
      }

      timeStart = dataWithConstraints.keys.toList()[lastGoodStartIndex].timestamp;
      timeEnd = dataWithConstraints.keys.toList()[lastGoodEndIndex].timestamp;

      if (onSelected != null) {
        onSelected(timeSelected, timeStart, timeEnd,selectedConstraint);
      }
    }
  }

  List<charts.Series<TimeSeriesData, DateTime>> _getSeries() {
    Set<StackedHistoryChartConstraints> uniqueConstraints = dataWithConstraints.values.toSet();

    return uniqueConstraints.map((StackedHistoryChartConstraints con) {
      return charts.Series<TimeSeriesData, DateTime>(
        id: con.dis ?? _kDefaultConstrainTitle,
        colorFn: (TimeSeriesData data, __) => data.val == 0 ?  convertColor(Colors.transparent) : convertColor(con.color),
        domainFn: (TimeSeriesData data, _) => data.timestamp,
        measureFn: (TimeSeriesData data, _) => data.val,
        data: _modifyDataWithConstraints(con)
      );
    }).toList();
  }

  /// Modifies original data with given KpiChartConstraints.
  /// If value satisfies constraints - replace it with 1, if no - replace it with 0.
  List<TimeSeriesData> _modifyDataWithConstraints(StackedHistoryChartConstraints con){
    List<TimeSeriesData> modified = dataWithConstraints.keys.map((TimeSeriesData data) {
      num val = 0;
      if (dataWithConstraints[data] == con) val = 1;
      return TimeSeriesData(timestamp: data.timestamp, val: val);
    }).toList();

    return modified;
  }
}

