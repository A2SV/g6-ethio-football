import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ethio_football/core/errors/failures.dart';
import 'package:ethio_football/features/my_clubs/domain/repositories/my_clubs_repository.dart';

import '../../../../core/usecase.dart';

class FollowClub implements UseCase<Unit, FollowClubParams> {
  final MyClubsRepository repository;

  FollowClub(this.repository);

  @override
  Future<Either<Failure, Unit>> call(FollowClubParams params) async {
    final result = await repository.followClub(params.clubId);
    return result.fold((failure) => Left(failure), (_) => Right(unit));
  }
}

class FollowClubParams extends Equatable {
  final String clubId;

  const FollowClubParams({required this.clubId});

  @override
  List<Object?> get props => [clubId];
}
