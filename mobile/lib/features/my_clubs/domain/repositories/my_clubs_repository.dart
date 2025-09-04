import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/club.dart';

abstract class MyClubsRepository {
  Future<Either<Failure, List<Club>>> getAllClubs();
  Future<Either<Failure, List<Club>>> getAllFollowedClubs();
  Future<Either<Failure, void>> followClub(Club club);
  Future<Either<Failure, void>> unfollowClub(Club club);
}
