import 'package:image_picker/image_picker.dart';
//import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> captureImage() async {
    try {
      // Check camera permission
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        throw Exception('Camera permission denied');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      return image;
    } catch (e) {
      throw Exception('Failed to capture image: $e');
    }
  }

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
    ];
    
    return messages[math.Random().nextInt(messages.length)];
  }
}