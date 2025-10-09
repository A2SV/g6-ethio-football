import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/club.dart';

abstract class MyClubsRepository {
  Future<Either<Failure, List<Club>>> getAllClubs();
  Future<Either<Failure, List<Club>>> getAllFollowedClubs();
  Future<Either<Failure, List<Club>>> filterClub(League league);
  Future<Either<Failure, void>> followClub(String clubId);
  Future<Either<Failure, void>> unfollowClub(String clubId);
  Future<Either<Failure, List<Club>>> searchClub(String query);
}
