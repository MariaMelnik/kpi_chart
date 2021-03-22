
import 'stacked_history_chart_constraints.dart';

/// Stores all constraints for KpiChart
class StackedHistoryChartSettings {
  final List<StackedHistoryChartConstraints> constraints;

  StackedHistoryChartSettings({List<StackedHistoryChartConstraints> constraints})
      : assert(constraints != null),
        this.constraints = solveIntersections(constraints) ?? List<StackedHistoryChartConstraints>();
  // should not be intersections in constraints. In this case not obvious what constrain we should use
//        assert(constraints.any((KpiChartConstraints con1) => constraints.any((KpiChartConstraints con2) => con1.minVal < con2.maxVal))),
//        assert(constraints.any((KpiChartConstraints con1) => constraints.any((KpiChartConstraints con2) => con1.maxVal > con2.minVal)));


  /// If we have constraints = [constraint1, constraint2], where
  /// constraint1 has minVal = 20 and maxVal = 30 and constraint2 has minVal = 15 and maxVal = 22
  /// In this case it is not obvious what constrain we should use for value 21.
  /// So we need to solve this intersections.
  ///
  /// If we find constraint in list what intersects with another constrain we change second confused value by first.
  /// In case described above we change maxVal of the constraint2 to minVal of the constraint1 and it will be 20.
  static List<StackedHistoryChartConstraints> solveIntersections (List<StackedHistoryChartConstraints> constraints) {
    if (constraints == null) return null;

    List<StackedHistoryChartConstraints> result = List.from(constraints);

    for (int i = 0; i < result.length; i++) {
      StackedHistoryChartConstraints constraint = result[i];
      result = result.map((innerCon) {
        return constraint.maxVal > innerCon.minVal && constraint.maxVal < innerCon.maxVal
            ? innerCon.copyWith(minVal: constraint.maxVal)
            : innerCon;
      }).toList();
    }


    for (int i = 0; i < result.length; i++) {
      StackedHistoryChartConstraints constraint = result[i];
      result = result.map((innerCon) {
        return constraint.minVal < innerCon.maxVal && constraint.minVal > innerCon.minVal
            ? innerCon.copyWith(maxVal: constraint.minVal)
            : innerCon;
      }).toList();
    }

    return result;
  }
}