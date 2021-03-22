import 'dart:ui';

class StackedHistoryChartConstraints {
  final num minVal;
  final num maxVal;
  final Color color;
  final String dis; // description of the constraint

  StackedHistoryChartConstraints copyWith({num minVal, num maxVal, Color color, String dis}) {
    return StackedHistoryChartConstraints(
        minVal: minVal ?? this.minVal,
        maxVal: maxVal ?? this.maxVal,
        color: color ?? this.color,
        dis: dis ?? this.dis
    );
  }

  const StackedHistoryChartConstraints({num minVal, num maxVal, this.color, this.dis})
      : assert(minVal != null || maxVal != null),
        assert((minVal != null && maxVal != null)
            ? minVal <= maxVal
            : true),
        assert(color != null),
        this.maxVal = maxVal ?? double.infinity,
        this.minVal = minVal ?? -double.infinity;
}