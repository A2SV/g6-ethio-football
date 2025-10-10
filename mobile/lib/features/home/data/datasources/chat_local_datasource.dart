import '../../domain/entities/chat_message.dart';

abstract class ChatLocalDataSource {
  Future<List<ChatMessage>> getChatMessages({int? limit});
  Future<void> saveChatMessage(ChatMessage message);
  Future<void> deleteChatMessage(String messageId);
  Future<void> clearAllMessages();
}
