import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase.dart';
import '../../../club_comparison/data/datasources/comparison_data_source.dart';
import '../../../club_comparison/domain/models/comparison_response.dart';
import '../../../club_comparison/domain/models/team_data.dart';
import '../../domain/usecases/get_clubs_usecase.dart';
import 'comparison_event.dart';
import 'comparison_state.dart';

class ComparisonBloc extends Bloc<ComparisonEvent, ComparisonState> {
  final GetClubsUseCase getClubsUseCase;
  final ComparisonDataSource _comparisonDataSource;

  int? _selectedClubAId;
  int? _selectedClubBId;
  List<TeamData> _clubs = [];

  ComparisonBloc({
    required this.getClubsUseCase,
    required ComparisonDataSource comparisonDataSource,
  }) : _comparisonDataSource = comparisonDataSource,
       super(const ComparisonInitialState()) {
    on<SelectClubEvent>(_onSelectClub);
    on<FetchComparisonDataEvent>(_onFetchComparisonData);
    on<LoadClubsEvent>(_onLoadClubs);
  }

  void _onSelectClub(SelectClubEvent event, Emitter<ComparisonState> emit) {
    final clubId = event.clubId;
    if (_selectedClubAId == clubId) {
      _selectedClubAId = null;
    } else if (_selectedClubBId == clubId) {
      _selectedClubBId = null;
    } else if (_selectedClubAId == null) {
      _selectedClubAId = clubId;
    } else if (_selectedClubBId == null && clubId != _selectedClubAId) {
      _selectedClubBId = clubId;
    }
  }

  void _onLoadClubs(LoadClubsEvent event, Emitter<ComparisonState> emit) async {
    final result = await getClubsUseCase.call(NoParams());

    result.fold(
      (failure) => emit(ComparisonErrorState(errorMessage: failure.message)),
      (clubs) {
        _clubs = clubs;
        emit(ClubsLoadedState(clubs: clubs));
      },
    );
  }

  Future<void> _onFetchComparisonData(
    FetchComparisonDataEvent event,
    Emitter<ComparisonState> emit,
  ) async {
    emit(const ComparisonLoadingState());

    try {
      final jsonData = await _comparisonDataSource.getComparisonData();
      final comparisonResponse = ComparisonResponse.fromJson(jsonData);
      emit(ComparisonLoadedState(comparisonResponse: comparisonResponse));
    } catch (e) {
      emit(ComparisonErrorState(errorMessage: e.toString()));
    }
  }
}
