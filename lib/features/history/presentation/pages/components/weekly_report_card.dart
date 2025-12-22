import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyReportCard extends StatelessWidget {
  final List<double> weeklyData;
  final double targetCalories;

  const WeeklyReportCard({
    super.key,
    required this.weeklyData,
    this.targetCalories = 2000,
  });

  @override
  Widget build(BuildContext context) {
    final double totalCalories = weeklyData.fold(0, (sum, item) => sum + item);
    final int averageCalories = (totalCalories / weeklyData.length).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.spa, color: Color(0xFF2E7D32)),
              Text(
                'NutriGenius',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const Text(
            'LAPORAN MINGGUAN',
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          const Text(
            'Total Kalori Minggu Ini',
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
          const SizedBox(height: 4),

          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Color(0xFF2E7D32),
                fontFamily: 'Roboto',
              ),
              children: [
                TextSpan(
                  text: '${totalCalories.toInt()} kkal',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: '(Rata-rata: $averageCalories/hari)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(height: 220, child: LineChart(_mainData())),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem(Colors.deepPurpleAccent, 'Realisasi'),
              _buildLegendItem(Colors.redAccent.withOpacity(0.5), 'Target'),
              _buildLegendItem(Colors.blue, '2000'),
              _buildLegendItem(Colors.orange, '1500'),
            ],
          ),
        ],
      ),
    );
  }

  LineChartData _mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 750,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.15),
            strokeWidth: 1,
            dashArray: [5, 5],
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.15),
            strokeWidth: 1,
            dashArray: [5, 5],
          );
        },
      ),

      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: _bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42,
            interval: 750,
            getTitlesWidget: _leftTitleWidgets,
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
          spots: [FlSpot(0, targetCalories), FlSpot(6, targetCalories)],
          isCurved: false,
          color: Colors.redAccent.withOpacity(0.5),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),

        LineChartBarData(
          spots: _generateSpots(),
          isCurved: true,
          color: Colors.deepPurpleAccent,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: Colors.deepPurpleAccent,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.deepPurpleAccent.withOpacity(0.3),
                Colors.deepPurpleAccent.withOpacity(0.0),
              ],
              begin: AlignmentGeometry.topCenter,
              end: AlignmentGeometry.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _generateSpots() {
    if (weeklyData.isEmpty)
      return List.generate(7, (index) => FlSpot(index.toDouble(), 0));

    return weeklyData.asMap().entries.map((e) {
      if (e.key > 6) return const FlSpot(0, 0);
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Senin', style: style);
        break;
      case 1:
        text = const Text('Selasa', style: style);
        break;
      case 2:
        text = const Text('Rabu', style: style);
        break;
      case 3:
        text = const Text('Kamis', style: style);
        break;
      case 4:
        text = const Text('Jumat', style: style);
        break;
      case 5:
        text = const Text('Sabtu', style: style);
        break;
      case 6:
        text = const Text('Minggu', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return Padding(
      padding: const EdgeInsetsGeometry.only(top: 8.0),
      child: text,
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    return Text(
      value.toInt().toString(),
      style: style,
      textAlign: TextAlign.left,
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: color, width: 2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
