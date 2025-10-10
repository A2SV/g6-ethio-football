class StandingDto {
  final int rank;
  final String teamName;
  final String teamLogo;
  final int points;
  final int matchesPlayed;
  final int wins;
  final int losses;
  final int draws;
  final int goalsDiff;

  StandingDto({
    required this.rank,
    required this.teamName,
    required this.teamLogo,
    required this.points,
    required this.matchesPlayed,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.goalsDiff,
  });

  factory StandingDto.fromJson(Map<String, dynamic> j) => StandingDto(
        rank: j['rank'],
        teamName: j['teamName'],
        teamLogo: j['teamLogo'] ?? '',
        points: j['points'],
        matchesPlayed: j['matchesPlayed'],
        wins: j['wins'],
        losses: j['losses'],
        draws: j['draws'],
        goalsDiff: j['goalsDiff'],
      );
}

// Response wrapper for standings endpoint
class StandingsResponseDto {
  final int leagueId;
  final String leagueName;
  final String country;
  final String countryFlag;
  final int season;
  final List<StandingDto> standings;
  final String lastUpdated;

  StandingsResponseDto({
    required this.leagueId,
    required this.leagueName,
    required this.country,
    required this.countryFlag,
    required this.season,
    required this.standings,
    required this.lastUpdated,
  });

  factory StandingsResponseDto.fromJson(Map<String, dynamic> json) {
    return StandingsResponseDto(
      leagueId: json['leagueId'] ?? 0,
      leagueName: json['leagueName'] ?? '',
      country: json['country'] ?? '',
      countryFlag: json['countryFlag'] ?? '',
      season: json['season'] ?? 2021,
      standings: (json['standings'] as List?)
              ?.map(
                  (item) => StandingDto.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      lastUpdated: json['lastUpdated'] ?? '',
    );
  }
}

class FixtureDto {
  final String id, homeTeam, awayTeam, league, status;
  final DateTime kickoff;
  final String? score;

  FixtureDto({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.league,
    required this.kickoff,
    required this.status,
    this.score,
  });

  factory FixtureDto.fromJson(Map<String, dynamic> j) => FixtureDto(
        id: j['id'],
        homeTeam: j['home_team'],
        awayTeam: j['away_team'],
        league: j['league'],
        kickoff: DateTime.parse(j['kickoff']),
        status: j['status'],
        score: j['score'],
      );
}

// Response wrapper for fixtures endpoint
class FixturesResponseDto {
  final List<FixtureDto> fixtures;
  final FreshnessDto freshness;

  FixturesResponseDto({
    required this.fixtures,
    required this.freshness,
  });

  factory FixturesResponseDto.fromJson(Map<String, dynamic> json) {
    return FixturesResponseDto(
      fixtures: (json['fixtures'] as List?)
              ?.map((item) => FixtureDto.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      freshness: FreshnessDto.fromJson(json['freshness'] ?? {}),
    );
  }
}

// Live scores response model
class LiveScoreDto {
  final String id, homeTeam, awayTeam, league, status, score;
  final DateTime kickoff;

  LiveScoreDto({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.league,
    required this.kickoff,
    required this.status,
    required this.score,
  });

  factory LiveScoreDto.fromJson(Map<String, dynamic> j) => LiveScoreDto(
        id: j['id'],
        homeTeam: j['home_team'],
        awayTeam: j['away_team'],
        league: j['league'],
        kickoff: DateTime.parse(j['kickoff']),
        status: j['status'],
        score: j['score'] ?? '',
      );
}

// Response wrapper for live scores endpoint
class LiveScoresResponseDto {
  final List<LiveScoreDto> liveScores;
  final FreshnessDto freshness;

  LiveScoresResponseDto({
    required this.liveScores,
    required this.freshness,
  });

  factory LiveScoresResponseDto.fromJson(Map<String, dynamic> json) {
    return LiveScoresResponseDto(
      liveScores: (json['liveScores'] as List?)
              ?.map(
                  (item) => LiveScoreDto.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      freshness: FreshnessDto.fromJson(json['freshness'] ?? {}),
    );
  }
}

class FreshnessDto {
  final String source;
  final DateTime retrieved;

  FreshnessDto({required this.source, required this.retrieved});

  factory FreshnessDto.fromJson(Map<String, dynamic> json) {
    return FreshnessDto(
      source: json['source'] ?? 'unknown',
      retrieved:
          DateTime.parse(json['retrieved'] ?? DateTime.now().toIso8601String()),
    );
  }
}

// Previous Fixtures Models
class PreviousFixturesResponseDto {
  final List<PreviousFixtureDto> fixtures;
  final String source;

  PreviousFixturesResponseDto({
    required this.fixtures,
    required this.source,
  });

