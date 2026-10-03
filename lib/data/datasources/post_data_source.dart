import '../models/post_model.dart';

abstract class PostDataSource {
  Future<List<PostModel>> getPosts();
  Stream<List<PostModel>> watchPosts();
  Future<PostModel> createPost(PostModel post);
  Future<void> updateLikes(String postId, List<String> likes);
}
