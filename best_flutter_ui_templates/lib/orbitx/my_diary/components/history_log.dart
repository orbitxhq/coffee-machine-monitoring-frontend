import 'package:flutter/material.dart';
// import 'package:best_flutter_ui_templates/fitness_app/api/get_history_log.dart';
import 'package:best_flutter_ui_templates/orbitx/orbitx_theme.dart';
import 'package:intl/intl.dart';

// Mock Model
class HistoryLog {
  final String message;
  final DateTime timestamp;

  HistoryLog({required this.message, required this.timestamp});
}

// Mock Data Function
Future<List<HistoryLog>> mockFetchHistoryLogs(String machineId) async {
  await Future.delayed(Duration(seconds: 1)); // Simulates network delay
  return List.generate(
    20,
    (index) => HistoryLog(
      message: 'Log entry #$index for machine $machineId',
      timestamp: DateTime.now().subtract(Duration(minutes: index * 10)),
    ),
  );
}

class HistoryLogDashboardView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const HistoryLogDashboardView(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  _HistoryLogDashboardViewState createState() =>
      _HistoryLogDashboardViewState();
}

class _HistoryLogDashboardViewState extends State<HistoryLogDashboardView> {
  late Future<List<HistoryLog>> historyLogs;
  int currentPage = 0;
  final int pageSize = 5;
  List<HistoryLog> displayedLogs = [];

  @override
  void initState() {
    super.initState();
    historyLogs = mockFetchHistoryLogs('machine123');
    _loadPage(currentPage);
  }

  void _loadPage(int page) async {
    final allLogs = await historyLogs;
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize) > allLogs.length
        ? allLogs.length
        : startIndex + pageSize;

    setState(() {
      displayedLogs = allLogs.sublist(startIndex, endIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ORBITXTheme.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: ORBITXTheme.grey.withOpacity(0.4),
                                offset: Offset(1.1, 1.1),
                                blurRadius: 10.0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                child: Text(
                                  'History Log',
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
                                    vertical: 8, horizontal: 16),
                                child: FutureBuilder<List<HistoryLog>>(
                                  future: historyLogs,
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
                                        snapshot.data!.isEmpty) {
                                      return Center(
                                          child: Text('No logs available'));
                                    }

                                    return Column(
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: displayedLogs.length,
                                          itemBuilder: (context, index) {
                                            final log = displayedLogs[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: ORBITXTheme.background,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                      color: ORBITXTheme.grey
                                                          .withOpacity(0.2),
                                                      offset: Offset(0, 1),
                                                      blurRadius: 5.0,
                                                    ),
                                                  ],
                                                ),
                                                child: ExpansionTile(
                                                  title: Text(
                                                    log.message,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          ORBITXTheme.fontName,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      color:
                                                          ORBITXTheme.darkText,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    DateFormat(
                                                            'yyyy-MM-dd HH:mm')
                                                        .format(log.timestamp),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          ORBITXTheme.fontName,
                                                      fontSize: 14,
                                                      color: ORBITXTheme.grey
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                  leading: Icon(
                                                    Icons.history,
                                                    color: ORBITXTheme.grey
                                                        .withOpacity(0.8),
                                                  ),
                                                  backgroundColor: ORBITXTheme
                                                      .background, // Match container background
                                                  collapsedBackgroundColor:
                                                      ORBITXTheme
                                                          .background, // Match when collapsed
                                                  tilePadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 16),
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Text(
                                                        'Details about this log entry. You can customize this content.',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              ORBITXTheme
                                                                  .fontName,
                                                          fontSize: 14,
                                                          color: ORBITXTheme
                                                              .darkText,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (currentPage > 0)
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    currentPage--;
                                                    _loadPage(currentPage);
                                                  });
                                                },
                                                child: Text('Previous Page'),
                                              )
                                            else
                                              SizedBox(), // Placeholder to ensure alignment
                                            TextButton(
                                              onPressed: displayedLogs.length ==
                                                      pageSize
                                                  ? () {
                                                      setState(() {
                                                        currentPage++;
                                                        _loadPage(currentPage);
                                                      });
                                                    }
                                                  : null, // Disable the button if there are no more pages
                                              child: Text('Next Page'),
                                            ),
                                          ],
                                        ),
                                      ],
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
