import 'dart:convert';
import 'package:best_flutter_ui_templates/orbitx/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Data Model for MachineStats
class MachineStats {
  final String machineID;
  final double uptimeHours;
  final int totalLogs;
  final int totalShots;
  final int totalShotsToday;
  final DateTime lastActiveTime;

  MachineStats({
    required this.machineID,
    required this.uptimeHours,
    required this.totalLogs,
    required this.totalShots,
    required this.totalShotsToday,
    required this.lastActiveTime,
  });

  // Factory constructor to create an instance of MachineStats from JSON
  factory MachineStats.fromJson(Map<String, dynamic> json) {
    return MachineStats(
      machineID: json['machine_id'],
      uptimeHours: (json['uptime_hours'] as num).toDouble(),
      totalLogs: json['total_logs'],
      totalShots: json['total_shots'],
      totalShotsToday: json['total_shots_today'],
      lastActiveTime: DateTime.parse(json['last_active_time']),
    );
  }
}

// Function to fetch machine stats from the API
Future<MachineStats> fetchMachineStats(String machineId) async {
  final timezone = await getCurrentTimezone();
  final response = await http.get(
    Uri.parse(
        'https://coffee-machine-monitoring-service-120808100044.asia-southeast1.run.app/machine/$machineId/log/summary/?timezone=$timezone'),
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return MachineStats.fromJson(jsonResponse['stats']);
  } else {
    throw Exception(
        'Failed to load machine stats. Status code: ${response.statusCode}');
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
  late Future<MachineStats> futureMachineStats;

  @override
  void initState() {
    super.initState();
    // Replace with your machine ID
    futureMachineStats = fetchMachineStats('machine123');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Machine Stats Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Machine Stats Viewer'),
        ),
        body: Center(
          child: FutureBuilder<MachineStats>(
            future: futureMachineStats,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final stats = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Machine ID: ${stats.machineID}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                          'Uptime Hours: ${stats.uptimeHours.toStringAsFixed(2)}'),
                      Text('Total Logs: ${stats.totalLogs}'),
                      Text('Total Shots: ${stats.totalShots}'),
                      Text('Total Shots Today: ${stats.totalShotsToday}'),
                      Text(
                          'Last Active Time: ${stats.lastActiveTime.toLocal()}'),
                    ],
                  ),
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
