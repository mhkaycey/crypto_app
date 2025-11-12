import 'package:flutter_riverpod/legacy.dart';

class ChartRange {
  final String label;
  final int days;
  const ChartRange(this.label, this.days);
}

final chartRanges = [
  ChartRange('24H', 1),
  ChartRange('7D', 7),
  ChartRange('30D', 30),
  ChartRange('90D', 90),
  ChartRange('1Y', 365),
];

final selectedChartRangeProvider = StateProvider<ChartRange>(
  (ref) => chartRanges[2],
); // Default 30D
