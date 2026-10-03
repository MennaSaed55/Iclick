import 'package:equatable/equatable.dart';
import '../../../domain/entities/post.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

final class PostInitial extends PostState {
  const PostInitial();
}

final class PostLoading extends PostState {
  const PostLoading();
}

final class PostLoaded extends PostState {
  final List<PostEntity> posts;

  const PostLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

final class PostCreating extends PostState {
  const PostCreating();
}

final class PostCreated extends PostState {
  final PostEntity post;

  const PostCreated(this.post);

  @override
  List<Object?> get props => [post];
}

final class PostError extends PostState {
  final String message;

  const PostError(this.message);

  @override
  List<Object?> get props => [message];
}
