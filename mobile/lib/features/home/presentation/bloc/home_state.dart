import 'package:equatable/equatable.dart';
import 'package:ethio_football/features/home/domain/entities/chat_message.dart';
import 'package:ethio_football/features/home/presentation/pages/home_page.dart'
    as home_page;

abstract class HomeState extends Equatable {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const HomeState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [messages, isLoading, error];
}

class HomeInitial extends HomeState {
  const HomeInitial({super.messages, super.isLoading});
}

class HomeLoading extends HomeState {
  const HomeLoading({required super.messages, super.isLoading = true});
}

class HomeLoaded extends HomeState {
  const HomeLoaded({required super.messages});

  // Helper to add a new message
  HomeLoaded addMessage(ChatMessage newMessage) {
    return HomeLoaded(messages: List.from(messages)..add(newMessage));
  }

  HomeLoaded updateLastMessage(ChatMessage updatedMessage) {
    final List<ChatMessage> updatedList = List.from(messages);
    if (updatedList.isNotEmpty) {
      updatedList[updatedList.length - 1] = updatedMessage;
    }
    return HomeLoaded(messages: updatedList);
  }

  HomeLoaded removeLastMessage() {
    final List<ChatMessage> updatedList = List.from(messages);
    if (updatedList.isNotEmpty) {
      updatedList.removeLast();
    }
    return HomeLoaded(messages: updatedList);
  }
}

class HomeError extends HomeState {
  const HomeError({required super.messages, required super.error});
}
