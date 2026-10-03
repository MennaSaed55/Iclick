/// A simple functional Either type for clean error handling.
///
/// Avoids the dartz dependency while providing the same
/// Left (failure) / Right (success) semantics used in Clean Architecture.
sealed class Either<L, R> {
  const Either();

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;

  L get left => (this as Left<L, R>).value;
  R get right => (this as Right<L, R>).value;

  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return switch (this) {
      Left<L, R> l => onLeft(l.value),
      Right<L, R> r => onRight(r.value),
    };
  }
}

/// Represents the failure case (Left side).
final class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);
}

/// Represents the success case (Right side).
final class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);
}

/// Convenience constructors for creating Either values.
Either<L, R> left<L, R>(L value) => Left(value);
Either<L, R> right<L, R>(R value) => Right(value);
