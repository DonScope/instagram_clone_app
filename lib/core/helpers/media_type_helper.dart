import 'dart:io';

import 'package:mime/mime.dart';

bool isImageFile(File file) {
  final mimeType = lookupMimeType(file.path);
  return mimeType != null && mimeType.startsWith('image/');
}

bool isVideoFile(File file) {
  final mimeType = lookupMimeType(file.path);
  return mimeType != null && mimeType.startsWith('video/');
}