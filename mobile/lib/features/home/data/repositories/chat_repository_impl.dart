import 'package:dartz/dartz.dart';
import 'package:ethio_football/core/errors/failures.dart';
import 'package:ethio_football/core/utils/database_helper.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource localDataSource;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  ChatRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<ChatMessage>>> getChatMessages({
    int? limit,
  }) async {
    try {
      final cachedMessages = await _dbHelper.getChatMessages(limit: limit);
      final messages = cachedMessages
          .map((msg) => ChatMessageModel.fromJson(msg))
          .toList();
      return Right(messages);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get chat messages: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveChatMessage(ChatMessage message) async {
    try {
      final model = ChatMessageModel.fromEntity(message);
      await _dbHelper.saveChatMessage(
        model.text,
        model.isUser,
        model.timestamp,
        isLoading: model.isLoading,
      );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to save chat message: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteChatMessage(String messageId) async {
    try {
      final id = int.tryParse(messageId);
      if (id == null) {
        return Left(DatabaseFailure('Invalid message ID: $messageId'));
      }
      await _dbHelper.deleteChatMessage(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete chat message: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllMessages() async {
    try {
      await _dbHelper.clearChatMessages();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to clear chat messages: $e'));
    }
  }
}
