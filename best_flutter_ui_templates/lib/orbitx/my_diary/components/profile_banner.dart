import 'package:best_flutter_ui_templates/orbitx/orbitx_theme.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProfileBannerView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const ProfileBannerView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
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
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 8),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: ORBITXTheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),
                    _buildStatsRow(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Equal spacing
        children: <Widget>[
          _buildStatColumn(Icons.coffee, 'Shots', '20 shots'),
          _buildStatColumn(Icons.water_drop, 'Water Usage', '15 liters'),
          _buildStatColumn(Icons.access_time, 'Last Active', '20 minutes ago'),
        ],
      ),
    );
  }

// Stat Column
  Widget _buildStatColumn(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align header and value
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
