import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';
import '../../../core/utils/either.dart';
import '../../repositories/profile_repository.dart';
import '../usecase.dart';

class UploadProfileImageParams extends Equatable {
  final String userId;
  final String imagePath;

  const UploadProfileImageParams({
    required this.userId,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [userId, imagePath];
}

class UploadProfileImageUseCase
    extends UseCase<String, UploadProfileImageParams> {
  final ProfileRepository _repository;

  UploadProfileImageUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(UploadProfileImageParams params) {
    return _repository.uploadProfileImage(
      userId: params.userId,
      imagePath: params.imagePath,
    );
  }
}
