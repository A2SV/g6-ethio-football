/// BLoC (Business Logic Component) for managing club comparison state and events.
/// Handles club selection, loading clubs from database, and fetching comparison data.
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase.dart';
import '../../../club_comparison/domain/models/comparison_response.dart';
import '../../../club_comparison/domain/models/team_data.dart';
import '../../../club_comparison/domain/repositories/comparison_repository.dart';
import '../../domain/usecases/get_clubs_usecase.dart';
import '../../domain/usecases/get_comparison_data_usecase.dart';
import 'comparison_event.dart';
import 'comparison_state.dart';

class ComparisonBloc extends Bloc<ComparisonEvent, ComparisonState> {
  final GetClubsUseCase getClubsUseCase;
  final GetComparisonDataUseCase getComparisonDataUseCase;
  final ComparisonRepository _comparisonRepository;

  int? _selectedClubAId;
  int? _selectedClubBId;
  List<TeamData> _clubs = [];

  ComparisonBloc({
    required this.getClubsUseCase,
    required this.getComparisonDataUseCase,
    required ComparisonRepository comparisonRepository,
  }) : _comparisonRepository = comparisonRepository,
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
    try {
      // Use the GetClubsUseCase to fetch clubs from database
      final result = await getClubsUseCase.call(NoParams());

      result.fold(
        (failure) => emit(ComparisonErrorState(errorMessage: failure.message)),
        (clubs) {
          _clubs = clubs;
          emit(ClubsLoadedState(clubs: clubs));
        },
      );
    } catch (e) {
      emit(ComparisonErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchComparisonData(
    FetchComparisonDataEvent event,
    Emitter<ComparisonState> emit,
  ) async {
    emit(const ComparisonLoadingState());

    try {
      final result = await getComparisonDataUseCase.call(
        ComparisonParams(clubAId: event.clubAId, clubBId: event.clubBId),
      );

      result.fold(
        (failure) => emit(ComparisonErrorState(errorMessage: failure.message)),
        (comparisonResponse) =>
            emit(ComparisonLoadedState(comparisonResponse: comparisonResponse)),
      );
    } catch (e) {
      emit(ComparisonErrorState(errorMessage: e.toString()));
    }
  }
}
