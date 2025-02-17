import 'dart:io';
import 'dart:typed_data';
import 'package:get_thumbnail_video/index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

class MediaHelper {
  static Future<String?> generateThumbnail(File mediaFile, Future<String> Function(File) uploadFunction) async {
    List<String> videoExtensions = [
      ".mp4",
      ".mov",
      ".avi",
      ".mkv",
      ".flv",
      ".wmv",
      ".webm"
    ];

    if (videoExtensions.any((ext) => mediaFile.path.endsWith(ext))) {
      final Uint8List? thumbnailData = await VideoThumbnail.thumbnailData(
        video: mediaFile.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 256,
        quality: 75,
      );

      if (thumbnailData != null) {
        final tempDir = await getTemporaryDirectory();
        final thumbnailFile = File('${tempDir.path}/thumbnail.jpg');
        await thumbnailFile.writeAsBytes(thumbnailData);

        return await uploadFunction(thumbnailFile);
      }
    }
    return null;
  }
}
