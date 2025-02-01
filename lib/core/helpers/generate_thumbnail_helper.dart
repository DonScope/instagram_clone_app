// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'dart:io';

// final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

// Future<File> generateThumbnail(File videoFile) async {
//   // Define the path for the thumbnail
//   final thumbnailPath = '${videoFile.parent.path}/thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg';

//   // Use FFmpeg to extract a thumbnail at the 1-second mark
//   final command = '-i ${videoFile.path} -ss 00:00:01 -vframes 1 $thumbnailPath';
//   final returnCode = await _flutterFFmpeg.execute(command);

//   if (returnCode == 0) {
//     return File(thumbnailPath);
//   } else {
//     throw Exception('Failed to generate thumbnail');
//   }
// }