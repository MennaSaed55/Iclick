import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';
import '../../../core/utils/either.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class ResetPasswordUseCase extends UseCase<void, ResetPasswordParams> {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) {
    return _repository.resetPassword(email: params.email);
  }
}

class ResetPasswordParams extends Equatable {
  final String email;

  const ResetPasswordParams({required this.email});

  @override
  List<Object?> get props => [email];
}
