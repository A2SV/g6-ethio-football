/// States for the HomeBloc.
abstract class HomeState {}

/// Initial state.
class HomeInitial extends HomeState {}

/// Loading state.
class HomeLoading extends HomeState {}

/// Loaded state with messages.
class HomeLoaded extends HomeState {
  final List<String> messages;

  HomeLoaded(this.messages);
}

/// Error state.
class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
