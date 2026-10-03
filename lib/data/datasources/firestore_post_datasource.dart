import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/errors/exceptions.dart';
import '../../services/firestore_service.dart';
import '../models/post_model.dart';
import 'post_data_source.dart';

class FirestorePostDataSource implements PostDataSource {
  final FirestoreService _firestoreService;

  FirestorePostDataSource(this._firestoreService);

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final snapshot = await _firestoreService.postsCollection
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to load posts from Firestore');
    } catch (e) {
      throw ServerException('Failed to fetch posts: $e');
    }
  }

  @override
  Stream<List<PostModel>> watchPosts() {
    return _firestoreService.postsStream().map((snapshot) {
      return snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
    });
  }

  @override
  Future<PostModel> createPost(PostModel post) async {
    try {
      final docRef = _firestoreService.postsCollection.doc();
      final newPost = PostModel(
        id: docRef.id,
        authorId: post.authorId,
        authorName: post.authorName,
        authorAvatarUrl: post.authorAvatarUrl,
        content: post.content,
        imageUrl: post.imageUrl,
        location: post.location,
        likes: post.likes,
        commentCount: post.commentCount,
        createdAt: DateTime.now(),
      );
      await docRef.set(newPost.toJson());
      return newPost;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to create post');
    } catch (e) {
      throw ServerException('Post creation failed: $e');
    }
  }

  @override
  Future<void> updateLikes(String postId, List<String> likes) async {
    try {
      await _firestoreService.updatePost(postId, {'likes': likes});
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to update like');
    }
  }
}