  factory PreviousFixturesResponseDto.fromJson(Map<String, dynamic> json) {
    return PreviousFixturesResponseDto(
      fixtures: (json['result'] as List?)
              ?.map((item) =>
                  PreviousFixtureDto.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      source: json['source'] ?? 'unknown',
    );
  }
}

class PreviousFixtureDto {
  final int fixtureId;
  final DateTime date;
  final String venue;
  final String league;
  final String round;
  final TeamDto homeTeam;
  final TeamDto awayTeam;
  final GoalsDto goals;
  final ScoreDto score;
  final StatusDto status;

  PreviousFixtureDto({
    required this.fixtureId,
    required this.date,
    required this.venue,
    required this.league,
    required this.round,
    required this.homeTeam,
    required this.awayTeam,
    required this.goals,
    required this.score,
    required this.status,
  });

  factory PreviousFixtureDto.fromJson(Map<String, dynamic> json) {
    return PreviousFixtureDto(
      fixtureId: json['fixture_id'] ?? 0,
      date: DateTime.parse(json['date']),
      venue: json['venue'] ?? '',
      league: json['league'] ?? '',
      round: json['round'] ?? '',
      homeTeam: TeamDto.fromJson(json['home_team']),
      awayTeam: TeamDto.fromJson(json['away_team']),
      goals: GoalsDto.fromJson(json['goals']),
      score: ScoreDto.fromJson(json['score']),
      status: StatusDto.fromJson(json['status']),
    );
  }
}

class TeamDto {
  final String name;
  final String logo;

  TeamDto({
    required this.name,
    required this.logo,
  });

  factory TeamDto.fromJson(Map<String, dynamic> json) {
    return TeamDto(
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
}

class GoalsDto {
  final int home;
  final int away;

  GoalsDto({
    required this.home,
    required this.away,
  });

  factory GoalsDto.fromJson(Map<String, dynamic> json) {
    return GoalsDto(
      home: json['home'] ?? 0,
      away: json['away'] ?? 0,
    );
  }
}

class ScoreDto {
  final ScoreDetailDto halftime;
  final ScoreDetailDto fulltime;
  final ScoreDetailDto? extratime;
  final ScoreDetailDto? penalty;

  ScoreDto({
    required this.halftime,
    required this.fulltime,
    this.extratime,
    this.penalty,
  });

  factory ScoreDto.fromJson(Map<String, dynamic> json) {
    return ScoreDto(
      halftime: ScoreDetailDto.fromJson(json['halftime']),
      fulltime: ScoreDetailDto.fromJson(json['fulltime']),
      extratime: json['extratime'] != null
          ? ScoreDetailDto.fromJson(json['extratime'])
          : null,
      penalty: json['penalty'] != null
          ? ScoreDetailDto.fromJson(json['penalty'])
          : null,
    );
  }
}

class ScoreDetailDto {
  final int? home;
  final int? away;

  ScoreDetailDto({
    this.home,
    this.away,
  });

  factory ScoreDetailDto.fromJson(Map<String, dynamic> json) {
    return ScoreDetailDto(
      home: json['home'],
      away: json['away'],
    );
  }
}

class StatusDto {
  final String long;
  final String short;
  final int elapsed;
  final int extra;

  StatusDto({
    required this.long,
    required this.short,
    required this.elapsed,
    required this.extra,
  });

  factory StatusDto.fromJson(Map<String, dynamic> json) {
    return StatusDto(
      long: json['long'] ?? '',
      short: json['short'] ?? '',
      elapsed: json['elapsed'] ?? 0,
      extra: json['extra'] ?? 0,
    );
  }
}

// Live Matches Models
class LiveMatchesResponseDto {
  final List<LiveMatchDto> matches;
  final String source;

  LiveMatchesResponseDto({
    required this.matches,
    required this.source,
  });

  factory LiveMatchesResponseDto.fromJson(Map<String, dynamic> json) {
    return LiveMatchesResponseDto(
      matches: (json['result'] as List?)
              ?.map(
                  (item) => LiveMatchDto.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      source: json['source'] ?? 'unknown',
    );
  }
}

class LiveMatchDto {
  final int fixtureId;
  final DateTime date;
  final String venue;
  final String league;
  final String round;
  final TeamDto homeTeam;
  final TeamDto awayTeam;
  final GoalsDto goals;
  final ScoreDto score;
  final StatusDto status;

  LiveMatchDto({
    required this.fixtureId,
    required this.date,
    required this.venue,
    required this.league,
    required this.round,
    required this.homeTeam,
    required this.awayTeam,
    required this.goals,
    required this.score,
    required this.status,
  });

  factory LiveMatchDto.fromJson(Map<String, dynamic> json) {
    return LiveMatchDto(
      fixtureId: json['fixture_id'] ?? 0,
      date: DateTime.parse(json['date']),
      venue: json['venue'] ?? '',
      league: json['league'] ?? '',
      round: json['round'] ?? '',
      homeTeam: TeamDto.fromJson(json['home_team']),
      awayTeam: TeamDto.fromJson(json['away_team']),
      goals: GoalsDto.fromJson(json['goals']),
      score: ScoreDto.fromJson(json['score']),
      status: StatusDto.fromJson(json['status']),
    );
  }
}
