import '../../domain/entities/club.dart';

class ClubModel extends Club {
  const ClubModel({
    required String id,
    required String name,
    required String description,
    required bool isFollowed,
    required String short,
    required League league,
    String? logoUrl,
  }) : super(
         id: id,
         name: name,
         description: description,
         isFollowed: isFollowed,
         short: short,
         league: league,
         logoUrl: logoUrl,
       );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isFollowed': isFollowed ? 1 : 0,
      'short': short,
      'league': league.name, // stored as string
      'logoUrl': logoUrl,
    };
  }

  factory ClubModel.fromMap(Map<String, dynamic> map) {
    return ClubModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      isFollowed: map['isFollowed'] == 1,
      short: map['short'],
      league: League.values.firstWhere((e) => e.name == map['league']),
      logoUrl: map['logoUrl'],
    );
  }
}
