import 'package:flutter/material.dart';

class AppColors {
  // Upload colors
  static const Color uploadPrimary = Color(0xFFff6b6b);
  static const Color uploadSecondary = Color(0xFFff8e8e);
  
  // Camera colors
  static const Color cameraPrimary = Color(0xFF4ecdc4);
  static const Color cameraSecondary = Color(0xFF7fded6);
  
  // Background colors
  static const Color backgroundDark = Color(0xFF0a0a0f);
  static const Color backgroundLight = Color(0xFF1a1a2e);
  
  // Effect colors
  static const Color particleBase = Colors.white;
  static const Color glowColor = Color(0xFF667eea);
  
  // Gradient colors
  static const List<Color> titleGradient = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFFf093fb),
  ];
}

class AppConstants {
  static const double cardBorderRadius = 24.0;
  static const double iconSize = 100.0;
  static const double defaultPadding = 32.0;
  
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
  
  static const List<String> supportedFileTypes = [
    'pdf', 'doc', 'docx', 'txt', 'rtf', 'odt'
  ];
}