import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  final String userId;
  const StatisticsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: true),
            titlesData: const FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, interval: 2, reservedSize: 40),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 30),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 3),
                  FlSpot(1, 4),
                  FlSpot(2, 6),
                  FlSpot(3, 8),
                  FlSpot(4, 5),
                  FlSpot(5, 7),
                  FlSpot(6, 9),
                ],
                isCurved: true,
                color: Colors.blue,
                barWidth: 4,
                isStrokeCapRound: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
