import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;
  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object?> get props => properties;
}

// General failures
class ServerFailure extends Failure {
  final String message;
  const ServerFailure({this.message = 'Server Error'});
  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class InvalidInputFailure extends Failure {}