import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class AuthUser {
  final int id;
  final String email;
  final String nickname;

  const AuthUser({required this.id, required this.email, required this.nickname});

  factory AuthUser.fromJson(Map<String, dynamic> j) => AuthUser(
        id: j['id'] as int,
        email: j['email'] as String,
        nickname: (j['nickname'] as String?) ?? j['email'] as String,
      );
}

class AuthService {
  static final AuthService _i = AuthService._();
  factory AuthService() => _i;
  AuthService._();

  static const _tokenKey = 'auth_token';

  String? _token;
  AuthUser? _user;

  String? get token => _token;
  AuthUser? get user => _user;
  bool get isLoggedIn => _token != null;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
  }

  Future<AuthUser> login(String email, String password) async {
    final res = await http
        .post(
          Uri.parse('${ApiConfig.serverUrl}/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(const Duration(seconds: 10));

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200) throw data['error'] ?? '로그인 실패';

    await _saveToken(data['token'] as String);
    _user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
    return _user!;
  }

  Future<AuthUser> signup(String email, String password, String nickname) async {
    final res = await http
        .post(
          Uri.parse('${ApiConfig.serverUrl}/auth/signup'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password, 'nickname': nickname}),
        )
        .timeout(const Duration(seconds: 10));

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200 && res.statusCode != 201) throw data['error'] ?? '회원가입 실패';

    await _saveToken(data['token'] as String);
    _user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
    return _user!;
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
}
