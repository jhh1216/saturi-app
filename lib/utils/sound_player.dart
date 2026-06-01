import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  // 사인파 WAV 생성 (여러 주파수 합성)
  static Uint8List _generateWav(
    List<double> freqs,
    double duration, {
    int sampleRate = 22050,
  }) {
    final n = (sampleRate * duration).round();
    final samples = Int16List(n);
    for (int i = 0; i < n; i++) {
      final t = i / sampleRate;
      final fadeIn = duration * 0.05;
      final fadeOut = duration * 0.25;
      final env = t < fadeIn
          ? t / fadeIn
          : t > duration - fadeOut
              ? (duration - t) / fadeOut
              : 1.0;
      var wave = 0.0;
      for (final f in freqs) {
        wave += sin(2 * pi * f * t);
      }
      samples[i] = (env * (wave / freqs.length) * 11000).round().clamp(-32768, 32767);
    }
    return _buildWavHeader(samples, sampleRate);
  }

  static Uint8List _buildWavHeader(Int16List samples, int rate) {
    const ch = 1, bps = 16;
    final byteRate = rate * ch * bps ~/ 8;
    const align = ch * bps ~/ 8;
    final dataSize = samples.length * align;
    final buf = ByteData(44 + dataSize);
    void str(int o, String s) {
      for (int i = 0; i < s.length; i++) {
        buf.setUint8(o + i, s.codeUnitAt(i));
      }
    }
    str(0, 'RIFF');
    buf.setUint32(4, 36 + dataSize, Endian.little);
    str(8, 'WAVE');
    str(12, 'fmt ');
    buf.setUint32(16, 16, Endian.little);
    buf.setUint16(20, 1, Endian.little);
    buf.setUint16(22, ch, Endian.little);
    buf.setUint32(24, rate, Endian.little);
    buf.setUint32(28, byteRate, Endian.little);
    buf.setUint16(32, align, Endian.little);
    buf.setUint16(34, bps, Endian.little);
    str(36, 'data');
    buf.setUint32(40, dataSize, Endian.little);
    for (int i = 0; i < samples.length; i++) {
      buf.setInt16(44 + i * 2, samples[i], Endian.little);
    }
    return buf.buffer.asUint8List();
  }

  static Future<void> _play(Uint8List wav) async {
    try {
      final player = AudioPlayer();
      player.onPlayerComplete.listen((_) => player.dispose());
      await player.play(BytesSource(wav));
    } catch (_) {}
  }

  /// C-E-G 장화음: 밝고 기분 좋은 성공음
  static Future<void> playSuccess() =>
      _play(_generateWav([523.25, 659.25, 783.99], 0.8));

  /// 낮은 단음: 아쉬운 실패음
  static Future<void> playFail() =>
      _play(_generateWav([220.0, 246.94], 0.65));
}
