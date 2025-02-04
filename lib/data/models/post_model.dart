import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PostModel {
  final String mediaUrl;
  final String? thumbnailUrl;
  final String? caption;
  final String type;
  final Timestamp createdAt;
  final int likes;
  final int comments;

  PostModel(
      {required this.mediaUrl,
      this.thumbnailUrl,
      this.caption,
      required this.createdAt,
      this.likes = 0,
      this.comments = 0,
      required this.type});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    var createdAtField = json['created_at'];
    Timestamp timestamp;

    if (createdAtField is Timestamp) {
      timestamp = createdAtField;
    } else if (createdAtField is String) {
      String dateString = createdAtField;
      DateTime parsedDate;
      try {
        parsedDate = DateFormat('dd-MM-yyyy').parse(dateString);
      } catch (e) {
        parsedDate = DateTime.now();
      }
      timestamp = Timestamp.fromDate(parsedDate);
    } else {
      timestamp = Timestamp.now();
    }

    return PostModel(
      mediaUrl: json['media_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      caption: json['caption'],
      createdAt: timestamp,
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'media_url': mediaUrl,
      if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
        'thumbnail_url': thumbnailUrl,
      'caption': caption,
      'created_at': createdAt,
      'likes': likes,
      'comments': comments,
      'type': type,
    };
  }
}
