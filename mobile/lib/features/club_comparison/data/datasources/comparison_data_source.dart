/// Data source for club comparison feature.
/// This class handles fetching comparison data from external sources.
/// Since the comparison API endpoint doesn't exist, we'll generate mock comparison data.
import '../../../../core/network/http_client.dart';

class ComparisonDataSource {
  final HttpClient _httpClient;

  ComparisonDataSource(this._httpClient);

  /// Fetches comparison data from the API
  /// Note: Since the comparison API endpoint doesn't exist, we'll generate mock data
  Future<Map<String, dynamic>> getComparisonData({
    required String teamAId,
    required String teamBId,
    required String league,
  }) async {
    print('🔍 [COMPARISON_DEBUG] Starting comparison data fetch');
    print(
      '🔍 [COMPARISON_DEBUG] Team A ID: $teamAId, Team B ID: $teamBId, League: $league',
    );

    // Try to call the API first, but if it fails, generate mock data
    try {
      final url = 'https://g6-ethio-football.onrender.com/compare/teams';
      final params = {'teamA': teamAId, 'teamB': teamBId, 'league': league};

      print('🔍 [COMPARISON_DEBUG] Attempting API call to: $url');
      print('🔍 [COMPARISON_DEBUG] Parameters: $params');

      final json = await _httpClient.getJson(url, params: params);
      print('🔍 [COMPARISON_DEBUG] API call successful, returning real data');
      return json;
    } catch (e) {
      // API endpoint doesn't exist or is not working, generate mock comparison data
      print(
        '🔍 [COMPARISON_DEBUG] API endpoint not available (Error: $e), generating mock comparison data',
      );
      return _generateMockComparisonData(teamAId, teamBId, league);
    }
  }

  /// Generates mock comparison data when API is not available
  Map<String, dynamic> _generateMockComparisonData(
    String teamAId,
    String teamBId,
    String league,
  ) {
    // Generate realistic mock data based on team IDs
    final teamAStats = _generateTeamStats(teamAId, league);
    final teamBStats = _generateTeamStats(teamBId, league);

    return {
      'comparison_data': {
        'team_a': {
          'id': teamAId,
          'name': _getTeamName(teamAId, league),
          'matches_played': teamAStats['matchesPlayed'],
          'wins': teamAStats['wins'],
          'draws': teamAStats['draws'],
          'losses': teamAStats['losses'],
          'goals_for': teamAStats['goalsFor'],
          'goals_against': teamAStats['goalsAgainst'],
        },
        'team_b': {
          'id': teamBId,
          'name': _getTeamName(teamBId, league),
          'matches_played': teamBStats['matchesPlayed'],
          'wins': teamBStats['wins'],
          'draws': teamBStats['draws'],
          'losses': teamBStats['losses'],
          'goals_for': teamBStats['goalsFor'],
          'goals_against': teamBStats['goalsAgainst'],
        },
      },
      'source': 'mock_data',
      'freshness': {'retrieved': DateTime.now().toIso8601String()},
    };
  }

  /// Generates realistic team statistics
  Map<String, dynamic> _generateTeamStats(String teamId, String league) {
    // Use team ID to generate consistent but varied stats
    final idHash = teamId.hashCode;
    final baseMatches = league == 'ETH'
        ? 22
        : 38; // Ethiopian vs English league

    // Generate stats based on team ID hash for consistency
    final matchesPlayed = baseMatches;
    final wins = (idHash % 15) + 5; // 5-19 wins
    final draws = (idHash % 8) + 2; // 2-9 draws
    final losses = matchesPlayed - wins - draws;
    final goalsFor =
        wins * 2 + draws + (idHash % 20); // 2 goals per win + draws + bonus
    final goalsAgainst =
        losses * 2 + draws + (idHash % 15); // 2 goals per loss + draws + bonus

    return {
      'matchesPlayed': matchesPlayed,
      'wins': wins,
      'draws': draws,
      'losses': losses > 0 ? losses : 0,
      'goalsFor': goalsFor,
      'goalsAgainst': goalsAgainst,
    };
  }

  /// Gets team name based on ID and league
  String _getTeamName(String teamId, String league) {
    // This is a simplified mapping - in a real app you'd fetch from database
    final teamNames = {
      'ETH': {
        '1': 'Saint George',
        '2': 'Ethiopian Coffee',
        '3': 'Awassa City',
        '4': 'Adama City',
        '5': 'Bahir Dar Kenema',
      },
      'EPL': {
        '6': 'Manchester United',
        '7': 'Chelsea',
        '8': 'Arsenal',
        '9': 'Liverpool',
        '10': 'Manchester City',
      },
    };

    return teamNames[league]?[teamId] ?? 'Team ${teamId}';
  }
}
