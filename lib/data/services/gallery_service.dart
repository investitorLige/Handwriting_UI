//import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;
import 'dart:io';

class GalleryService {
  final ImagePicker _picker = ImagePicker();
  
 
  // Pick multiple images from gallery
  Future<List<XFile>?> pickImages({
    int imageQuality = 85,
    int? limit,
  }) async {
    try {
      
      if (!await _checkGalleryPermission()) {
        throw Exception('Gallery permission denied');
      }
      
      final List<XFile>? images = await _picker.pickMultiImage(
        imageQuality: imageQuality,
        limit: limit,
      );

      if(images != null){
      List<XFile> val_images = [];
        for (var image in images) {
          if (await validateImage(image)) {
            val_images.add(image);
          }
        }
      }
      
      return images;
    } catch (e) {
      throw Exception('Failed to pick multiple images: $e');
    }
  }
  
  // Check gallery permission (different for iOS/Android)
Future<bool> _checkGalleryPermission() async {
  // Skip permissions on desktop/web
  if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return true;
  }
  
  // Only handle mobile permissions
  if (Platform.isAndroid || Platform.isIOS) {
    try {
      var status = await Permission.photos.status;
      
      if (status == PermissionStatus.denied) {
        status = await Permission.photos.request();
      }
      
      if (status == PermissionStatus.permanentlyDenied) {
        await openAppSettings();
        return false;
      }
      
      return status == PermissionStatus.granted;
    } catch (e) {
      print('Permission error: $e');
      return true; // Assume granted on error
    }
  }
  return true; // Unknown platform, assume no permissions needed
}

  
  // Validate if file exists and is valid
  Future<bool> validateImage(XFile? image) async {
    if (image == null) return false;
    
    try {
      final file = File(image.path);
      if (!await file.exists()) return false;
      
      final size = await file.length();
      if (size == 0) return false;
      
      // Check if it's actually an image by reading headers
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) return false;
      
      // Basic image format validation
      return _isValidImageFormat(bytes);
    } catch (e) {
      return false;
    }
  }
  
  // Basic image format validation
  bool _isValidImageFormat(List<int> bytes) {
    if (bytes.length < 4) return false;
    
    // Check for common image formats
    // JPEG: FF D8
    if (bytes[0] == 0xFF && bytes[1] == 0xD8) return true;
    
    // PNG: 89 50 4E 47
    if (bytes.length >= 4 && 
        bytes[0] == 0x89 && bytes[1] == 0x50 && 
        bytes[2] == 0x4E && bytes[3] == 0x47) return true;
    
    // Add more format checks as needed
    return false;
  }
  
  
  // Your fun messages (kept as-is, they're great!)
  String getRandomCaptureMessage() {
    final messages = [
      '📸 Camera magic activated! That\'s one stunning document capture!',
      '🎯 Perfect shot! Your document is now digitally immortalized!',
      '⚡ Lightning-fast capture complete! The AI is already excited to analyze this!',
      '🚀 Houston, we have successful document acquisition from the field!',
      '🎭 Lights, camera, documents! And... that\'s a wrap on this masterpiece!',
      '🎪 Ladies and gentlemen, witness the most spectacular document capture ever!',
      '💫 Capture successful! Your document just got the Hollywood treatment!',
      '🔮 Crystal clear capture achieved! The parsing gods are pleased!',
      '🎨 Masterpiece captured! Michelangelo would be jealous of this composition!',
      '🏆 Gold medal performance! This document just won the capture Olympics!',
    ];
    
    return messages[math.Random().nextInt(messages.length)];
  }
  
  // Get random gallery message
  String getRandomGalleryMessage() {
    final messages = [
      '🖼️ Gallery treasure selected! This image is about to shine!',
      '🎨 Art gallery choice! You\'ve got excellent taste in documents!',
      '📚 Library selection complete! Knowledge is power, and you just powered up!',
      '💎 Diamond in the rough found! This image is pure gold!',
      '🔍 Detective work complete! The perfect evidence has been selected!',
    ];
    
    return messages[math.Random().nextInt(messages.length)];
  }
}