import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.signIn(email: email, password: password);
      return right(user);
    } on AuthException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(AuthFailure('Sign-in failed. Please try again.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );
      return right(user);
    } on AuthException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(
        AuthFailure('Unable to create your account. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _dataSource.signOut();
      return right(null);
    } on AuthException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(const AuthFailure('Sign-out failed. Please try again.'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await _dataSource.resetPassword(email: email);
      return right(null);
    } on AuthException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(
        const AuthFailure('Unable to send reset email. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await _dataSource.getCurrentUser();
      return right(user);
    } catch (e) {
      return left(const AuthFailure('Unable to retrieve current user.'));
    }
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return _dataSource.authStateChanges();
  }
}
