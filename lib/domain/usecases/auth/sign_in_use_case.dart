import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class SignInUseCase extends UseCase<UserEntity, SignInParams> {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) {
    return _repository.signIn(email: params.email, password: params.password);
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
