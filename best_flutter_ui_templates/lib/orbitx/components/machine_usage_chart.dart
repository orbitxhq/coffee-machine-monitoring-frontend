import 'package:best_flutter_ui_templates/orbitx/orbitx_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MachineUsageChart extends StatefulWidget {
  final List<double>? points;
  final AnimationController? animationController;
  final Animation<double>? animation;

  const MachineUsageChart({
    Key? key,
    this.points,
    this.animationController,
    this.animation,
  }) : super(key: key);

  @override
  State<MachineUsageChart> createState() => _MachineUsageChartState();
}

class _MachineUsageChartState extends State<MachineUsageChart> {
  List<String> get hours => [
        '00',
        '01',
        '02',
        '03',
        '04',
        '05',
        '06',
        '07',
        '08',
        '09',
        '10',
        '11',
        '12',
        '13',
        '14',
        '15',
        '16',
        '17',
        '18',
        '19',
        '20',
        '21',
        '22',
        '23',
      ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            AspectRatio(
              aspectRatio: 1.70,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 12,
                  top: 24,
                  bottom: 12,
                ),
                child: BarChart(loadData(widget.points)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamically determine label density
    int labelDensity = screenWidth > 500 ? 1 : 2; // Show every 1st or 2nd label

    // Adjust font size based on screen width
    double fontSize = screenWidth > 500 ? 12 : 10;

    // Skip labels based on density
    if (value.toInt() % labelDensity != 0) {
      return const SizedBox(); // Return empty space for skipped labels
    }

    const style = TextStyle(
      fontWeight: FontWeight.w400,
    );

    Widget text;
    if (value.toInt() >= 0 && value.toInt() <= 23) {
      text = Text(
        hours[value.toInt()],
        style: style.copyWith(fontSize: fontSize),
      );
    } else {
      text = const Text('');
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Transform.rotate(
        angle: screenWidth > 500
            ? 0
            : -0.3, // Rotate labels slightly on small screens
        child: text,
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value.toInt().toString(),
        style: style,
      ),
    );
  }

  BarChartData loadData(List<double>? data) {
    return BarChartData(
      barGroups: widget.points
              ?.asMap()
              .entries
              .map((entry) => BarChartGroupData(
                    x: entry.key, // Use index as the x value
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        width: 10,
                        borderRadius: BorderRadius.circular(4),
                        color: ORBITXTheme.nearlyDarkBlue,
                      ),
                    ],
                  ))
              .toList() ??
          [],
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          axisNameWidget: const Text(
            'Hour',
            style: ORBITXTheme.body1,
          ),
          axisNameSize: 24, // Space for the axis title
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: bottomTitleWidgets,
            reservedSize: 30,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(show: true),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${group.x}: ${rod.toY.toStringAsFixed(2)}',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
    );
  }
}
