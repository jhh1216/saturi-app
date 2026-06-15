import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class TtsService {
  static final TtsService _i = TtsService._();
  factory TtsService() => _i;
  TtsService._();

  final Map<String, Uint8List> _cache = {};
  AudioPlayer? _player;
  bool _speaking = false;

  final FlutterTts _fallback = FlutterTts();
  bool _fallbackInit = false;

  bool get isSpeaking => _speaking;

  Future<void> speak(String text, {double rate = 0.85, void Function()? onDone}) async {
    if (_speaking) await stop();

    if (AuthService().isLoggedIn) {
      await _speakServer(text, slow: rate < 0.8, onDone: onDone);
    } else {
      await _speakFallback(text, rate: rate, onDone: onDone);
    }
  }

  Future<void> _speakServer(String text, {bool slow = false, void Function()? onDone}) async {
    final speed = slow ? 0.7 : 1.0;
    final cacheKey = '$text|$speed';

    Uint8List? bytes = _cache[cacheKey];

    if (bytes == null) {
      bytes = await ApiService().fetchTts(text, speed: speed);
      if (bytes != null) _cache[cacheKey] = bytes;
    }

    if (bytes == null) {
      await _speakFallback(text, rate: slow ? 0.55 : 0.85, onDone: onDone);
      return;
    }

    _speaking = true;
    _player = AudioPlayer();
    _player!.onPlayerComplete.listen((_) {
      _speaking = false;
      _player?.dispose();
      _player = null;
      onDone?.call();
    });
    await _player!.play(BytesSource(bytes));
  }

  Future<void> _speakFallback(String text, {double rate = 0.85, void Function()? onDone}) async {
    if (!_fallbackInit) {
      await _fallback.setLanguage('ko-KR');
      await _fallback.setVolume(1.0);
      await _fallback.setPitch(1.0);
      _fallbackInit = true;
    }
    _speaking = true;
    await _fallback.setSpeechRate(rate);
    _fallback.setCompletionHandler(() { _speaking = false; onDone?.call(); });
    _fallback.setCancelHandler(() { _speaking = false; onDone?.call(); });
    await _fallback.speak(text);
  }

  Future<void> stop() async {
    _speaking = false;
    await _player?.stop();
    _player?.dispose();
    _player = null;
    await _fallback.stop();
  }
}
