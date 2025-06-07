import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

/// Service for uploading files to Firebase Storage.
/// Handles file size validation (max 5MB) and returns file metadata.
class FileUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage and returns its metadata.
  ///
  /// [file]: The file to upload.
  /// [chatId]: The ID of the chat where the file is being uploaded.
  ///
  /// Returns a `Future<Map<String, dynamic>>` containing:
  ///   - 'url': download URL
  ///   - 'fileName': the name of the file
  ///   - 'fileType': the type of file (image, video, document, etc.)
  ///   - 'size': file size in bytes
  ///   - 'contentType': MIME type of the file
  ///
  /// Throws an exception if the file size exceeds 5MB.
  Future<Map<String, dynamic>> uploadFile(File file, String chatId, {void Function(double)? onProgress}) async {
    try {
      // Check file size (max 5MB)
      final fileSize = await file.length();
      const maxSize = 5 * 1024 * 1024; // 5MB
      if (fileSize > maxSize) {
        throw Exception('File size exceeds 5MB limit');
      }
      // Generate a unique file name using timestamp and original file name
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = file.path.split('/').last;
      final uniqueFileName = '${timestamp}_$fileName';
      // Create a reference to the location in storage
      final ref = _storage.ref().child('chat_files/$chatId/$uniqueFileName');
      // Start the upload
      final uploadTask = ref.putFile(file);
      // Listen for progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        if (onProgress != null) {
          onProgress(progress);
        }
      });
      // Wait for the upload to complete
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      final metadata = await snapshot.ref.getMetadata();
      return {
        'url': downloadUrl,
        'fileName': uniqueFileName,
        'fileType': _getFileType(file.path),
        'size': metadata.size,
        'contentType': metadata.contentType,
      };
    } catch (e) {
      print('[ERROR] File upload failed: $e');
      rethrow;
    }
  }
  String _getFileType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension)) {
      return 'image';
    } else if (['mp4', 'mov', 'avi', 'mkv', 'flv'].contains(extension)) {
      return 'video';
    } else if (['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt'].contains(extension)) {
      return 'document';
    } else {
      return 'file';
    }
  }
}
