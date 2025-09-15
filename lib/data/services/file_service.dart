import 'package:file_picker/file_picker.dart';
import 'dart:math' as math;

class FileService {
  Future<List<PlatformFile>> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'rtf', 'odt'],
        withData: true,
        withReadStream: false,
      );

      return result?.files ?? [];
    } catch (e) {
      throw Exception('Failed to pick files: $e');
    }
  }

  String getRandomSuccessMessage(int fileCount) {
    final messages = [
      '🎉 Files locked and loaded! Ready to unleash the AI magic!',
      '🔥 Processing power: MAXIMUM! These files won\'t know what hit them!',
      '🧠 AI neurons firing up! Your documents are about to get the VIP treatment!',
      '⭐ Document parsing mode: LEGENDARY! Let\'s make some magic happen!',
      '🎪 Step right up, files! Time for the greatest parsing show on Earth!',
      '🚀 Houston, we have document acquisition! Prepare for AI liftoff!',
      '💎 Premium files detected! Rolling out the red carpet for processing!',
      '⚡ Lightning-fast scanning protocols activated! Brace for awesomeness!',
    ];
    
    final randomMessage = messages[math.Random().nextInt(messages.length)];
    return '$randomMessage\n\nReady to process $fileCount amazing file${fileCount != 1 ? 's' : ''}!';
  }
}