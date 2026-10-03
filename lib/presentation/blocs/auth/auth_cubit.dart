import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth/sign_in_use_case.dart';
import '../../../domain/usecases/auth/sign_up_use_case.dart';
import '../../../domain/usecases/auth/sign_out_use_case.dart';
import '../../../domain/usecases/auth/reset_password_use_case.dart';
import '../../../domain/usecases/auth/get_current_user_use_case.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final AuthRepository authRepository;

  StreamSubscription<dynamic>? _authSubscription;

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.resetPasswordUseCase,
    required this.getCurrentUserUseCase,
    required this.authRepository,
  }) : super(const AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    final result = await getCurrentUserUseCase.call();
    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) => user != null
          ? emit(AuthAuthenticated(user))
          : emit(const AuthUnauthenticated()),
    );
  }

  void startAuthStateListener() {
    _authSubscription?.cancel();
    _authSubscription = authRepository.authStateChanges().listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await signInUseCase.call(
      SignInParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
 Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await signUpUseCase.call(
      SignUpParams(fullName: fullName, email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }


  Future<void> signOut() async {
    emit(const AuthLoading());
    final result = await signOutUseCase.call();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> resetPassword({required String email}) async {
    emit(const AuthLoading());
    final result = await resetPasswordUseCase.call(
      ResetPasswordParams(email: email),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthPasswordResetSent()),
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
