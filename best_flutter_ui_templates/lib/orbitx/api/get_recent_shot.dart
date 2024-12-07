import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:best_flutter_ui_templates/orbitx/utils.dart';

// Data Model for RecentShotStats
class RecentShotStats {
  final String shotID;
  final Map<String, List<double>> info;
  final List<DateTime> loggedAt;

  RecentShotStats(
      {required this.shotID, required this.info, required this.loggedAt});

  // Factory constructor to create an instance of RecentShotStats from JSON
  factory RecentShotStats.fromJson(Map<String, dynamic> json) {
    final shotDetails = json['shotDetails'] as Map<String, dynamic>;

    return RecentShotStats(
      shotID: shotDetails['shot_id'], // Ensure this is correctly provided
      info: (shotDetails['info'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          List<double>.from(value.map((v) => (v as num).toDouble())),
        ),
      ),
      loggedAt: List<DateTime>.from(
        (shotDetails['logged_at'] as List<dynamic>)
            .map((dateString) => DateTime.parse(dateString)),
      ),
    );
  }
}

// Function to fetch recent shot stats from the API
Future<RecentShotStats> fetchRecentShotStats(String machineId) async {
  final timezone =
      await getCurrentTimezone(); // Utility to get the current timezone
  final response = await http.get(
    Uri.parse(
        'https://coffee-machine-monitoring-service-120808100044.asia-southeast1.run.app/machine/$machineId/log/recent-shot/?timezone=$timezone'),
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final res = RecentShotStats.fromJson(jsonResponse);
    return res;
  } else {
    throw Exception(
        'Failed to load recent shot stats. Status code: ${response.statusCode}');
  }
}

// Main entry point for the Flutter app
void main() => runApp(const MyApp());

// Root widget of the app
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<RecentShotStats> futureRecentShotStats;

  @override
  void initState() {
    super.initState();
    // Replace with your machine ID
    futureRecentShotStats = fetchRecentShotStats('machine123');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recent Shot Stats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Recent Shot Stats Viewer'),
        ),
        body: Center(
          child: FutureBuilder<RecentShotStats>(
            future: futureRecentShotStats,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final stats = snapshot.data!;
                return ListView.builder(
                  itemCount: stats.info.length,
                  itemBuilder: (context, index) {
                    final key = stats.info.keys.elementAt(index);
                    final values = stats.info[key]!;
                    final loggedAt =
                        stats.loggedAt[index]; // Assuming order matches

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(key),
                        subtitle: Text(
                          'Logged At: ${loggedAt.toLocal().toString()}\n' +
                              values
                                  .asMap()
                                  .entries
                                  .map((entry) =>
                                      'Value ${entry.key + 1}: ${entry.value.toStringAsFixed(2)}')
                                  .join('\n'),
                        ),
                      ),
                    );
                  },
                );
              }
              return const Text('No data available');
            },
          ),
        ),
      ),
    );
  }
}
