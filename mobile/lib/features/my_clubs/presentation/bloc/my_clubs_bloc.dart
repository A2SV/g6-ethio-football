import 'package:bloc/bloc.dart';

import '../../domain/repositories/my_clubs_repository.dart';
import 'my_clubs_event.dart';
import 'my_clubs_state.dart';

class MyClubsBloc extends Bloc<MyClubsEvent, MyClubsState> {
  final MyClubsRepository repository;

  MyClubsBloc({required this.repository}) : super(MyClubsInitial()) {
    on<LoadAllClubs>(_onLoadAllClubs);
    on<LoadFollowedClubs>(_onLoadFollowedClubs);
    on<FollowClubEvent>(_onFollowClub);
    on<UnfollowClubEvent>(_onUnfollowClub);
    on<SearchClubsEvent>(_onSearchClubs);
    on<FilterClubsEvent>(_onFilterClubs);
  }

  Future<void> _onLoadAllClubs(
    LoadAllClubs event,
    Emitter<MyClubsState> emit,
  ) async {
    emit(MyClubsLoading());
    final result = await repository.getAllClubs();
    result.fold(
      (failure) => emit(MyClubsError(failure.message)),
      (clubs) => emit(MyClubsLoaded(clubs)),
    );
  }

  Future<void> _onLoadFollowedClubs(
    LoadFollowedClubs event,
    Emitter<MyClubsState> emit,
  ) async {
    emit(MyClubsLoading());
    final result = await repository.getAllFollowedClubs();
    result.fold(
      (failure) => emit(MyClubsError(failure.message)),
      (clubs) => emit(MyClubsLoaded(clubs)),
    );
  }

  Future<void> _onFollowClub(
    FollowClubEvent event,
    Emitter<MyClubsState> emit,
  ) async {
    final result = await repository.followClub(event.clubId);
    result.fold(
      (failure) => emit(MyClubsError(failure.message)),
      (_) => add(LoadAllClubs()), // reload clubs after follow
    );
  }

  Future<void> _onUnfollowClub(
    UnfollowClubEvent event,
    Emitter<MyClubsState> emit,
  ) async {
    final result = await repository.unfollowClub(event.clubId);
    result.fold(
      (failure) => emit(MyClubsError(failure.message)),
      (_) => add(LoadAllClubs()), // reload clubs after unfollow
    );
  }

  Future<void> _onSearchClubs(
    SearchClubsEvent event,
    Emitter<MyClubsState> emit,
  ) async {
    emit(MyClubsLoading());
    final result = await repository.searchClub(event.query);
    result.fold(
      (failure) => emit(MyClubsError(failure.message)),
      (clubs) => emit(MyClubsLoaded(clubs)),
    );
  }

  Future<void> _onFilterClubs(
    FilterClubsEvent event,
    Emitter<MyClubsState> emit,
  ) async {
    emit(MyClubsLoading());
    final result = await repository.filterClub(event.league);
    result.fold(
      (failure) => emit(MyClubsError(failure.message)),
      (clubs) => emit(MyClubsLoaded(clubs)),
    );
  }
}
