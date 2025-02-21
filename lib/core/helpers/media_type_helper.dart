
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

bool isImageFile(XFile file) {
  final mimeType = lookupMimeType(file.path);
  return mimeType != null && mimeType.startsWith('image/');
}

bool isVideoFile(XFile file) {
  final mimeType = lookupMimeType(file.path);
  return mimeType != null && mimeType.startsWith('video/');
}