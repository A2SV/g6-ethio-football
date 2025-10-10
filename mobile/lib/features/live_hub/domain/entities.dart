class Standing {
  final int position;
  final String team;
  final String teamLogo;
  final int points;
  final int matchPlayed;
  final int wins;
  final int lose;
  final int draw;
  final int gd;

  Standing({
    required this.position,
    required this.team,
    required this.teamLogo,
    required this.points,
    required this.matchPlayed,
    required this.wins,
    required this.lose,
    required this.draw,
    required this.gd,
  });
}

class Fixture {
  final String id, homeTeam, awayTeam, league, status;
  final DateTime kickoff;
  final String? score;

  Fixture({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.league,
    required this.kickoff,
    required this.status,
    this.score,
  });
}

class LiveScore {
  final String id, homeTeam, awayTeam, league, status, score;
  final DateTime kickoff;

  LiveScore({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.league,
    required this.kickoff,
    required this.status,
    required this.score,
  });
}

// Previous Fixture Entity
class PreviousFixture {
  final int fixtureId;
  final DateTime date;
  final String venue;
  final String league;
  final String round;
  final Team homeTeam;
  final Team awayTeam;
  final Goals goals;
  final Score score;
  final MatchStatus status;

  PreviousFixture({
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
}

// Live Match Entity
class LiveMatch {
  final int fixtureId;
  final DateTime date;
  final String venue;
  final String league;
  final String round;
  final Team homeTeam;
  final Team awayTeam;
  final Goals goals;
  final Score score;
  final MatchStatus status;

  LiveMatch({
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
}

// Supporting Entities
class Team {
  final String name;
  final String logo;

  Team({
    required this.name,
    required this.logo,
  });
}

class Goals {
  final int home;
  final int away;

  Goals({
    required this.home,
    required this.away,
  });
}

class Score {
  final ScoreDetail halftime;
  final ScoreDetail fulltime;
  final ScoreDetail? extratime;
  final ScoreDetail? penalty;

  Score({
    required this.halftime,
    required this.fulltime,
    this.extratime,
    this.penalty,
  });
}

class ScoreDetail {
  final int? home;
  final int? away;

  ScoreDetail({
    this.home,
    this.away,
  });
}

class MatchStatus {
  final String long;
  final String short;
  final int elapsed;
  final int extra;

  MatchStatus({
    required this.long,
    required this.short,
    required this.elapsed,
    required this.extra,
  });
}
