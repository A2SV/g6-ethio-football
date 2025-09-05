import 'package:dartz/dartz.dart';
import 'package:ethio_football/core/errors/failures.dart';
import 'package:ethio_football/features/my_clubs/data/data_sources/my_clubs_local_data.dart';
import 'package:ethio_football/features/my_clubs/domain/entities/club.dart';
import 'package:ethio_football/features/my_clubs/domain/repositories/my_clubs_repository.dart';

class MyClubsRepositoryImpl implements MyClubsRepository {
  final MyClubsLocalDataSource localDataSource;

  MyClubsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Club>>> getAllClubs() async {
    final result = await localDataSource.getAllClubs();
    return result.fold((failure) => Left(failure), (clubs) => Right(clubs));
  }

  @override
  Future<Either<Failure, List<Club>>> getAllFollowedClubs() async {
    final result = await localDataSource.getAllFollowedClubs();
    return result.fold((failure) => Left(failure), (clubs) => Right(clubs));
  }

  @override
  Future<Either<Failure, List<Club>>> filterClub(League league) async {
    final result = await localDataSource.filterClub(league);
    return result.fold((failure) => Left(failure), (clubs) => Right(clubs));
  }

  @override
  Future<Either<Failure, void>> followClub(String clubId) async {
    final result = await localDataSource.followClub(clubId);
    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<Failure, void>> unfollowClub(String clubId) async {
    final result = await localDataSource.unfollowClub(clubId);
    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<Failure, void>> searchClub(String query) async {
    final result = await localDataSource.searchClub(query);
    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }
}
