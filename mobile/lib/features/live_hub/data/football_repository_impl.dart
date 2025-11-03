import 'package:ethio_football/core/utils/database_helper.dart';

import '../domain/entities.dart';
import '../domain/football_repository.dart';
import 'football_api_client.dart';
import 'models.dart';

class FootballRepositoryImpl implements FootballRepository {
  final FootballApiClient api;
  final DatabaseHelper _db = DatabaseHelper.instance;

  FootballRepositoryImpl(this.api);

  @override
  Future<Map<String, dynamic>> standings(String league) async {
    try {
      // Try to get fresh data from API
      final response = await api.getStandings(league);

      // Cache the data in SQLite
      final standingsData = response.standings
          .map(
            (d) => {
              'rank': d.rank,
              'teamName': d.teamName,
              'teamLogo': d.teamLogo,
              'points': d.points,
              'matchesPlayed': d.matchesPlayed,
              'wins': d.wins,
              'losses': d.losses,
              'draws': d.draws,
              'goalsDiff': d.goalsDiff,
            },
          )
          .toList();

      await _db.insertStandings(league, standingsData);

      final standings = response.standings
          .map(
            (d) => Standing(
              position: d.rank,
              team: d.teamName,
              teamLogo: d.teamLogo,
              points: d.points,
              matchPlayed: d.matchesPlayed,
              wins: d.wins,
              lose: d.losses,
              draw: d.draws,
              gd: d.goalsDiff,
            ),
          )
          .toList();

      return {'standings': standings, 'season': response.season};
    } catch (e) {
      // If API fails, try to get cached data
      final cachedData = await _db.getStandings(league);
      if (cachedData.isNotEmpty) {
        final standings = cachedData
            .map(
              (data) => Standing(
                position: data['rank'] as int,
                team: data['teamName'] as String,
                teamLogo: data['teamLogo'] as String? ?? '',
                points: data['points'] as int,
                matchPlayed: data['matchesPlayed'] as int,
                wins: data['wins'] as int,
                lose: data['losses'] as int,
                draw: data['draws'] as int,
                gd: data['goalsDiff'] as int,
              ),
            )
            .toList();

        return {
          'standings': standings,
          'season':
              DateTime.now().year, // Fallback to current year for cached data
        };
      }
      rethrow;
    }
  }

  @override
  Future<List<Fixture>> fixtures({
    required String league,
    String? team,
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      // For date-based queries, use the previous fixtures endpoint
      if (from != null && to != null && from == to) {
        // This is a single date query
        final response = await api.getFixturesByDate(
          league: league,
          date: from,
        );

        // Convert PreviousFixturesResponseDto to FixturesResponseDto format
        final fixtures = response.fixtures.map((fixture) {
          // Generate unique ID based on fixture data to avoid conflicts
          // Use league, home team, away team, and date for guaranteed uniqueness
          final dateStr = fixture.date.toIso8601String().split('T')[0];
          final uniqueId =
              '${fixture.league}_${fixture.homeTeam.name}_${fixture.awayTeam.name}_${dateStr}';
          return FixtureDto(
            id: uniqueId,
            homeTeam: fixture.homeTeam.name,
            awayTeam: fixture.awayTeam.name,
            league: fixture.league,
            kickoff: fixture.date,
            status: 'FINISHED', // Previous fixtures are finished
            score: '${fixture.goals.home}-${fixture.goals.away}',
          );
        }).toList();

        final fixturesResponse = FixturesResponseDto(
          fixtures: fixtures,
          freshness: FreshnessDto(
            source: response.source,
            retrieved: DateTime.now(),
          ),
        );

        // Cache the data in SQLite
        final fixturesData = fixturesResponse.fixtures
            .map(
              (d) => {
                'id': d.id,
                'league': d.league,
                'homeTeam': d.homeTeam,
                'awayTeam': d.awayTeam,
                'kickoff': d.kickoff.toIso8601String(),
                'status': d.status,
                'score': d.score,
              },
            )
            .toList();

        await _db.insertFixtures(fixturesData);

        return fixturesResponse.fixtures
            .map(
              (d) => Fixture(
                id: d.id,
                homeTeam: d.homeTeam,
                awayTeam: d.awayTeam,
                league: d.league,
                kickoff: d.kickoff,
                status: d.status,
                score: d.score,
              ),
            )
            .toList();
      } else {
        // For general queries without specific dates, return empty list
        // In a real implementation, you might want to implement a different endpoint
        return [];
      }
    } catch (e) {
      // If API fails, try to get cached data
      final cachedData = await _db.getFixtures(league: league);
      if (cachedData.isNotEmpty) {
        return cachedData
            .map(
              (data) => Fixture(
                id: data['id'] as String,
                homeTeam: data['homeTeam'] as String,
                awayTeam: data['awayTeam'] as String,
                league: data['league'] as String,
                kickoff: DateTime.parse(data['kickoff'] as String),
                status: data['status'] as String,
                score: data['score'] as String?,
              ),
            )
            .toList();
      }
      rethrow;
    }
  }

