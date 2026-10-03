import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';
import 'usecase.dart';

class GetPostsUseCase extends UseCaseNoParams<List<PostEntity>> {
  final PostRepository _repository;

  GetPostsUseCase(this._repository);

  @override
  Future<Either<Failure, List<PostEntity>>> call() {
    return _repository.getPosts();
  }

  Stream<List<PostEntity>> watch() {
    return _repository.watchPosts();
  }
}
