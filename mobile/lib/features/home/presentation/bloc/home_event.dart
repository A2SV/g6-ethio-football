/// Events for the HomeBloc.
abstract class HomeEvent {}

/// Event to load initial messages.
class LoadInitialMessages extends HomeEvent {}

/// Event to send a message to the AI.
class SendMessage extends HomeEvent {
  final String message;

  SendMessage(this.message);
}
