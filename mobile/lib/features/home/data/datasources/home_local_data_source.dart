import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sample_a2sv_final/app_constants.dart';
import 'package:sample_a2sv_final/core/error/failures.dart';
import 'package:sample_a2sv_final/features/home/data/models/message_model.dart';

abstract class HomeLocalDataSource {
  Future<List<MessageModel>> getLastMessages();
  Future<void> cacheMessages(List<MessageModel> messages);
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final SharedPreferences sharedPreferences;

  HomeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheMessages(List<MessageModel> messages) {
    final jsonString = json.encode(
      messages.map((message) => message.toJson()).toList(),
    );
    return sharedPreferences.setString(AppConstants.CACHED_MESSAGES, jsonString);
  }

  @override
  Future<List<MessageModel>> getLastMessages() {
    final jsonString = sharedPreferences.getString(AppConstants.CACHED_MESSAGES);
    if (jsonString != null) {
      final List<dynamic> decodedData = json.decode(jsonString);
      return Future.value(decodedData
          .map<MessageModel>((json) => MessageModel.fromJson(json))
          .toList());
    } else {
      throw CacheFailure();
    }
  }
}