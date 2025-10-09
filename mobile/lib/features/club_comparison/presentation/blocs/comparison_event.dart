/// Events for the ComparisonBloc to handle user interactions and data fetching.
/// Includes events for selecting clubs, loading clubs list, and fetching comparison data.
import 'package:equatable/equatable.dart';

abstract class ComparisonEvent extends Equatable {
  const ComparisonEvent();

  @override
  List<Object?> get props => [];
}

class SelectClubEvent extends ComparisonEvent {
  final int clubId;

  const SelectClubEvent({required this.clubId});

  @override
  List<Object?> get props => [clubId];
}

class FetchComparisonDataEvent extends ComparisonEvent {
  final int clubAId;
  final int clubBId;

  const FetchComparisonDataEvent({
    required this.clubAId,
    required this.clubBId,
  });

  @override
  List<Object?> get props => [clubAId, clubBId];
}

class LoadClubsEvent extends ComparisonEvent {
  const LoadClubsEvent();
}
