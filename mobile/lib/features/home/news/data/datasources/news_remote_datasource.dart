import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For date parsing if needed

import '../../domain/entities/news_update_entity.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsUpdateEntity>> fetchPastMatches();
  Future<List<NewsUpdateEntity>> fetchStandings();
  Future<List<NewsUpdateEntity>> fetchFutureMatches();
  Future<List<NewsUpdateEntity>> fetchLiveScores();
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;
  final String baseUrl = "https://g6-ethio-football.onrender.com";

  NewsRemoteDataSourceImpl({required this.client});

  List<NewsUpdateEntity> _parseNewsResponse(dynamic jsonResponse, String type) {
    if (jsonResponse is Map<String, dynamic> && (jsonResponse.containsKey('news') || jsonResponse.containsKey('message'))) {
      List<dynamic> newsJson = jsonResponse['news'] ?? jsonResponse['message'];
      return newsJson.map((item) {
        // Attempt to parse a date from the string if it exists and is consistent
        DateTime? parsedDate;
        try {
          // This is a very basic attempt. You might need more robust regex or date parsing
          // depending on the exact format of dates in your news strings.
          final dateMatch = RegExp(r'\d{2} [A-Za-z]{3} \d{4}').firstMatch(item.toString());
          if (dateMatch != null) {
            parsedDate = DateFormat('dd MMM yyyy').parse(dateMatch.group(0)!);
          }
        } catch (e) {
          // Date parsing failed, keep parsedDate null
        }
        return NewsUpdateEntity(
          content: item.toString(),
          type: type,
          publishedAt: parsedDate,
        );
      }).toList();
    }
    throw Exception('Failed to parse news data for type: $type');
  }

  @override
  Future<List<NewsUpdateEntity>> fetchPastMatches() async {
    final response = await client.get(Uri.parse('$baseUrl/news/pastMatches'));
    if (response.statusCode == 200) {
      return _parseNewsResponse(json.decode(response.body), 'Past Match');
    } else {
      throw Exception('Failed to load past matches: ${response.statusCode}');
    }
  }

  @override
  Future<List<NewsUpdateEntity>> fetchStandings() async {
    final response = await client.get(Uri.parse('$baseUrl/news/standings'));
    if (response.statusCode == 200) {
      return _parseNewsResponse(json.decode(response.body), 'Standing');
    } else {
      throw Exception('Failed to load standings: ${response.statusCode}');
    }
  }

  @override
  Future<List<NewsUpdateEntity>> fetchFutureMatches() async {
    final response = await client.get(Uri.parse('$baseUrl/news/futureMatches'));
    if (response.statusCode == 200) {
      return _parseNewsResponse(json.decode(response.body), 'Future Match');
    } else {
      throw Exception('Failed to load future matches: ${response.statusCode}');
    }
  }

  @override
  Future<List<NewsUpdateEntity>> fetchLiveScores() async {
    final response = await client.get(Uri.parse('$baseUrl/news/liveScores'));
    if (response.statusCode == 200) {
      return _parseNewsResponse(json.decode(response.body), 'Live Score');
    } else {
      throw Exception('Failed to load live scores: ${response.statusCode}');
    }
  }
}