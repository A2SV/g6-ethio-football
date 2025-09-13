import 'package:sample_a2sv_final/chat_message.dart'; // Import the base entity

class MessageModel extends ChatMessage {
  const MessageModel({
    required String text,
    required MessageSender sender,
    required DateTime timestamp,
    List<String>? suggestions,
  }) : super(
    text: text,
    sender: sender,
    timestamp: timestamp,
    suggestions: suggestions,
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      text: json['text'],
      sender: json['sender'] == 'user' ? MessageSender.user : MessageSender.ai,
      timestamp: DateTime.parse(json['timestamp']),
      suggestions: json['suggestions'] != null
          ? List<String>.from(json['suggestions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sender': sender == MessageSender.user ? 'user' : 'ai',
      'timestamp': timestamp.toIso8601String(),
      'suggestions': suggestions,
    };
  }

  // Helper to convert ChatMessage to MessageModel if needed (e.g., for caching)
  factory MessageModel.fromEntity(ChatMessage entity) {
    return MessageModel(
      text: entity.text,
      sender: entity.sender,
      timestamp: entity.timestamp,
      suggestions: entity.suggestions,
    );
  }
}