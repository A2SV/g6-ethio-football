import 'dart:convert';
import 'package:http/http.dart' as http;

/// A simple HTTP client wrapper for making API requests.
class HttpClient {
  final http.Client _client;
  final String baseUrl;

  HttpClient({this.baseUrl = 'https://api.example.com'})
    : _client = http.Client();

  /// Performs a GET request and returns JSON.
  Future<dynamic> getJson(
    String endpoint, {
    Map<String, String>? params,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
    final response = await _client.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  /// Performs a GET request.
  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    return await _client.get(Uri.parse(url), headers: headers);
  }

  /// Performs a POST request.
  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    return await _client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  /// Performs a PUT request.
  Future<http.Response> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    return await _client.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  /// Performs a DELETE request.
  Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    return await _client.delete(Uri.parse(url), headers: headers);
  }

  /// Closes the client.
  void close() {
    _client.close();
  }
}
