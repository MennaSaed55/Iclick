import 'dart:async';
import '../models/post_model.dart';
import 'post_data_source.dart';

class LocalPostDataSource implements PostDataSource {
  final List<PostModel> _cachedPosts = [
    PostModel(
      id: 'local_1',
      authorId: 'member_1',
      authorName: 'Elena Rostova',
      authorAvatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      content:
          'Capturing warm twilight across the city rooftops. The creative community here never sleeps! 🌇✨ #connectme #urban',
      imageUrl:
          'https://images.unsplash.com/photo-1519501025264-65ba15a82390?w=800',
      location: 'Downtown Arts District',
      likes: const ['user_1', 'user_2'],
      commentCount: 14,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    PostModel(
      id: 'local_2',
      authorId: 'member_2',
      authorName: 'Marcus Vance',
      authorAvatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      content:
          'Morning studio vibes with fresh coffee and new sketches. What projects are you working on today? ☕🎨',
      imageUrl:
          'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800',
      location: 'Design Quarter',
      likes: const ['user_1'],
      commentCount: 8,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    PostModel(
      id: 'local_3',
      authorId: 'member_3',
      authorName: 'Sophia Chen',
      authorAvatarUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      content:
          'Weekend nature hike! Recharging in the forest hills with fellow community members. 🌲🍃',
      imageUrl:
          'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=800',
      location: 'Mountain Trails',
      likes: const ['user_3', 'user_4', 'user_5'],
      commentCount: 21,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final StreamController<List<PostModel>> _streamController =
      StreamController<List<PostModel>>.broadcast();

  LocalPostDataSource() {
    _streamController.add(List.unmodifiable(_cachedPosts));
  }

  @override
  Future<List<PostModel>> getPosts() async {
    return List.unmodifiable(_cachedPosts);
  }

  @override
  Stream<List<PostModel>> watchPosts() async* {
    yield List.unmodifiable(_cachedPosts);
    yield* _streamController.stream;
  }

  @override
  Future<PostModel> createPost(PostModel post) async {
    _cachedPosts.insert(0, post);
    _streamController.add(List.unmodifiable(_cachedPosts));
    return post;
  }

  @override
  Future<void> updateLikes(String postId, List<String> likes) async {
    final index = _cachedPosts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final old = _cachedPosts[index];
      _cachedPosts[index] = PostModel(
        id: old.id,
        authorId: old.authorId,
        authorName: old.authorName,
        authorAvatarUrl: old.authorAvatarUrl,
        content: old.content,
        imageUrl: old.imageUrl,
        location: old.location,
        likes: likes,
        commentCount: old.commentCount,
        createdAt: old.createdAt,
      );
      _streamController.add(List.unmodifiable(_cachedPosts));
    }
  }
}
