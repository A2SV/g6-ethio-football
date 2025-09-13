// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:sample_a2sv_final/app_constants.dart';
// import 'package:sample_a2sv_final/core/error/failures.dart';
// import 'package:sample_a2sv_final/features/home/data/models/message_model.dart';
//
// abstract class HomeRemoteDataSource {
//   Future<MessageModel> sendIntent(String query);
//   Future<MessageModel> getInitialGreeting(); // For the "Hello Ethiopian Football Fans!"
// }
//
// class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
//   final http.Client client;
//
//   HomeRemoteDataSourceImpl({required this.client});
//
//   @override
//   Future<MessageModel> sendIntent(String query) async {
//     final response = await client.post(
//       Uri.parse('${AppConstants.BASE_URL}${AppConstants.INTENT_PARSE_ENDPOINT}'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'text': query}), // Matches Postman doc for POST /intent/parse
//     );
//
//     if (response.statusCode == 200) {
//       final decodedData = json.decode(response.body);
//       // The API returns markdown. We need to parse suggestions if present.
//       // For now, let's assume if the initial message is a greeting, it might have suggestions.
//       // This part might need adjustment based on how your backend sends suggestions.
//       List<String>? suggestions;
//       if (decodedData['suggestions'] != null && decodedData['suggestions'] is List) {
//         suggestions = List<String>.from(decodedData['suggestions']);
//       }
//       return MessageModel(
//         text: decodedData['markdown'],
//         sender: MessageSender.ai,
//         timestamp: DateTime.now(),
//         suggestions: suggestions,
//       );
//     } else {
//       throw ServerFailure(message: 'Failed to send intent: ${response.statusCode}');
//     }
//   }
//
//   @override
//   Future<MessageModel> getInitialGreeting() async {
//     // This is a special case. The current backend setup from the Postman docs
//     // doesn't have a direct "get greeting" endpoint.
//     // We'll simulate this by calling the intent endpoint with a generic query
//     // that the backend *might* interpret as needing a general greeting/fixture list.
//     // Based on your image, "give me a fixture of today" returns a greeting.
//     // If your backend has a dedicated greeting endpoint, use that.
//     return await sendIntent('give me a fixture of today');
//   }
// }






import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sample_a2sv_final/app_constants.dart';
import 'package:sample_a2sv_final/core/error/failures.dart';
import 'package:sample_a2sv_final/features/home/data/models/message_model.dart';
import 'package:sample_a2sv_final/chat_message.dart'; // Import ChatMessage to access MessageSender enum

abstract class HomeRemoteDataSource {
  Future<MessageModel> sendIntent(String query);
  Future<MessageModel> getInitialGreeting(); // For the "Hello Ethiopian Football Fans!"
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final http.Client client;

  HomeRemoteDataSourceImpl({required this.client});

  @override
  Future<MessageModel> sendIntent(String query) async {
    final response = await client.post(
      Uri.parse('${AppConstants.BASE_URL}${AppConstants.INTENT_PARSE_ENDPOINT}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'text': query}), // Matches Postman doc for POST /intent/parse
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      // The API returns markdown. We need to parse suggestions if present.
      // For now, let's assume if the initial message is a greeting, it might have suggestions.
      // This part might need adjustment based on how your backend sends suggestions.
      List<String>? suggestions;
      if (decodedData['suggestions'] != null && decodedData['suggestions'] is List) {
        suggestions = List<String>.from(decodedData['suggestions']);
      }
      return MessageModel(
        text: decodedData['markdown'],
        sender: MessageSender.ai, // Corrected: MessageSender is an enum from chat_message.dart
        timestamp: DateTime.now(),
        suggestions: suggestions,
      );
    } else {
      throw ServerFailure(message: 'Failed to send intent: ${response.statusCode}');
    }
  }

  @override
  Future<MessageModel> getInitialGreeting() async {
    // This is a special case. The current backend setup from the Postman docs
    // doesn't have a direct "get greeting" endpoint.
    // We'll simulate this by calling the intent endpoint with a generic query
    // that the backend *might* interpret as needing a general greeting/fixture list.
    // Based on your image, "give me a fixture of today" returns a greeting.
    // If your backend has a dedicated greeting endpoint, use that.
    return await sendIntent('give me a fixture of today');
  }
}