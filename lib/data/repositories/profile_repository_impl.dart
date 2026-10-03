import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../services/storage_service.dart';
import '../datasources/user_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final UserRemoteDataSource userDataSource;
  final StorageService storageService;

  ProfileRepositoryImpl({
    required this.userDataSource,
    required this.storageService,
  });

  @override
  Future<Either<Failure, UserEntity>> getUserProfile(String userId) async {
    try {
      final user = await userDataSource.getUser(userId);
      return right(user);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('Failed to load profile: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String userId,
    String? fullName,
    String? bio,
    String? location,
    String? profileImageUrl,
    String? deviceModel,
    String? osVersion,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (fullName != null) data['fullName'] = fullName;
      if (bio != null) data['bio'] = bio;
      if (location != null) data['location'] = location;
      if (profileImageUrl != null) data['profileImageUrl'] = profileImageUrl;
      if (deviceModel != null) data['deviceModel'] = deviceModel;
      if (osVersion != null) data['osVersion'] = osVersion;

      final updated = await userDataSource.updateUser(userId, data);
      return right(updated);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('Failed to update profile: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage({
    required String userId,
    required String imagePath,
  }) async {
    try {
      final downloadUrl = await storageService.uploadProfileImage(
        userId: userId,
        filePath: imagePath,
      );
      await userDataSource.updateUser(userId, {'profileImageUrl': downloadUrl});
      return right(downloadUrl);
    } on StorageException catch (e) {
      return left(StorageFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(StorageFailure('Image upload failed: $e'));
    }
  }
}
