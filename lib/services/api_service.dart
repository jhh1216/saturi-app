import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class ServerStatItem {
  final String regionName;
  final double average;
  final int attempts;
  final int best;

  const ServerStatItem({
    required this.regionName,
    required this.average,
    required this.attempts,
    required this.best,
  });

  factory ServerStatItem.fromJson(Map<String, dynamic> j) => ServerStatItem(
        regionName: j['region_name'] as String,
        average: (j['average'] as num).toDouble(),
        attempts: (j['attempts'] as num).toInt(),
        best: (j['best'] as num).toInt(),
      );
}

class ApiService {
  static final ApiService _i = ApiService._();
  factory ApiService() => _i;
  ApiService._();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (AuthService().token != null) 'Authorization': 'Bearer ${AuthService().token}',
      };

  Future<void> recordScore(String regionName, String sentence, int score) async {
    if (!AuthService().isLoggedIn) return;
    try {
      await http
          .post(
            Uri.parse('${ApiConfig.serverUrl}/stats'),
            headers: _headers,
            body: jsonEncode({'regionName': regionName, 'sentence': sentence, 'score': score}),
          )
          .timeout(const Duration(seconds: 5));
    } catch (_) {}
  }

  Future<List<ServerStatItem>> fetchStats() async {
    if (!AuthService().isLoggedIn) return [];
    try {
      final res = await http
          .get(Uri.parse('${ApiConfig.serverUrl}/stats'), headers: _headers)
          .timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        return list.map((e) => ServerStatItem.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<bool> deleteStats() async {
    if (!AuthService().isLoggedIn) return false;
    try {
      final res = await http
          .delete(Uri.parse('${ApiConfig.serverUrl}/stats'), headers: _headers)
          .timeout(const Duration(seconds: 5));
      return res.statusCode == 200;
    } catch (_) {}
    return false;
  }

  Future<Uint8List?> fetchTts(String text, {double speed = 1.0}) async {
    if (!AuthService().isLoggedIn) return null;
    try {
      final res = await http
          .post(
            Uri.parse('${ApiConfig.serverUrl}/tts'),
            headers: _headers,
            body: jsonEncode({'text': text, 'speed': speed}),
          )
          .timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) return res.bodyBytes;
    } catch (_) {}
    return null;
  }
}
