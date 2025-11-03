import 'package:bloc/bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

/// BLoC for managing home screen state.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadInitialMessages>(_onLoadInitialMessages);
    on<SendMessage>(_onSendMessage);
  }

  void _onLoadInitialMessages(
    LoadInitialMessages event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      // Simulate loading messages
      await Future.delayed(const Duration(seconds: 1));
      final messages = ['Welcome to Ethio Football!', 'Latest news loaded.'];
      emit(HomeLoaded(messages));
    } catch (e) {
      emit(HomeError('Failed to load messages'));
    }
  }

  void _onSendMessage(SendMessage event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final updatedMessages = List<String>.from(currentState.messages)
        ..add(event.message)
        ..add('AI Response: ${event.message}'); // Simple echo for now

      emit(HomeLoaded(updatedMessages));
    }
  }

  /// Clear chat messages.
  void clearChatMessages() {
    if (state is HomeLoaded) {
      emit(HomeLoaded([]));
    }
  }
}
