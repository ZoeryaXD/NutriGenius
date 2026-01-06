import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyReportCard extends StatelessWidget {
  final List<double> weeklyCalories;
  final double totalCalories;
  final double dailyAverage;

  const WeeklyReportCard({
    super.key,
    required this.weeklyCalories,
    required this.totalCalories,
    required this.dailyAverage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Teks
        const Text(
          "LAPORAN MINGGUAN",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Total Kalori Minggu ini:",
          style: TextStyle(color: Colors.grey[600]),
        ),
        Text(
          "${totalCalories.toStringAsFixed(0)} kkal (Avg: ${dailyAverage.toStringAsFixed(0)}/hari)",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 20),

        // Grafik Chart
        Container(
          height: 250,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: LineChart(_mainData()),
        ),
      ],
    );
  }

  LineChartData _mainData() {
    return LineChartData(
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 500,
        verticalInterval: 1,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey,
              );
              Widget text;
              switch (value.toInt()) {
                case 0:
                  text = const Text('Sen', style: style);
                  break;
                case 1:
                  text = const Text('Sel', style: style);
                  break;
                case 2:
                  text = const Text('Rab', style: style);
                  break;
                case 3:
                  text = const Text('Kam', style: style);
                  break;
                case 4:
                  text = const Text('Jum', style: style);
                  break;
                case 5:
                  text = const Text('Sab', style: style);
                  break;
                case 6:
                  text = const Text('Min', style: style);
                  break;
                default:
                  text = const Text('', style: style);
              }
              // Gunakan meta.axisSide sesuai versi terbaru
              return SideTitleWidget(axisSide: meta.axisSide, child: text);
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 3000,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(weeklyCalories.length, (index) {
            return FlSpot(index.toDouble(), weeklyCalories[index]);
          }),
          isCurved: true,
          color: Colors.green,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.green.withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}
