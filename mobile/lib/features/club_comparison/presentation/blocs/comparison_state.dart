/// States for the ComparisonBloc representing different UI states during club comparison.
/// Includes states for initial, loading, loaded clubs, loaded comparison data, and error.
import 'package:equatable/equatable.dart';
import '../../domain/models/comparison_response.dart';
import '../../domain/models/team_data.dart';

abstract class ComparisonState extends Equatable {
  const ComparisonState();

  @override
  List<Object?> get props => [];
}

class ComparisonInitialState extends ComparisonState {
  const ComparisonInitialState();
}

class ClubsLoadedState extends ComparisonState {
  final List<TeamData> clubs;

  const ClubsLoadedState({required this.clubs});

  @override
  List<Object?> get props => [clubs];
}

class ComparisonLoadingState extends ComparisonState {
  const ComparisonLoadingState();
}

class ComparisonLoadedState extends ComparisonState {
  final ComparisonResponse comparisonResponse;

  const ComparisonLoadedState({required this.comparisonResponse});

  @override
  List<Object?> get props => [comparisonResponse];
}

class ComparisonErrorState extends ComparisonState {
  final String errorMessage;

  const ComparisonErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
