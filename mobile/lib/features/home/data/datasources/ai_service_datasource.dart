import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class AIServiceDataSource {
  Future<Map<String, dynamic>> sendMessage(String message);
}

int min(int a, int b) => a < b ? a : b;

class AIChatService {
  static const String baseUrl = 'https://g6-ethio-football.onrender.com';

  Future<Map<String, dynamic>> sendMessage(String message) async {
    print('🔍 [AI_CHAT_DEBUG] Starting API request...');
    print('🔍 [AI_CHAT_DEBUG] Message: "$message"');
    print('🔍 [AI_CHAT_DEBUG] Base URL: $baseUrl');
    print('🔍 [AI_CHAT_DEBUG] Full URL: $baseUrl/intent/parse');

    // Try different request formats in case the API expects different field names
    final requestFormats = [
      {'query': message},
      {'text': message},
      {'input': message},
      {'prompt': message},
      {'question': message},
      {'message': message}, // fallback to original
      {'user_input': message}, // try different field names
      {'request': message},
      {
        'data': {'text': message},
      }, // nested format
      {
        'payload': {'message': message},
      }, // another nested format
    ];

    for (int i = 0; i < requestFormats.length; i++) {
      final requestBody = requestFormats[i];
      final fieldName = requestBody.keys.first;

      print(
        '🔍 [AI_CHAT_DEBUG] Trying request format ${i + 1}/${requestFormats.length} with field: "$fieldName"',
      );
      print('🔍 [AI_CHAT_DEBUG] Request Body: ${json.encode(requestBody)}');

      try {
        final uri = Uri.parse('$baseUrl/intent/parse');
        print('🔍 [AI_CHAT_DEBUG] Parsed URI: $uri');

        final headers = {'Content-Type': 'application/json'};
        print('🔍 [AI_CHAT_DEBUG] Headers: $headers');

        print('🔍 [AI_CHAT_DEBUG] Sending POST request...');
        final response = await http
            .post(uri, headers: headers, body: json.encode(requestBody))
            .timeout(const Duration(seconds: 30)); // Add timeout

        print('🔍 [AI_CHAT_DEBUG] Response received!');
        print('🔍 [AI_CHAT_DEBUG] Status Code: ${response.statusCode}');
        print('🔍 [AI_CHAT_DEBUG] Response Headers: ${response.headers}');
        print(
          '🔍 [AI_CHAT_DEBUG] Response Body Length: ${response.body.length} characters',
        );

        if (response.body.isNotEmpty) {
          print(
            '🔍 [AI_CHAT_DEBUG] Response Body Preview: ${response.body.substring(0, min(200, response.body.length))}...',
          );
        } else {
          print('🔍 [AI_CHAT_DEBUG] Response Body is EMPTY!');
        }

        if (response.statusCode == 200) {
          print('🔍 [AI_CHAT_DEBUG] Status 200 - Parsing JSON response...');
          try {
            final decodedResponse =
                json.decode(response.body) as Map<String, dynamic>;
            print('🔍 [AI_CHAT_DEBUG] Successfully parsed JSON response');
            print(
              '🔍 [AI_CHAT_DEBUG] Response Keys: ${decodedResponse.keys.toList()}',
            );

            if (decodedResponse.containsKey('markdown')) {
              print(
                '🔍 [AI_CHAT_DEBUG] Markdown field found: ${decodedResponse['markdown']?.substring(0, min(100, decodedResponse['markdown']?.length ?? 0))}...',
              );
            } else {
              print(
                '🔍 [AI_CHAT_DEBUG] WARNING: No markdown field in response!',
              );
            }

            if (decodedResponse.containsKey('source')) {
              print('🔍 [AI_CHAT_DEBUG] Source: ${decodedResponse['source']}');
            }

            if (decodedResponse.containsKey('freshness')) {
              print(
                '🔍 [AI_CHAT_DEBUG] Freshness: ${decodedResponse['freshness']}',
              );
            }

            return decodedResponse;
          } catch (parseError) {
            print('🔍 [AI_CHAT_DEBUG] ERROR parsing JSON: $parseError');
            print('🔍 [AI_CHAT_DEBUG] Raw response body: ${response.body}');
            throw Exception('Failed to parse JSON response: $parseError');
          }
        } else {
          print(
            '🔍 [AI_CHAT_DEBUG] ERROR: Non-200 status code: ${response.statusCode}',
          );
          print('🔍 [AI_CHAT_DEBUG] Error response body: ${response.body}');

          // If this is not the last format to try, continue to next format
          if (i < requestFormats.length - 1) {
            print('🔍 [AI_CHAT_DEBUG] Trying next request format...');
            continue;
          } else {
            // This was the last format, throw the error
            throw Exception(
              'Failed to get response: ${response.statusCode} - ${response.body}',
            );
          }
        }
      } catch (requestError) {
        print(
          '🔍 [AI_CHAT_DEBUG] EXCEPTION in request format ${i + 1}: $requestError',
        );

        // If this is not the last format to try, continue to next format
        if (i < requestFormats.length - 1) {
          print('🔍 [AI_CHAT_DEBUG] Trying next request format...');
          continue;
        } else {
          // This was the last format, re-throw the error
          throw Exception('Network error: $requestError');
        }
      }
    }

    // If we get here, all formats failed
    throw Exception(
      'All request formats failed. Last error was for field: ${requestFormats.last.keys.first}',
    );
  }
}
