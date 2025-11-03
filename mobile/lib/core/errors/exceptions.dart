/// Base class for all exceptions in the application.
class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

/// Represents a cache exception.
class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}

/// Represents a server exception.
class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred']);
}

/// Represents a network exception.
class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error occurred']);
}

/// Represents a database exception.
class DatabaseException extends AppException {
  const DatabaseException([super.message = 'Database error occurred']);
}
