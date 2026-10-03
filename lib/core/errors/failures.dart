import 'package:equatable/equatable.dart';

/// Base failure class for the domain layer.
///
/// All domain-layer errors are expressed as [Failure] subtypes
/// rather than exceptions, keeping the domain pure and testable.
sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failures originating from Firebase Authentication operations.
final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Failures from Firestore, Storage, or other backend services.
final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failures caused by network connectivity issues.
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failures from Firebase Storage operations.
final class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

/// Failures caused by local device operations (biometrics, device info).
final class DeviceFailure extends Failure {
  const DeviceFailure(super.message);
}

/// Failures caused by cache or local storage operations.
final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
