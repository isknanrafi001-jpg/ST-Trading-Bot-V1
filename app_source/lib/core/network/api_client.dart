import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/market_pair.dart';
import 'api_config.dart';

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Future<Map<String, dynamic>> login(String email, String password) async {
    return _post('/auth/login', {'email': email, 'password': password});
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    return _post('/auth/register', {
      'displayName': name,
      'email': email,
      'password': password,
    });
  }

  Future<List<Map<String, dynamic>>> pairs() async {
    final body = await _get('/market/pairs');
    if (body is List) {
      return body.cast<Map<String, dynamic>>();
    }
    return const [];
  }

  Future<MarketPair> analyze(String symbol, String market) async {
    final body = await _post('/signals/analyze', {
      'symbol': symbol,
      'market': market.toUpperCase(),
    });
    return MarketPair.fromJson(body);
  }

  Future<List<MarketPair>> scan({
    required double minimumConfidence,
    required String market,
  }) async {
    final body = await _post('/signals/scan', {
      'minimumConfidence': minimumConfidence,
      'market': market,
    });
    final data = body['data'];
    if (data is! List) return const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(MarketPair.fromJson)
        .toList();
  }

  Future<List<MarketPair>> history() async {
    final body = await _get('/signals/history?limit=100');
    if (body is! List) return const [];
    return body
        .whereType<Map<String, dynamic>>()
        .map(MarketPair.fromJson)
        .toList();
  }

  Future<dynamic> _get(String path) async {
    _requireConfiguration();
    try {
      final response = await _client
          .get(Uri.parse('${ApiConfig.baseUrl}$path'))
          .timeout(const Duration(seconds: 15));
      return _decode(response);
    } catch (error) {
      if (error is ApiException) rethrow;
      throw const ApiException('Server connection failed.');
    }
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> payload,
  ) async {
    _requireConfiguration();
    try {
      final response = await _client
          .post(
            Uri.parse('${ApiConfig.baseUrl}$path'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 15));
      final body = _decode(response);
      if (body is Map<String, dynamic>) return body;
      throw const ApiException('Invalid server response.');
    } catch (error) {
      if (error is ApiException) rethrow;
      throw const ApiException('Server connection failed.');
    }
  }

  dynamic _decode(http.Response response) {
    dynamic body;
    try {
      body = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);
    } catch (_) {
      throw const ApiException('Server returned invalid data.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = body is Map
          ? (body['message'] is List
              ? (body['message'] as List).join(', ')
              : body['message'])
          : null;
      throw ApiException(message?.toString() ?? 'Request failed.');
    }
    return body;
  }

  void _requireConfiguration() {
    if (!ApiConfig.isConfigured) {
      throw const ApiException('Backend URL is not configured.');
    }
  }
}
