import '../entities/chat_message.dart';
import '../repositories/ai_service_repository.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final AIServiceRepository aiRepository;
  final ChatRepository chatRepository;

  SendMessage(this.aiRepository, this.chatRepository);

  Future<ChatMessage> call(String message) async {
    // Send message to AI service
    final response = await aiRepository.sendMessage(message);

    // Extract markdown from response
    final markdown =
        response['markdown'] as String? ??
        'Sorry, I couldn\'t process your request.';

    // Create AI response message
    final aiMessage = ChatMessage(
      text: markdown,
      isUser: false,
      timestamp: DateTime.now(),
    );

    // Save to local storage
    await chatRepository.saveChatMessage(aiMessage);

    return aiMessage;
  }
}
