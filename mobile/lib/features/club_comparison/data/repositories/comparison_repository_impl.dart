import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/database_helper.dart';
import '../../domain/models/comparison_response.dart';
import '../../domain/models/team_data.dart';
import '../../domain/repositories/comparison_repository.dart';
import '../datasources/comparison_data_source.dart';

class ComparisonRepositoryImpl implements ComparisonRepository {
  final ComparisonDataSource dataSource;

  ComparisonRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, ComparisonResponse>> getComparisonData(
    int clubAId,
    int clubBId,
  ) async {
    try {
      final jsonData = await dataSource.getComparisonData();
      final comparisonResponse = ComparisonResponse.fromJson(jsonData);
      return Right(comparisonResponse);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<TeamData>>> getClubs() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final clubMaps = await dbHelper.getClubs();

      // Create sample data for TeamData fields
      final clubs = clubMaps.map((map) {
        final clubName = map['name'] as String;
        final league = map['league'] as String;

        // Generate sample data based on club name and league
        List<String> honors = [];
        List<String> recentForm = [];
        List<String> notablePlayers = [];
        String fanbaseNotes = '';

        if (league == 'ETH') {
          // Ethiopian Premier League clubs
          honors = [
            'Ethiopian Premier League Title 2022',
            'Ethiopian Cup 2021',
          ];
          recentForm = ['W', 'D', 'W', 'L', 'W'];
          notablePlayers = ['Local Star Player', 'Young Talent'];
          fanbaseNotes =
              '${clubName} has a passionate local following with strong community support.';
        } else if (league == 'EPL') {
          // English Premier League clubs
          if (clubName == 'Manchester United') {
            honors = [
              'Premier League (20)',
              'Champions League (3)',
              'FA Cup (12)',
            ];
            recentForm = ['W', 'L', 'W', 'D', 'W'];
            notablePlayers = ['Marcus Rashford', 'Bruno Fernandes', 'Casemiro'];
            fanbaseNotes =
                'One of the most supported clubs globally with millions of fans worldwide.';
          } else if (clubName == 'Chelsea') {
            honors = [
              'Premier League (6)',
              'Champions League (2)',
              'Europa League (2)',
            ];
            recentForm = ['D', 'W', 'W', 'L', 'D'];
            notablePlayers = ['Mason Mount', 'Reece James', 'Romelu Lukaku'];
            fanbaseNotes =
                'Known for their stylish play and strong academy system.';
          } else if (clubName == 'Arsenal') {
            honors = ['Premier League (13)', 'FA Cup (14)', 'League Cup (2)'];
            recentForm = ['W', 'W', 'L', 'D', 'W'];
            notablePlayers = [
              'Bukayo Saka',
              'Martin Odegaard',
              'Gabriel Jesus',
            ];
            fanbaseNotes =
                'Proud North London club with a rich history and passionate supporters.';
          }
        }

        return TeamData(
          id: map['id'] as String,
          name: clubName,
          honors: honors,
          recentForm: recentForm,
          notablePlayers: notablePlayers,
          fanbaseNotes: fanbaseNotes.isNotEmpty
              ? fanbaseNotes
              : (map['description'] as String? ?? ''),
        );
      }).toList();

      return Right(clubs);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
