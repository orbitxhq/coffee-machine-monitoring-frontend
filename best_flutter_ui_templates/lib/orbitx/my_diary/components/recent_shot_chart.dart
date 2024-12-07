import 'package:best_flutter_ui_templates/orbitx/orbitx_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RecentShotStatsChart extends StatefulWidget {
  final List<double>? points; // Shot stats values
  final List<DateTime>? timestamps; // Corresponding timestamps
  final AnimationController? animationController;
  final Animation<double>? animation;

  const RecentShotStatsChart({
    Key? key,
    this.points,
    this.timestamps,
    this.animationController,
    this.animation,
  }) : super(key: key);

  @override
  State<RecentShotStatsChart> createState() => _RecentShotStatsChartState();
}

class _RecentShotStatsChartState extends State<RecentShotStatsChart> {
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
                child: LineChart(loadData(widget.points, widget.timestamps)),
              ),
            ),
          ],
        );
      },
    );
  }

  LineChartData loadData(List<double>? points, List<DateTime>? timestamps) {
    final lineBars = points != null && timestamps != null
        ? <LineChartBarData>[
            LineChartBarData(
              spots: List.generate(
                points.length,
                (index) => FlSpot(
                  timestamps[index].millisecondsSinceEpoch.toDouble(),
                  points[index],
                ),
              ),
              isCurved: true,
              color: ORBITXTheme.nearlyDarkBlue,
              barWidth: 4,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    ORBITXTheme.nearlyDarkBlue.withOpacity(0.3),
                    ORBITXTheme.nearlyDarkBlue.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ]
        : <LineChartBarData>[];

    return LineChartData(
      lineBarsData: lineBars,
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          axisNameWidget: const Text(
            'Time',
            style: ORBITXTheme.body1,
          ),
          axisNameSize: 24,
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
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (spots) {
            return spots.map((spot) {
              final dateTime =
                  DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
              return LineTooltipItem(
                '${dateTime.hour}:${dateTime.minute} - ${spot.y.toStringAsFixed(2)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust font size based on screen width
    double fontSize = screenWidth > 500 ? 12 : 10;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Transform.rotate(
        angle: screenWidth > 500 ? 0 : -0.3,
        child: Text(
          '${dateTime.hour}:${dateTime.minute}:${dateTime.second}',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
          ),
        ),
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
}
