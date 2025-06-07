import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

/// Service for downloading files with progress tracking
class FileDownloadService with ChangeNotifier {
  final Dio _dio = Dio();
  double _progress = 0;
  CancelToken? _cancelToken;

  double get progress => _progress;

  /// Downloads a file from a URL and saves it to temporary storage
  ///
  /// [url]: The URL of the file to download
  /// [fileName]: The name to save the file as
  /// [context]: Optional context for showing progress dialogs
  ///
  /// Returns the path of the downloaded file
  Future<String?> downloadFile(
      String url,
      String fileName, {
        BuildContext? context,
      }) async {
    try {
      _progress = 0;
      _cancelToken = CancelToken();
      notifyListeners();

      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/$fileName';

      await _dio.download(
        url,
        path,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          _progress = received / total;
          notifyListeners();
        },
      );

      await OpenFile.open(path);
      return path;
    } catch (e) {
      if (e is DioError && e.type == DioErrorType.cancel) {
        print('Download canceled');
      } else {
        print('Download error: $e');
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Download failed: ${e.toString()}')),
          );
        }
      }
      return null;
    } finally {
      _progress = 0;
      notifyListeners();
    }
  }

  /// Cancels an ongoing download
  void cancelDownload() {
    _cancelToken?.cancel('Download canceled by user');
    _progress = 0;
    notifyListeners();
  }
}
