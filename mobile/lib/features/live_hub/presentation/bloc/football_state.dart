import 'package:equatable/equatable.dart';

import '../../domain/entities.dart';

abstract class FootballState extends Equatable {
  const FootballState();

  @override
  List<Object?> get props => [];
}

class FootballInitial extends FootballState {}

class FootballLoading extends FootballState {}

class FootballLoaded extends FootballState {
  final List<Standing> standings;
  final List<Fixture> fixtures;
  final List<LiveScore> liveScores;
  final List<PreviousFixture> previousFixtures;
  final List<LiveMatch> liveMatches;
  final String selectedLeague;
  final DateTime? selectedDate;
  final int? season;

  const FootballLoaded({
    required this.standings,
    required this.fixtures,
    required this.liveScores,
    this.previousFixtures = const [],
    this.liveMatches = const [],
    required this.selectedLeague,
    this.selectedDate,
    this.season,
  });

  @override
  List<Object?> get props => [
    standings,
    fixtures,
    liveScores,
    previousFixtures,
    liveMatches,
    selectedLeague,
    selectedDate,
    season,
  ];

  FootballLoaded copyWith({
    List<Standing>? standings,
    List<Fixture>? fixtures,
    List<LiveScore>? liveScores,
    List<PreviousFixture>? previousFixtures,
    List<LiveMatch>? liveMatches,
    String? selectedLeague,
    DateTime? selectedDate,
    int? season,
  }) {
    return FootballLoaded(
      standings: standings ?? this.standings,
      fixtures: fixtures ?? this.fixtures,
      liveScores: liveScores ?? this.liveScores,
      previousFixtures: previousFixtures ?? this.previousFixtures,
      liveMatches: liveMatches ?? this.liveMatches,
      selectedLeague: selectedLeague ?? this.selectedLeague,
      selectedDate: selectedDate ?? this.selectedDate,
      season: season ?? this.season,
    );
  }
}

class FootballError extends FootballState {
  final String message;

  const FootballError(this.message);

  @override
  List<Object?> get props => [message];
}
