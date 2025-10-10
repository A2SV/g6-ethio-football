import 'entities.dart';

abstract class FootballRepository {
  Future<Map<String, dynamic>> standings(String league);
  Future<List<Fixture>> fixtures({
    required String league,
    String? team,
    DateTime? from,
    DateTime? to,
  });
  Future<List<LiveScore>> liveScores();
  Future<List<PreviousFixture>> previousFixtures({
    required String league,
    required int round,
    required int season,
  });
  Future<List<LiveMatch>> liveMatches(String league);
}
