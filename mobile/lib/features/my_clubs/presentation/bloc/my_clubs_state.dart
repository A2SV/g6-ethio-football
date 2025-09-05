import 'package:equatable/equatable.dart';
import '../../domain/entities/club.dart';

abstract class MyClubsState extends Equatable {
  const MyClubsState();

  @override
  List<Object?> get props => [];
}

class MyClubsInitial extends MyClubsState {}

class MyClubsLoading extends MyClubsState {}

class MyClubsLoaded extends MyClubsState {
  final List<Club> clubs;

  const MyClubsLoaded(this.clubs);

  @override
  List<Object?> get props => [clubs];
}

class MyClubsError extends MyClubsState {
  final String message;

  const MyClubsError(this.message);

  @override
  List<Object?> get props => [message];
}

class MyClubsActionSuccess extends MyClubsState {
  final String message;

  const MyClubsActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
