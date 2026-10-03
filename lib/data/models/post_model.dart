import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/post.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.authorId,
    required super.authorName,
    super.authorAvatarUrl,
    required super.content,
    super.imageUrl,
    super.location,
    super.likes = const [],
    super.commentCount = 0,
    required super.createdAt,
  });

  factory PostModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return PostModel(
      id: doc.id,
      authorId: data['authorId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? 'Community Member',
      authorAvatarUrl: data['authorAvatarUrl'] as String?,
      content: data['content'] as String? ?? '',
      imageUrl: data['imageUrl'] as String?,
      location: data['location'] as String?,
      likes: List<String>.from(data['likes'] ?? []),
      commentCount: data['commentCount'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String? ?? '',
      authorId: json['authorId'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      content: json['content'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      location: json['location'] as String?,
      likes: List<String>.from(json['likes'] ?? []),
      commentCount: json['commentCount'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is Timestamp
                ? (json['createdAt'] as Timestamp).toDate()
                : DateTime.tryParse(json['createdAt'].toString()) ??
                      DateTime.now())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatarUrl': authorAvatarUrl,
      'content': content,
      'imageUrl': imageUrl,
      'location': location,
      'likes': likes,
      'commentCount': commentCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
