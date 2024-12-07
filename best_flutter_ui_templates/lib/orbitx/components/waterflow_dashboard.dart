import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/orbitx/components/machine_usage_chart.dart';
import 'package:best_flutter_ui_templates/orbitx/orbitx_theme.dart';
import 'package:best_flutter_ui_templates/orbitx/api/fetch_hourly_stats.dart';
import 'package:intl/intl.dart';

class WaterFlowDashboardView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const WaterFlowDashboardView(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  _WaterFlowDashboardViewState createState() => _WaterFlowDashboardViewState();
}

class _WaterFlowDashboardViewState extends State<WaterFlowDashboardView> {
  late Future<HourlyStats> hourlyStats;

  @override
  void initState() {
    super.initState();
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    hourlyStats = fetchHourlyStats('machine123', currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 0, bottom: 0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ORBITXTheme.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: ORBITXTheme.grey.withOpacity(0.4),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                child: Text(
                                  'Water Usage',
                                  style: TextStyle(
                                    fontFamily: ORBITXTheme.fontName,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 0.5,
                                    color: ORBITXTheme.darkText,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                child: FutureBuilder<HourlyStats>(
                                  future: hourlyStats,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (!snapshot.hasData ||
                                        snapshot.data == null) {
                                      return Center(
                                          child: Text('No data available'));
                                    }
                                    final stats = snapshot.data!;

                                    // Data is successfully loaded
                                    return MachineUsageChart(
                                      points: stats.info['waterflow'],
                                      animationController:
                                          widget.animationController,
                                      animation: widget.animation,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
