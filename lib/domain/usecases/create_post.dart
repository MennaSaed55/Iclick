import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';
import 'usecase.dart';

class CreatePostParams extends Equatable {
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String content;
  final String? imageUrl;
  final String? location;

  const CreatePostParams({
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    required this.content,
    this.imageUrl,
    this.location,
  });

  @override
  List<Object?> get props => [
    authorId,
    authorName,
    authorAvatarUrl,
    content,
    imageUrl,
    location,
  ];
}

class CreatePostUseCase extends UseCase<PostEntity, CreatePostParams> {
  final PostRepository _repository;

  CreatePostUseCase(this._repository);

  @override
  Future<Either<Failure, PostEntity>> call(CreatePostParams params) {
    return _repository.createPost(
      authorId: params.authorId,
      authorName: params.authorName,
      authorAvatarUrl: params.authorAvatarUrl,
      content: params.content,
      imageUrl: params.imageUrl,
      location: params.location,
    );
  }
}
