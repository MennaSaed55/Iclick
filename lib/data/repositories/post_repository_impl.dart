import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_data_source.dart';
import '../datasources/post_datasource_factory.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDataSourceFactory _dataSourceFactory;

  PostRepositoryImpl(this._dataSourceFactory);

  PostDataSource get _dataSource => _dataSourceFactory.createDataSource();

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    try {
      final posts = await _dataSource.getPosts();
      return right(posts);
    } on ServerException catch (e) {
      try {
        final localSource = _dataSourceFactory.createDataSource(
          type: PostDataSourceType.local,
        );
        final localPosts = await localSource.getPosts();
        return right(localPosts);
      } catch (_) {
        return left(ServerFailure(e.message));
      }
    } catch (e) {
      return left(ServerFailure('Failed to load posts: $e'));
    }
  }

  @override
  Stream<List<PostEntity>> watchPosts() {
    return _dataSource.watchPosts().handleError((error) {
      // Stream error handled gracefully
      return <PostEntity>[];
    });
  }

  @override
  Future<Either<Failure, PostEntity>> createPost({
    required String authorId,
    required String authorName,
    String? authorAvatarUrl,
    required String content,
    String? imageUrl,
    String? location,
  }) async {
    try {
      final model = PostModel(
        id: '',
        authorId: authorId,
        authorName: authorName,
        authorAvatarUrl: authorAvatarUrl,
        content: content,
        imageUrl: imageUrl,
        location: location,
        createdAt: DateTime.now(),
      );
      final created = await _dataSource.createPost(model);
      return right(created);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('Failed to publish post: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleLike({
    required String postId,
    required String userId,
  }) async {
    try {
      final posts = await _dataSource.getPosts();
      final post = posts.firstWhere((p) => p.id == postId);
      final updatedLikes = List<String>.from(post.likes);
      if (updatedLikes.contains(userId)) {
        updatedLikes.remove(userId);
      } else {
        updatedLikes.add(userId);
      }
      await _dataSource.updateLikes(postId, updatedLikes);
      return right(null);
    } catch (e) {
      return left(ServerFailure('Failed to update reaction: $e'));
    }
  }
}
