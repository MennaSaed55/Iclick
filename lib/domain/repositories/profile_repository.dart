import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../entities/user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> getUserProfile(String userId);

  Future<Either<Failure, UserEntity>> updateProfile({
    required String userId,
    String? fullName,
    String? bio,
    String? location,
    String? profileImageUrl,
    String? deviceModel,
    String? osVersion,
  });

  Future<Either<Failure, String>> uploadProfileImage({
    required String userId,
    required String imagePath,
  });
}
