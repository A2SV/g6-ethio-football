import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialMessages extends HomeEvent {}

class SendMessage extends HomeEvent {
  final String message;

  const SendMessage({required this.message});

  @override
  List<Object> get props => [message];
}

class CacheCurrentConversation extends HomeEvent {
  // Add any parameters if needed, e.g., the current list of messages
  const CacheCurrentConversation();
}