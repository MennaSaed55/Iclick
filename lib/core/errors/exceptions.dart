library;

/// Data-layer exceptions that are caught at repository boundaries
/// and converted into domain [Failure] types.
///
/// These are intentionally separate from [Failure] to preserve
/// the dependency rule: domain never depends on data-layer exceptions.

/// Thrown when Firebase Authentication operations fail.
class AuthException implements Exception {
  final String code;
  final String message;
  const AuthException({required this.code, required this.message});

  @override
  String toString() => 'AuthException($code): $message';
}

/// Thrown when Firestore operations fail.
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}

/// Thrown when Firebase Storage operations fail.
class StorageException implements Exception {
  final String message;
  const StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}

/// Thrown when there is no network connectivity.
class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection.']);

  @override
  String toString() => 'NetworkException: $message';
}

/// Thrown when local cache operations fail.
class CacheException implements Exception {
  final String message;
  const CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}