  @override
  Future<List<LiveScore>> liveScores() async {
    try {
      // Try to get fresh data from API
      final response = await api.getLiveScores();

      // Cache the data in SQLite
      final liveScoresData = response.liveScores
          .map(
            (d) => {
              'id': d.id,
              'league': d.league,
              'homeTeam': d.homeTeam,
              'awayTeam': d.awayTeam,
              'kickoff': d.kickoff.toIso8601String(),
              'status': d.status,
              'score': d.score,
            },
          )
          .toList();

      await _db.insertLiveScores(liveScoresData);

      return response.liveScores
          .map(
            (d) => LiveScore(
              id: d.id,
              homeTeam: d.homeTeam,
              awayTeam: d.awayTeam,
              league: d.league,
              kickoff: d.kickoff,
              status: d.status,
              score: d.score,
            ),
          )
          .toList();
    } catch (e) {
      // If API fails, try to get cached data
      final cachedData = await _db.getLiveScores();
      if (cachedData.isNotEmpty) {
        return cachedData
            .map(
              (data) => LiveScore(
                id: data['id'] as String,
                homeTeam: data['homeTeam'] as String,
                awayTeam: data['awayTeam'] as String,
                league: data['league'] as String,
                kickoff: DateTime.parse(data['kickoff'] as String),
                status: data['status'] as String,
                score: data['score'] as String,
              ),
            )
            .toList();
      }
      rethrow;
    }
  }

  @override
  Future<List<PreviousFixture>> previousFixtures({
    required String league,
    required int round,
    required int season,
  }) async {
    try {
      print(
        '🔍 [REPOSITORY_DEBUG] Fetching previous fixtures from API: league=$league, round=$round, season=$season',
      );
      // Get fresh data from API
      final response = await api.getPreviousFixtures(
        league: league,
        round: round,
        season: season,
      );
      print(
        '🔍 [REPOSITORY_DEBUG] API response received: ${response.fixtures.length} fixtures',
      );

      // Convert API response to entity objects - handle fixture_id = 0 issue
      final fixtures = response.fixtures.map((fixture) {
        // Generate unique fixture_id if it's 0 or invalid
        var fixtureId = fixture.fixtureId;
        if (fixtureId == 0 || fixtureId == null) {
          // Generate unique ID based on match details
          final dateStr = fixture.date.toIso8601String().split('T')[0];
          final uniqueString =
              '${fixture.league}_${fixture.homeTeam.name}_${fixture.awayTeam.name}_${dateStr}';
          fixtureId = uniqueString.hashCode.abs(); // Use hash as unique ID
        }

        return PreviousFixture(
          fixtureId: fixtureId,
          date: fixture.date,
          venue: fixture.venue,
          league: fixture.league,
          round: fixture.round,
          homeTeam: Team(
            name: fixture.homeTeam.name,
            logo: fixture.homeTeam.logo,
          ),
          awayTeam: Team(
            name: fixture.awayTeam.name,
            logo: fixture.awayTeam.logo,
          ),
          goals: Goals(home: fixture.goals.home, away: fixture.goals.away),
          score: Score(
            halftime: ScoreDetail(
              home: fixture.score.halftime.home,
              away: fixture.score.halftime.away,
            ),
            fulltime: ScoreDetail(
              home: fixture.score.fulltime.home,
              away: fixture.score.fulltime.away,
            ),
            extratime: fixture.score.extratime != null
                ? ScoreDetail(
                    home: fixture.score.extratime!.home,
                    away: fixture.score.extratime!.away,
                  )
                : null,
            penalty: fixture.score.penalty != null
                ? ScoreDetail(
                    home: fixture.score.penalty!.home,
                    away: fixture.score.penalty!.away,
                  )
                : null,
          ),
          status: MatchStatus(
            long: fixture.status.long,
            short: fixture.status.short,
            elapsed: fixture.status.elapsed,
            extra: fixture.status.extra,
          ),
        );
      }).toList();

      // Cache the data in SQLite - handle fixture_id = 0 issue
      final fixturesData = response.fixtures.map((fixture) {
        // Generate unique fixture_id if it's 0 or invalid
        var fixtureId = fixture.fixtureId;
        if (fixtureId == 0 || fixtureId == null) {
          // Generate unique ID based on match details
          final dateStr = fixture.date.toIso8601String().split('T')[0];
          final uniqueString =
              '${fixture.league}_${fixture.homeTeam.name}_${fixture.awayTeam.name}_${dateStr}';
          fixtureId = uniqueString.hashCode.abs(); // Use hash as unique ID
          print(
            '🔍 [REPOSITORY_DEBUG] Generated unique fixture_id: $fixtureId for ${fixture.homeTeam.name} vs ${fixture.awayTeam.name}',
          );
        }

        return {
          'fixture_id': fixtureId,
          'date': fixture.date.toIso8601String(),
          'venue': fixture.venue,
          'league': fixture.league,
          'round': fixture.round,
          'home_team_name': fixture.homeTeam.name,
          'home_team_logo': fixture.homeTeam.logo,
          'away_team_name': fixture.awayTeam.name,
          'away_team_logo': fixture.awayTeam.logo,
          'home_goals': fixture.goals.home,
          'away_goals': fixture.goals.away,
          'halftime_home': fixture.score.halftime.home,
          'halftime_away': fixture.score.halftime.away,
          'fulltime_home': fixture.score.fulltime.home,
          'fulltime_away': fixture.score.fulltime.away,
          'extratime_home': fixture.score.extratime?.home,
          'extratime_away': fixture.score.extratime?.away,
          'penalty_home': fixture.score.penalty?.home,
          'penalty_away': fixture.score.penalty?.away,
          'status_long': fixture.status.long,
          'status_short': fixture.status.short,
          'status_elapsed': fixture.status.elapsed,
          'status_extra': fixture.status.extra,
        };
      }).toList();

      try {
        await _db.insertPreviousFixtures(fixturesData);
        print(
          '🔍 [REPOSITORY_DEBUG] Successfully cached ${fixturesData.length} fixtures',
        );
      } catch (dbError) {
        print('🔍 [REPOSITORY_DEBUG] Database insertion failed: $dbError');
        // Continue without caching if database fails
      }

      return fixtures;
    } catch (e) {
      print('🔍 [REPOSITORY_DEBUG] API failed, trying cached data: $e');
      // If API fails, try to get cached data
      final cachedData = await _db.getPreviousFixtures(
        league: league,
        limit: 20,
      );
      if (cachedData.isNotEmpty) {
        print(
          '🔍 [REPOSITORY_DEBUG] Using ${cachedData.length} cached fixtures',
        );
        return cachedData
            .map(
              (data) => PreviousFixture(
                fixtureId: data['fixture_id'] as int,
                date: DateTime.parse(data['date'] as String),
                venue: data['venue'] as String,
                league: data['league'] as String,
                round: data['round'] as String,
                homeTeam: Team(
                  name: data['home_team_name'] as String,
                  logo: data['home_team_logo'] as String,
                ),
                awayTeam: Team(
                  name: data['away_team_name'] as String,
                  logo: data['away_team_logo'] as String,
                ),
                goals: Goals(
                  home: data['home_goals'] as int,
                  away: data['away_goals'] as int,
                ),
                score: Score(
                  halftime: ScoreDetail(
                    home: data['halftime_home'] as int?,
                    away: data['halftime_away'] as int?,
                  ),
                  fulltime: ScoreDetail(
                    home: data['fulltime_home'] as int?,
                    away: data['fulltime_away'] as int?,
                  ),
                  extratime:
                      (data['extratime_home'] != null &&
                          data['extratime_away'] != null)
                      ? ScoreDetail(
                          home: data['extratime_home'] as int?,
                          away: data['extratime_away'] as int?,
                        )
                      : null,
                  penalty:
                      (data['penalty_home'] != null &&
                          data['penalty_away'] != null)
                      ? ScoreDetail(
                          home: data['penalty_home'] as int?,
                          away: data['penalty_away'] as int?,
                        )
                      : null,
                ),
                status: MatchStatus(
                  long: data['status_long'] as String,
                  short: data['status_short'] as String,
                  elapsed: data['status_elapsed'] as int,
                  extra: data['status_extra'] as int,
                ),
              ),
            )
            .toList();
      }
      print(
        '🔍 [REPOSITORY_DEBUG] No cached data available, returning empty list',
      );
      // Return empty list if no cached data
      return [];
    }
  }

