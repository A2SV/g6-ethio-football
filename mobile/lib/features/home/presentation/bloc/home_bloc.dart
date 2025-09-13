import 'package:bloc/bloc.dart';
import 'package:sample_a2sv_final/core/error/failures.dart';
import 'package:sample_a2sv_final/core/usecases/usecase.dart';
import 'package:sample_a2sv_final/features/home/domain/entities/message.dart';
import 'package:sample_a2sv_final/features/home/domain/usecases/get_initial_greeting.dart';
import 'package:sample_a2sv_final/features/home/domain/usecases/send_intent.dart';
import 'package:sample_a2sv_final/features/home/presentation/bloc/home_event.dart';
import 'package:sample_a2sv_final/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SendIntent sendIntent;
  final GetInitialGreeting getInitialGreeting;

  HomeBloc({
    required this.sendIntent,
    required this.getInitialGreeting,
  }) : super(const HomeInitial()) {
    on<LoadInitialMessages>(_onLoadInitialMessages);
    on<SendMessage>(_onSendMessage);
    on<CacheCurrentConversation>(_onCacheCurrentConversation);
  }

  Future<void> _onLoadInitialMessages(
      LoadInitialMessages event, Emitter<HomeState> emit) async {
    emit(HomeLoading(messages: state.messages));

    // First try to load from cache
    // The current repository only provides getCachedMessages, not initial
    // So for the *initial greeting* we'll always hit the network if no cache exists.
    // However, if there are *any* cached messages, we load them first.

    // This part requires HomeRepository to expose a way to get *cached* messages.
    // For now, let's just get the initial greeting from the network, and the caching
    // logic will be applied to the conversation.

    // Add a placeholder "Loading..." message
    final loadingMessage = ChatMessage(
        text: 'Loading initial conversation...',
        sender: MessageSender.ai,
        timestamp: DateTime.now());
    emit(HomeLoaded(messages: [loadingMessage]));

    final result = await getInitialGreeting(NoParams());
    result.fold(
          (failure) => emit(HomeError(
          messages: [
            ChatMessage(
                text: _mapFailureToMessage(failure),
                sender: MessageSender.ai,
                timestamp: DateTime.now())
          ],
          error: _mapFailureToMessage(failure))),
          (message) {
        emit(HomeLoaded(messages: [message])); // Replace loading with actual message
      },
    );
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<HomeState> emit) async {
    final userMessage = ChatMessage(
      text: event.message,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    // Add user message immediately
    emit(HomeLoaded(messages: List.from(state.messages)..add(userMessage)));

    // Add "Typing..." message
    final typingMessage = ChatMessage(
      text: 'Typing...',
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
    );
    emit(HomeLoaded(messages: List.from(state.messages)..add(typingMessage)));

    final result = await sendIntent(SendIntentParams(query: event.message));

    result.fold(
          (failure) {
        // Remove typing message and add error message
        final updatedMessages = List<ChatMessage>.from(state.messages)..removeLast();
        emit(HomeError(
          messages: updatedMessages
            ..add(ChatMessage(
                text: 'Error: ${_mapFailureToMessage(failure)}',
                sender: MessageSender.ai,
                timestamp: DateTime.now())),
          error: _mapFailureToMessage(failure),
        ));
      },
          (aiMessage) {
        // Remove typing message and add AI response
        final updatedMessages = List<ChatMessage>.from(state.messages)..removeLast();
        emit(HomeLoaded(messages: updatedMessages..add(aiMessage)));
      },
    );
  }

  Future<void> _onCacheCurrentConversation(
      CacheCurrentConversation event, Emitter<HomeState> emit) async {
    // This event should be dispatched when the app is paused or closed,
    // or when the conversation reaches a significant point.
    // For now, let's assume the repository has a method for it.
    // The repository implementation will handle the actual caching.
    // await repository.cacheCurrentMessages(state.messages); // Assuming repository is available here
    // Note: The bloc does not directly hold the repository instance like this.
    // We need to pass it or have a separate use case for caching.
    // For now, let's omit the direct caching event if it's handled implicitly or elsewhere.
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case CacheFailure:
        return 'Cache Error';
      case NetworkFailure:
        return 'Please check your internet connection.';
      default:
        return 'Unexpected Error';
    }
  }
}