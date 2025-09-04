class Club {
  final String id;
  final String name;
  final String description;
  final bool isFollowed;
  final String short;
  final League league;

  Club({
    required this.id,
    required this.name,
    required this.description,
    required this.isFollowed,
    required this.short,
    required this.league,
  });
}

enum League { EPL, ETH }
