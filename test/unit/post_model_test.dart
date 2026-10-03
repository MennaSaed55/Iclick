import 'package:flutter_test/flutter_test.dart';
import 'package:iclick/data/models/post_model.dart';
import 'package:iclick/domain/entities/post.dart';

void main() {
  group('PostModel & PostEntity Tests', () {
    test('PostModel fromJson & toJson consistency', () {
      final json = {
        'id': 'post_101',
        'authorId': 'author_1',
        'authorName': 'Elena Rostova',
        'content': 'Exploring community creative spaces today!',
        'imageUrl': 'https://example.com/photo.jpg',
        'location': 'Art District',
        'likes': ['user_1', 'user_2'],
        'commentCount': 5,
      };

      final post = PostModel.fromJson(json);
      expect(post.id, 'post_101');
      expect(post.authorName, 'Elena Rostova');
      expect(post.likes.length, 2);
      expect(post.isLikedBy('user_1'), isTrue);
      expect(post.isLikedBy('user_99'), isFalse);

      final map = post.toJson();
      expect(map['authorId'], 'author_1');
      expect(map['content'], 'Exploring community creative spaces today!');
      expect(map['likes'], ['user_1', 'user_2']);
    });

    test('PostEntity copyWith updates fields immutably', () {
      final initial = PostEntity(
        id: '1',
        authorId: 'a1',
        authorName: 'Alex',
        content: 'Initial text',
        createdAt: DateTime.now(),
      );

      final updated = initial.copyWith(
        content: 'Updated content',
        likes: ['u1'],
      );

      expect(initial.content, 'Initial text');
      expect(updated.content, 'Updated content');
      expect(updated.likes, ['u1']);
      expect(updated.id, initial.id);
    });
  });
}
