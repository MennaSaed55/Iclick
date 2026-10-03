import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts();
  Stream<List<PostEntity>> watchPosts();
  Future<Either<Failure, PostEntity>> createPost({
    required String authorId,
    required String authorName,
    String? authorAvatarUrl,
    required String content,
    String? imageUrl,
    String? location,
  });
  Future<Either<Failure, void>> toggleLike({
    required String postId,
    required String userId,
  });
}
