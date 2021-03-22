import 'package:meta/meta.dart';

@immutable
class TimeSeriesData implements Comparable<TimeSeriesData>{
  final DateTime timestamp;
  final num val;

  const TimeSeriesData({
    required this.timestamp,
    required this.val
  })
      : assert(timestamp != null),
        assert(val != null);

  int compareTo(TimeSeriesData other) {
    if (this.timestamp.isAfter(other.timestamp)) return 1;
    else if (this.timestamp.isBefore(other.timestamp)) return -1;
    else return 0;
  }
}


class StackedHistoryChartSectorData implements Comparable<StackedHistoryChartSectorData>{
  final DateTime start;
  final DateTime end;
  final num val;

  StackedHistoryChartSectorData({
    required this.start,
    required this.end,
    required this.val
  });

  int compareTo(StackedHistoryChartSectorData other) {
    if (this.start.isAfter(other.start)) return 1;
    else if (this.start.isBefore(other.start)) return -1;
    else return 0;
  }
}
