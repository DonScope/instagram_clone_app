import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PostModel {
  final String mediaUrl;
  final String uId;
  final String id;
  final String? thumbnailUrl;
  final String? caption;
  final String type;
  final Timestamp createdAt;
  final List<String> liked_by;
  final int comments;

  PostModel(
      {required this.id,
      required this.mediaUrl,
      required this.uId,
      this.thumbnailUrl,
      this.caption,
      required this.createdAt,
      required this.liked_by,
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
      id: json['id'],
      thumbnailUrl: json['thumbnail_url'],
      uId: json['uId'],
      caption: json['caption'],
      createdAt: timestamp,
      liked_by: List<String>.from(json['liked_by'] ?? []),
      comments: json['comments'] ?? 0,
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'id' : id,
      'media_url': mediaUrl,
      if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
        'thumbnail_url': thumbnailUrl,
      'caption': caption,
      'created_at': createdAt,
      'liked_by': liked_by ?? [],
      'comments': comments,
      'type': type,
    };
  }
}
