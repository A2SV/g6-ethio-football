import 'package:ethio_football/core/network/http_client.dart';
import 'models.dart';

class FootballApiClient {
  FootballApiClient(this._http);

  final HttpClient _http;

  // GET /standings?league=EPL|ETH&season=2021
  Future<StandingsResponseDto> getStandings(String league) async {
    final currentYear = DateTime.now().year;
    final url = 'https://g6-ethio-football.onrender.com/api/standings';
    final json = await _http.getJson(
      url,
      params: {'league': league, 'season': currentYear.toString()},
    );
    return StandingsResponseDto.fromJson(json);
  }

  // GET /api/previous-fixtures?league=ETH&round=1&season=2023
  // For date-based filtering, we'll use the previous fixtures endpoint
  Future<PreviousFixturesResponseDto> getFixturesByDate({
    required String league,
    required DateTime date,
  }) async {
    // Extract year from date for season parameter
    final season = date.year;
    // For simplicity, we'll use round 1 for date-based queries
    // In a real implementation, you might want to determine the round based on the date
    final round = 1;

    final params = <String, String>{
      'league': league,
      'round': round.toString(),
      'season': season.toString(),
    };
    final json = await _http.getJson('/api/previous-fixtures', params: params);
    return PreviousFixturesResponseDto.fromJson(json);
  }

  // GET /news/liveScores
  Future<LiveScoresResponseDto> getLiveScores() async {
    final json = await _http.getJson('/news/liveScores');
    return LiveScoresResponseDto.fromJson(json);
  }

  // GET /api/previous-fixtures?league=ETH&round=1&season=2023
  Future<PreviousFixturesResponseDto> getPreviousFixtures({
    required String league,
    required int round,
    required int season,
  }) async {
    print(
      '🔍 [API_CLIENT_DEBUG] Making HTTP request to /api/previous-fixtures',
    );
    print(
      '🔍 [API_CLIENT_DEBUG] Params: league=$league, round=$round, season=$season',
    );
    final params = {
      'league': league,
      'round': round.toString(),
      'season': season.toString(),
    };
    final json = await _http.getJson('/api/previous-fixtures', params: params);
    print('🔍 [API_CLIENT_DEBUG] HTTP response received for previous fixtures');
    return PreviousFixturesResponseDto.fromJson(json);
  }

  // GET /api/live?league=ETH
  Future<LiveMatchesResponseDto> getLiveMatches(String league) async {
    final params = {'league': league};
    final json = await _http.getJson('/api/live', params: params);
    return LiveMatchesResponseDto.fromJson(json);
  }
}
