import 'package:equatable/equatable.dart';

class Club extends Equatable {
  final String id;
  final String name;
  final String description;
  final bool isFollowed;
  final String short;
  final League league;
  final String? logoUrl;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    isFollowed,
    short,
    league,
    logoUrl,
  ];

  const Club({
    required this.id,
    required this.name,
    required this.description,
    required this.isFollowed,
    required this.short,
    required this.league,
    required this.logoUrl,
  });
}

enum League { EPL, ETH }
