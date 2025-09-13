import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sample_a2sv_final/core/error/failures.dart';
import 'package:sample_a2sv_final/core/usecases/usecase.dart';
import 'package:sample_a2sv_final/features/home/domain/entities/message.dart';
import 'package:sample_a2sv_final/features/home/domain/repositories/home_repository.dart';

class SendIntent implements UseCase<ChatMessage, SendIntentParams> {
  final HomeRepository repository;

  SendIntent(this.repository);

  @override
  Future<Either<Failure, ChatMessage>> call(SendIntentParams params) async {
    return await repository.sendIntent(params.query);
  }
}

class SendIntentParams extends Equatable {
  final String query;

  const SendIntentParams({required this.query});

  @override
  List<Object?> get props => [query];
}