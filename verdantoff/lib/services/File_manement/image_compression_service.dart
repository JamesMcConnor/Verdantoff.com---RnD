import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';


/// Service for compressing images to reduce file size
class ImageCompressionService {
  /// Compresses an image file to reduce its size
  ///
  /// [file]: The image file to compress
  /// [quality]: Compression quality (0-100)
  /// [minWidth]: Minimum width for the compressed image
  /// [minHeight]: Minimum height for the compressed image
  ///
  /// Returns a compressed File if successful, or null on failure
  static Future<File?> compressImage(
      File file, {
        int quality = 70,
        int minWidth = 1024,
        int minHeight = 1024,
      }) async {
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        '${file.path}_compressed.jpg',
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
      );

      return result != null ? File(result.path) : null;
    } catch (e) {
      print('[ERROR] Image compression failed: $e');
      return null;
    }
  }
}
