import 'package:equatable/equatable.dart';

abstract class FootballEvent extends Equatable {
  const FootballEvent();

  @override
  List<Object?> get props => [];
}

class LoadStandings extends FootballEvent {
  final String league;

  const LoadStandings(this.league);

  @override
  List<Object?> get props => [league];
}

class LoadFixtures extends FootballEvent {
  final String league;

  const LoadFixtures(this.league);

  @override
  List<Object?> get props => [league];
}

class LoadLiveScores extends FootballEvent {
  const LoadLiveScores();
}

class ChangeLeague extends FootballEvent {
  final String league;

  const ChangeLeague(this.league);

  @override
  List<Object?> get props => [league];
}

class RefreshData extends FootballEvent {
  const RefreshData();
}

class LoadFixturesByDate extends FootballEvent {
  final DateTime date;
  final String league;

  const LoadFixturesByDate(this.date, this.league);

  @override
  List<Object?> get props => [date, league];
}

class LoadPreviousFixtures extends FootballEvent {
  final String league;
  final int round;
  final int season;

  const LoadPreviousFixtures({
    required this.league,
    required this.round,
    required this.season,
  });

  @override
  List<Object?> get props => [league, round, season];
}

class LoadLiveMatches extends FootballEvent {
  final String league;

  const LoadLiveMatches(this.league);

  @override
  List<Object?> get props => [league];
}
