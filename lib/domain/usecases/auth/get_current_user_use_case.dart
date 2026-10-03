import '../../../core/errors/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class GetCurrentUserUseCase extends UseCaseNoParams<UserEntity?> {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity?>> call() {
    return _repository.getCurrentUser();
  }
}
