import 'package:best_flutter_ui_templates/orbitx/api/get_machine_stats.dart';
import 'package:best_flutter_ui_templates/orbitx/orbitx_theme.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProfileBannerView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const ProfileBannerView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  _ProfileBannerViewState createState() => _ProfileBannerViewState();
}

final GlobalKey<_ProfileBannerViewState> profileBannerKey = GlobalKey();

class _ProfileBannerViewState extends State<ProfileBannerView> {
  late Future<MachineStats> machineStats;

  @override
  void initState() {
    super.initState();
    machineStats = fetchMachineStats('machine123');
  }

  void triggerParentRefresh() {
    // Fetch new stats or update state
    setState(() {
      machineStats = fetchMachineStats('machine123'); // Refresh data
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: FutureBuilder<MachineStats>(
                future: machineStats,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingWidget();
                  } else if (snapshot.hasError) {
                    return _buildErrorWidget(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    final stats = snapshot.data!;
                    return _buildProfileBanner(screenWidth, stats);
                  }
                  return _buildErrorWidget('Unexpected Error');
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // Loading Widget
  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(
        color: ORBITXTheme.nearlyDarkBlue,
      ),
    );
  }

  // Error Widget
  Widget _buildErrorWidget(String errorMessage) {
    return Center(
      child: Text(
        'Error: $errorMessage',
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Profile Banner Widget
  Widget _buildProfileBanner(double screenWidth, MachineStats stats) {
    return Container(
      decoration: BoxDecoration(
        color: ORBITXTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
          topRight: Radius.circular(68.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: ORBITXTheme.grey.withOpacity(0.2),
            offset: Offset(1.1, 1.1),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: screenWidth > 360
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildTextSection(),
                      _buildImageSection(),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      _buildImageSection(),
                      const SizedBox(height: 16),
                      _buildTextSection(),
                    ],
                  ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: ORBITXTheme.background,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
          _buildStatsRow(stats),
        ],
      ),
    );
  }

  // Text Section
  Widget _buildTextSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'De\'Longhi All In One',
            style: TextStyle(
              fontFamily: ORBITXTheme.fontName,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 0.5,
              color: ORBITXTheme.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Premium Coffee Machine for your perfect brew.',
            style: TextStyle(
              fontFamily: ORBITXTheme.fontName,
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: ORBITXTheme.grey.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  // Image Section
  Widget _buildImageSection() {
    return Container(
      width: 160,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: ORBITXTheme.grey.withOpacity(0.4),
            blurRadius: 10.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          "assets/fitness_app/m1.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Stats Row
  // Stats Row
  Widget _buildStatsRow(MachineStats stats) {
    final lastActiveDuration =
        DateTime.now().difference(stats.lastActiveTime).inMinutes;

    String lastActiveText;
    if (lastActiveDuration > 1440) {
      // More than 24 hours
      final days = (lastActiveDuration / 1440).floor(); // Calculate days
      lastActiveText = '$days day${days > 1 ? 's' : ''} ago';
    } else if (lastActiveDuration > 60) {
      // More than 60 minutes
      final hours = (lastActiveDuration / 60).floor(); // Calculate hours
      lastActiveText = '$hours hour${hours > 1 ? 's' : ''} ago';
    } else {
      // Less than 60 minutes
      lastActiveText =
          '$lastActiveDuration minute${lastActiveDuration > 1 ? 's' : ''} ago';
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Equal spacing
        children: <Widget>[
          _buildStatColumn(Icons.coffee, 'Shots', '${stats.totalShots} shots'),
          _buildStatColumn(Icons.water_drop, 'Logs', '${stats.totalLogs} logs'),
          _buildStatColumn(Icons.access_time, 'Last Active', lastActiveText),
        ],
      ),
    );
  }

  // Stat Column
  Widget _buildStatColumn(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Icon(icon, color: ORBITXTheme.darkText, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: ORBITXTheme.fontName,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: ORBITXTheme.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: ORBITXTheme.fontName,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: ORBITXTheme.grey.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
