import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    required String text,
    required bool isUser,
    required DateTime timestamp,
    bool isLoading = false,
  }) : super(
         text: text,
         isUser: isUser,
         timestamp: timestamp,
         isLoading: isLoading,
       );

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      text: json['text'] as String,
      isUser: (json['isUser'] as int) == 1,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isLoading: (json['isLoading'] as int?) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser ? 1 : 0,
      'timestamp': timestamp.toIso8601String(),
      'isLoading': isLoading ? 1 : 0,
    };
  }

  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      text: entity.text,
      isUser: entity.isUser,
      timestamp: entity.timestamp,
      isLoading: entity.isLoading,
    );
  }
}
