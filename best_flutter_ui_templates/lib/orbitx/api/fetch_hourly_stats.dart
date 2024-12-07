import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:best_flutter_ui_templates/orbitx/utils.dart';

// Data Model for HourlyStats
class HourlyStats {
  final String machineId;
  final Map<String, List<double>> info;

  HourlyStats({
    required this.machineId,
    required this.info,
  });

  // Factory constructor to create an instance of HourlyStats from JSON
  factory HourlyStats.fromJson(Map<String, dynamic> json) {
    return HourlyStats(
      machineId: json['machine_id'],
      info: (json['info'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
            key, List<double>.from(value.map((v) => (v as num).toDouble()))),
      ),
    );
  }
}

// Function to fetch hourly stats from the API
Future<HourlyStats> fetchHourlyStats(String machineId, String date) async {
  final timezone = await getCurrentTimezone();
  final response = await http.get(
    Uri.parse(
        'https://coffee-machine-monitoring-service-120808100044.asia-southeast1.run.app/machine/$machineId/log/hourly-stats/?date=$date&timezone=$timezone'),
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    if (jsonResponse['stats'] != null) {
      final statsJson = jsonResponse['stats'];
      var res = HourlyStats.fromJson(statsJson);
      return res;
    } else {
      throw Exception('Stats key is missing in the response');
    }
  } else {
    throw Exception('Failed to load hourly stats');
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
  late Future<HourlyStats> futureHourlyStats;

  @override
  void initState() {
    super.initState();
    // Replace with your machine ID and date
    futureHourlyStats = fetchHourlyStats('machine123', '2024-11-27');
    print(futureHourlyStats);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hourly Stats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hourly Stats Viewer'),
        ),
        body: Center(
          child: FutureBuilder<HourlyStats>(
            future: futureHourlyStats,
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
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(key),
                        subtitle: Text(
                          values
                              .asMap()
                              .entries
                              .map((entry) =>
                                  'Hour ${entry.key}: ${entry.value.toStringAsFixed(2)}')
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
