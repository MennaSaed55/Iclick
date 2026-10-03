import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';

/// Base class for all use cases that take parameters.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Base class for use cases that take no parameters.
abstract class UseCaseNoParams<T> {
  Future<Either<Failure, T>> call();
}

/// Placeholder for use cases that require no parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
