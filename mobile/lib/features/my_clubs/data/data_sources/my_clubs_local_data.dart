import 'package:dartz/dartz.dart';
import 'package:ethio_football/core/errors/failures.dart';
import 'package:ethio_football/core/utils/database_helper.dart';
import 'package:ethio_football/features/my_clubs/data/models/club_model.dart';
import 'package:ethio_football/features/my_clubs/domain/entities/club.dart';

abstract class MyClubsLocalDataSource {
  Future<Either<Failure, List<Club>>> getAllClubs();
  Future<Either<Failure, List<Club>>> getAllFollowedClubs();
  Future<Either<Failure, void>> followClub(String clubId);
  Future<Either<Failure, void>> unfollowClub(String clubId);
  Future<Either<Failure, List<Club>>> searchClub(String query);
  Future<Either<Failure, List<Club>>> filterClub(League league);
}

class MyClubsLocalDataSourceImpl implements MyClubsLocalDataSource {
  final dbHelper = DatabaseHelper.instance;

  @override
  Future<Either<Failure, List<Club>>> getAllClubs() async {
    try {
      final db = await dbHelper.database;
      final result = await db.query('clubs');
      final clubs = result.map((e) => ClubModel.fromMap(e)).toList();
      return Right(clubs);
    } catch (e) {
      return Left(CacheFailure("Failed to load clubs: $e"));
    }
  }

  @override
  Future<Either<Failure, List<Club>>> getAllFollowedClubs() async {
    try {
      final db = await dbHelper.database;
      final result = await db.query(
        'clubs',
        where: 'isFollowed = ?',
        whereArgs: [1],
      );
      final clubs = result.map((e) => ClubModel.fromMap(e)).toList();
      return Right(clubs);
    } catch (e) {
      return Left(CacheFailure("Failed to load followed clubs: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> followClub(String clubId) async {
    try {
      final db = await dbHelper.database;
      await db.update(
        'clubs',
        {'isFollowed': 1},
        where: 'id = ?',
        whereArgs: [clubId],
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure("Failed to follow club: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> unfollowClub(String clubId) async {
    try {
      final db = await dbHelper.database;
      await db.update(
        'clubs',
        {'isFollowed': 0},
        where: 'id = ?',
        whereArgs: [clubId],
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure("Failed to unfollow club: $e"));
    }
  }

  @override
  Future<Either<Failure, List<Club>>> searchClub(String query) async {
    try {
      final db = await dbHelper.database;
      final result = await db.query(
        'clubs',
        where: 'LOWER(name) LIKE ?',
        whereArgs: ['%${query.toLowerCase()}%'],
      );
      final clubs = result.map((e) => ClubModel.fromMap(e)).toList();
      return Right(clubs);
    } catch (e) {
      return Left(CacheFailure("Search failed: $e"));
    }
  }

  @override
  Future<Either<Failure, List<Club>>> filterClub(League league) async {
    try {
      final db = await dbHelper.database;
      final result = await db.query(
        'clubs',
        where: 'league = ?',
        whereArgs: [league.name],
      );
      final clubs = result.map((e) => ClubModel.fromMap(e)).toList();
      return Right(clubs);
    } catch (e) {
      return Left(DatabaseFailure('Could not filter clubs'));
    }
  }
}
