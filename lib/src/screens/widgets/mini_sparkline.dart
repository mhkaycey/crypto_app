import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MiniSparkline extends StatelessWidget {
  final List<double> data;
  final bool isPositive;
  const MiniSparkline({
    super.key,
    required this.data,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(width: 80, height: 89);
    }

    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();
    final minY = data.reduce((min, element) => min < element ? min : element);
    final maxY = data.reduce((max, element) => max > element ? max : element);
    final color = isPositive ? Colors.green : Colors.red;

    return SizedBox(
      width: 90,
      height: 30,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          backgroundColor: Colors.transparent,
          minX: 0,
          maxX: spots.length.toDouble() - 1,
          minY: minY * 0.98,
          maxY: maxY * 1.02,
          lineBarsData: [
            LineChartBarData(
              preventCurveOvershootingThreshold: 0,
              preventCurveOverShooting: true,
              isStrokeCapRound: true,
              aboveBarData: BarAreaData(show: true, color: Colors.transparent),
              spots: spots,
              isCurved: true,
              barWidth: 1,
              shadow: const Shadow(
                color: Colors.black,
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
              dotData: FlDotData(show: false),
              color: Colors.greenAccent,
            ),
            // LineChartBarData(
            //   preventCurveOvershootingThreshold: 0,
            //   preventCurveOverShooting: true,
            //   spots: spots,
            //   isCurved: false,
            //   color: color,
            //   barWidth: 1,
            //   dotData: FlDotData(show: false),
            //   belowBarData: BarAreaData(show: true, color: color),
            // ),
          ],
        ),
      ),
    );
  }
}
