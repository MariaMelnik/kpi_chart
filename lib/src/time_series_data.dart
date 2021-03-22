import 'package:meta/meta.dart';

@immutable
class TimeSeriesData implements Comparable<TimeSeriesData>{
  final DateTime timestamp;
  final num val;

  const TimeSeriesData({this.timestamp, this.val})
      : assert(timestamp != null),
        assert(val != null);

  int compareTo(TimeSeriesData other) {
    if (this.timestamp.isAfter(other.timestamp)) return 1;
    else if (this.timestamp.isBefore(other.timestamp)) return -1;
    else return 0;
  }
}
