import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/user_entity.dart';
import '../../repositories/profile_repository.dart';
import '../usecase.dart';

class UpdateProfileParams extends Equatable {
  final String userId;
  final String? fullName;
  final String? bio;
  final String? location;
  final String? profileImageUrl;
  final String? deviceModel;
  final String? osVersion;

  const UpdateProfileParams({
    required this.userId,
    this.fullName,
    this.bio,
    this.location,
    this.profileImageUrl,
    this.deviceModel,
    this.osVersion,
  });

  @override
  List<Object?> get props => [
    userId,
    fullName,
    bio,
    location,
    profileImageUrl,
    deviceModel,
    osVersion,
  ];
}

class UpdateProfileUseCase extends UseCase<UserEntity, UpdateProfileParams> {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) {
    return _repository.updateProfile(
      userId: params.userId,
      fullName: params.fullName,
      bio: params.bio,
      location: params.location,
      profileImageUrl: params.profileImageUrl,
      deviceModel: params.deviceModel,
      osVersion: params.osVersion,
    );
  }
}
