/// Base class for all failures in the application.
abstract class Failure {
  final String message;

  const Failure(this.message);
}

/// Represents a server failure.
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Represents a cache failure.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Represents a network failure.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Represents a database failure.
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}
