import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class SignUpUseCase extends UseCase<UserEntity, SignUpParams> {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) {
    return _repository.signUp(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpParams extends Equatable {
  final String fullName;
  final String email;
  final String password;

  const SignUpParams({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, password];
}
