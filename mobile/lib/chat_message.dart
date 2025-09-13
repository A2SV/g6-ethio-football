import 'package:equatable/equatable.dart';

enum MessageSender { user, ai }

class ChatMessage extends Equatable {
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final List<String>? suggestions;

  const ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
    this.suggestions,
  });

  @override
  List<Object?> get props => [text, sender, timestamp, suggestions];
}