import 'package:equatable/equatable.dart';
import '../../domain/entities/club.dart';

abstract class MyClubsEvent extends Equatable {
  const MyClubsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllClubs extends MyClubsEvent {}

class LoadFollowedClubs extends MyClubsEvent {}

class FollowClubEvent extends MyClubsEvent {
  final String clubId;

  const FollowClubEvent(this.clubId);

  @override
  List<Object?> get props => [clubId];
}

class UnfollowClubEvent extends MyClubsEvent {
  final String clubId;

  const UnfollowClubEvent(this.clubId);

  @override
  List<Object?> get props => [clubId];
}

class SearchClubsEvent extends MyClubsEvent {
  final String query;

  const SearchClubsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterClubsEvent extends MyClubsEvent {
  final League league;

  const FilterClubsEvent(this.league);

  @override
  List<Object?> get props => [league];
}
