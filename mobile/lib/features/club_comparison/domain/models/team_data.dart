import 'package:equatable/equatable.dart';

class TeamData extends Equatable {
  final String id;
  final String name;
  final List<String> honors;
  final List<String> recentForm;
  final List<String> notablePlayers;
  final String fanbaseNotes;

  const TeamData({
    required this.id,
    required this.name,
    required this.honors,
    required this.recentForm,
    required this.notablePlayers,
    required this.fanbaseNotes,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    honors,
    recentForm,
    notablePlayers,
    fanbaseNotes,
  ];

  factory TeamData.fromJson(Map<String, dynamic> json) {
    return TeamData(
      id: json['id'] as String,
      name: json['name'] as String,
      honors: List<String>.from(json['honors'] as List),
      recentForm: List<String>.from(json['recent_form'] as List),
      notablePlayers: List<String>.from(json['notable_players'] as List),
      fanbaseNotes: json['fanbase_notes'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'honors': honors,
      'recent_form': recentForm,
      'notable_players': notablePlayers,
      'fanbase_notes': fanbaseNotes,
    };
  }
}
