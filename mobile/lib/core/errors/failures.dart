class Failure {
  final String message;
  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure() : super(message: "Server Failure");
}

class CacheFailure extends Failure {
  final String message;
  CacheFailure(this.message) : super(message: message);
}

class DatabaseFailure extends Failure {
  final String message;
  DatabaseFailure(this.message) : super(message: message);
}
