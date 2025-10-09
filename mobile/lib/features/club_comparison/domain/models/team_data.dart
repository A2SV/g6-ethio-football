/// Model representing data for a football team.
/// Includes basic info like name and id, as well as detailed stats like honors, recent form, notable players, and fanbase notes.
import 'package:equatable/equatable.dart';

class TeamData extends Equatable {
  final String id;
  final String name;
  final int matchesPlayed;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;

  const TeamData({
    required this.id,
    required this.name,
    required this.matchesPlayed,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsFor,
    required this.goalsAgainst,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    matchesPlayed,
    wins,
    draws,
    losses,
    goalsFor,
    goalsAgainst,
  ];

  factory TeamData.fromJson(Map<String, dynamic> json) {
    return TeamData(
      id: json['id'] != null ? json['id'].toString() : '',
      name: json['name'] as String,
      matchesPlayed: json['matches_played'] as int,
      wins: json['wins'] as int,
      draws: json['draws'] as int,
      losses: json['losses'] as int,
      goalsFor: json['goals_for'] as int,
      goalsAgainst: json['goals_against'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'matches_played': matchesPlayed,
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'goals_for': goalsFor,
      'goals_against': goalsAgainst,
    };
  }
}
