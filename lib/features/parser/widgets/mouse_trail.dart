import 'package:flutter/material.dart';
import 'dart:async';

class MouseTrailWidget extends StatefulWidget {
  const MouseTrailWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MouseTrailWidgetState createState() => _MouseTrailWidgetState();
}

class _MouseTrailWidgetState extends State<MouseTrailWidget> {
  List<MouseTrailPoint> trailPoints = [];
  Timer? cleanupTimer;

  @override
  void initState() {
    super.initState();
    cleanupTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        trailPoints.removeWhere((point) =>
            DateTime.now().millisecondsSinceEpoch - point.timestamp > 1000);
      });
    });
  }

  @override
  void dispose() {
    cleanupTimer?.cancel();
    super.dispose();
  }

  void _addTrailPoint(Offset position) {
    setState(() {
      trailPoints.add(MouseTrailPoint(
        position: position,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
      if (trailPoints.length > 15) {
        trailPoints.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => _addTrailPoint(event.position),
      child: Stack(
        children: trailPoints.asMap().entries.map((entry) {
          // int index = entry.key;
          MouseTrailPoint point = entry.value;
          double age = (DateTime.now().millisecondsSinceEpoch - point.timestamp) / 1000.0;
          double opacity = (1.0 - age).clamp(0.0, 0.8);
          double scale = (1.0 - age * 0.8).clamp(0.2, 1.0);

          return Positioned(
            left: point.position.dx - 4,
            top: point.position.dy - 4,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0xFF667eea).withValues(alpha: opacity),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF667eea).withValues(alpha: opacity * 0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class MouseTrailPoint {
  final Offset position;
  final int timestamp;

  MouseTrailPoint({
    required this.position,
    required this.timestamp,
  });
}