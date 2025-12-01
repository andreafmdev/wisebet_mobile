import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';

/// Widget per grafico dei profitti
class ProfitChartWidget extends StatelessWidget {
  final List<double> profits;
  final List<String> labels;
  final bool isLineChart;

  const ProfitChartWidget({
    super.key,
    required this.profits,
    required this.labels,
    this.isLineChart = true,
  });

  @override
  Widget build(BuildContext context) {
    if (profits.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text('Nessun dato disponibile'),
        ),
      );
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: isLineChart ? _buildLineChart() : _buildBarChart(),
    );
  }

  Widget _buildLineChart() {
    final minY = profits.reduce((a, b) => a < b ? a : b) * 0.9;
    final maxY = profits.reduce((a, b) => a > b ? a : b) * 1.1;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.mediumBlue.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: labels.length > 7 ? 2 : 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < labels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      labels[index],
                      style: AppTextStyles.caption,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '€${value.toStringAsFixed(0)}',
                  style: AppTextStyles.caption,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: AppColors.mediumBlue.withOpacity(0.3),
          ),
        ),
        minX: 0,
        maxX: (profits.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: profits.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value);
            }).toList(),
            isCurved: true,
            color: AppColors.accentGold,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.accentGold.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final maxY = profits.reduce((a, b) => a > b ? a : b) * 1.2;

    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.mediumBlue.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: labels.length > 7 ? 2 : 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < labels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      labels[index],
                      style: AppTextStyles.caption,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '€${value.toStringAsFixed(0)}',
                  style: AppTextStyles.caption,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: AppColors.mediumBlue.withOpacity(0.3),
          ),
        ),
        minY: 0,
        maxY: maxY,
        barGroups: profits.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value,
                color: AppColors.accentGold,
                width: 16,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

