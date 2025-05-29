import 'package:flutter/services.dart';

class ChatActionCopy {
  static void copyMessage(String content) {
    Clipboard.setData(ClipboardData(text: content));
  }
}
