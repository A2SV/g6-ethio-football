/// Implementation of the ComparisonRepository interface.
/// This repository handles data operations for club comparisons, including fetching comparison data from the data source
/// and retrieving club lists from the local database. It uses Either to handle success and failure cases.
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
    print(
      '🔍 [COMPARISON_REPO] Starting comparison data fetch for clubs: $clubAId vs $clubBId',
    );
    print(
      '🔍 [COMPARISON_REPO] Using API IDs: teamAId=$clubAId, teamBId=$clubBId',
    );

    try {
      final jsonData = await dataSource.getComparisonData(
        teamAId: clubAId.toString(),
        teamBId: clubBId.toString(),
        league: 'ETH', // Default to ETH, can be made dynamic later
      );
      print('🔍 [COMPARISON_REPO] Data source returned data, parsing JSON...');
      final comparisonResponse = ComparisonResponse.fromJson(jsonData);
      print('🔍 [COMPARISON_REPO] Successfully parsed comparison response');
      print(
        '🔍 [COMPARISON_REPO] Team A: ${comparisonResponse.comparisonData['team_a']?.name} (ID: ${comparisonResponse.comparisonData['team_a']?.id})',
      );
      print(
        '🔍 [COMPARISON_REPO] Team B: ${comparisonResponse.comparisonData['team_b']?.name} (ID: ${comparisonResponse.comparisonData['team_b']?.id})',
      );
      return Right(comparisonResponse);
    } catch (e) {
      print('🔍 [COMPARISON_REPO] Error in getComparisonData: $e');
      print(
        '🔍 [COMPARISON_REPO] This might be due to invalid club IDs or API issues',
      );
      return Left(ServerFailure('Failed to fetch comparison data'));
    }
  }

  @override
  Future<Either<Failure, List<TeamData>>> getClubs() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final clubMaps = await dbHelper.getClubs();
      print(
        '🔍 [COMPARISON_REPO] Loaded ${clubMaps.length} clubs from database',
      );

      // Create sample data for TeamData fields
      final clubs = clubMaps.map((map) {
        final clubName = map['name'] as String;
        final league = map['league'] as String;
        final clubId = map['id'] as String;

        // Debug log first few clubs to verify IDs
        if (clubMaps.indexOf(map) < 5) {
          print(
            '🔍 [COMPARISON_REPO] Club: $clubName (ID: $clubId, League: $league)',
          );
        }

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
          matchesPlayed:
              0, // Default value, will be updated when comparison API is called
          wins: 0,
          draws: 0,
          losses: 0,
          goalsFor: 0,
          goalsAgainst: 0,
        );
      }).toList();

      return Right(clubs);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch clubs'));
    }
  }
}
