import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String content;
  final String? imageUrl;
  final String? location;
  final List<String> likes;
  final int commentCount;
  final DateTime createdAt;

  const PostEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    required this.content,
    this.imageUrl,
    this.location,
    this.likes = const [],
    this.commentCount = 0,
    required this.createdAt,
  });

  bool isLikedBy(String userId) => likes.contains(userId);

  PostEntity copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatarUrl,
    String? content,
    String? imageUrl,
    String? location,
    List<String>? likes,
    int? commentCount,
    DateTime? createdAt,
  }) {
    return PostEntity(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      likes: likes ?? this.likes,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    authorId,
    authorName,
    authorAvatarUrl,
    content,
    imageUrl,
    location,
    likes,
    commentCount,
    createdAt,
  ];
}
