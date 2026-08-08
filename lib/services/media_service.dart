import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class MediaService {
  MediaService._();

  static final MediaService instance = MediaService._();

  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 2400,
    );

    if (pickedFile == null) {
      return null;
    }

    return _saveImageToMintora(
      pickedFile,
    );
  }

  Future<String?> takePhoto() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 88,
      maxWidth: 2400,
    );

    if (pickedFile == null) {
      return null;
    }

    return _saveImageToMintora(
      pickedFile,
    );
  }

  Future<String> _saveImageToMintora(
    XFile pickedFile,
  ) async {
    final appDirectory =
        await getApplicationDocumentsDirectory();

    final memoryDirectory = Directory(
      p.join(
        appDirectory.path,
        'mintora_media',
        'memory_images',
      ),
    );

    if (!await memoryDirectory.exists()) {
      await memoryDirectory.create(
        recursive: true,
      );
    }

    final originalExtension =
        p.extension(
      pickedFile.path,
    );

    final extension =
        originalExtension.isEmpty
            ? '.jpg'
            : originalExtension.toLowerCase();

    final fileName =
        'memory_${DateTime.now().microsecondsSinceEpoch}$extension';

    final destinationPath =
        p.join(
      memoryDirectory.path,
      fileName,
    );

    final sourceFile = File(
      pickedFile.path,
    );

    final savedFile =
        await sourceFile.copy(
      destinationPath,
    );

    return savedFile.path;
  }

  Future<bool> deleteMedia(
    String? filePath,
  ) async {
    if (filePath == null ||
        filePath.trim().isEmpty) {
      return false;
    }

    final file = File(
      filePath,
    );

    if (!await file.exists()) {
      return false;
    }

    await file.delete();

    return true;
  }

  Future<bool> mediaExists(
    String? filePath,
  ) async {
    if (filePath == null ||
        filePath.trim().isEmpty) {
      return false;
    }

    return File(
      filePath,
    ).exists();
  }
}