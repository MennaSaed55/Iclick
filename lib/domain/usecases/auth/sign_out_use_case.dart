import '../../../core/errors/failures.dart';
import '../../../core/utils/either.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class SignOutUseCase extends UseCaseNoParams<void> {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call() {
    return _repository.signOut();
  }
}