  @override
  Future<List<LiveMatch>> liveMatches(String league) async {
    try {
      // Get fresh data from API
      final response = await api.getLiveMatches(league);

      return response.matches
          .map(
            (match) => LiveMatch(
              fixtureId: match.fixtureId,
              date: match.date,
              venue: match.venue,
              league: match.league,
              round: match.round,
              homeTeam: Team(
                name: match.homeTeam.name,
                logo: match.homeTeam.logo,
              ),
              awayTeam: Team(
                name: match.awayTeam.name,
                logo: match.awayTeam.logo,
              ),
              goals: Goals(home: match.goals.home, away: match.goals.away),
              score: Score(
                halftime: ScoreDetail(
                  home: match.score.halftime.home,
                  away: match.score.halftime.away,
                ),
                fulltime: ScoreDetail(
                  home: match.score.fulltime.home,
                  away: match.score.fulltime.away,
                ),
                extratime: match.score.extratime != null
                    ? ScoreDetail(
                        home: match.score.extratime!.home,
                        away: match.score.extratime!.away,
                      )
                    : null,
                penalty: match.score.penalty != null
                    ? ScoreDetail(
                        home: match.score.penalty!.home,
                        away: match.score.penalty!.away,
                      )
                    : null,
              ),
              status: MatchStatus(
                long: match.status.long,
                short: match.status.short,
                elapsed: match.status.elapsed,
                extra: match.status.extra,
              ),
            ),
          )
          .toList();
    } catch (e) {
      // Return empty list if API fails
      return [];
    }
  }
}
