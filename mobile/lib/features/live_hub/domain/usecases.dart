import 'entities.dart';
import 'football_repository.dart';

class GetStandings {
  final FootballRepository repo;
  GetStandings(this.repo);
  Future<Map<String, dynamic>> call(String league) => repo.standings(league);
}

class GetFixtures {
  final FootballRepository repo;
  GetFixtures(this.repo);
  Future<List<Fixture>> call({
    required String league,
    String? team,
    DateTime? from,
    DateTime? to,
  }) => repo.fixtures(league: league, team: team, from: from, to: to);
}

class GetLiveScores {
  final FootballRepository repo;
  GetLiveScores(this.repo);
  Future<List<LiveScore>> call() => repo.liveScores();
}

class GetPreviousFixtures {
  final FootballRepository repo;
  GetPreviousFixtures(this.repo);
  Future<List<PreviousFixture>> call({
    required String league,
    required int round,
    required int season,
  }) => repo.previousFixtures(league: league, round: round, season: season);
}

class GetLiveMatches {
  final FootballRepository repo;
  GetLiveMatches(this.repo);
  Future<List<LiveMatch>> call(String league) => repo.liveMatches(league);
}
