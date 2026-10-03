import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/post.dart';
import '../../../domain/repositories/post_repository.dart';
import '../../../domain/usecases/create_post.dart';
import '../../../domain/usecases/get_posts.dart';
import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetPostsUseCase getPostsUseCase;
  final CreatePostUseCase createPostUseCase;
  final PostRepository postRepository;

  StreamSubscription<List<PostEntity>>? _postsSubscription;

  PostCubit({
    required this.getPostsUseCase,
    required this.createPostUseCase,
    required this.postRepository,
  }) : super(const PostInitial());

  void loadPosts() {
    emit(const PostLoading());
    _postsSubscription?.cancel();
    _postsSubscription = getPostsUseCase.watch().listen(
      (posts) {
        emit(PostLoaded(posts));
      },
      onError: (error) {
        emit(PostError('Error loading posts: $error'));
      },
    );
  }

  Future<void> fetchPostsOnce() async {
    emit(const PostLoading());
    final result = await getPostsUseCase.call();
    result.fold(
      (failure) => emit(PostError(failure.message)),
      (posts) => emit(PostLoaded(posts)),
    );
  }

  Future<bool> createPost({
    required String authorId,
    required String authorName,
    String? authorAvatarUrl,
    required String content,
    String? imageUrl,
    String? location,
  }) async {
    emit(const PostCreating());
    final result = await createPostUseCase.call(
      CreatePostParams(
        authorId: authorId,
        authorName: authorName,
        authorAvatarUrl: authorAvatarUrl,
        content: content,
        imageUrl: imageUrl,
        location: location,
      ),
    );

    return result.fold(
      (failure) {
        emit(PostError(failure.message));
        return false;
      },
      (newPost) {
        emit(PostCreated(newPost));
        loadPosts();
        return true;
      },
    );
  }

  Future<void> toggleLike({
    required String postId,
    required String userId,
  }) async {
    await postRepository.toggleLike(postId: postId, userId: userId);
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}
