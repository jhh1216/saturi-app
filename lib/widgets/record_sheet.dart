import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../data/dialect_data.dart';
import '../utils/similarity.dart';
import '../utils/sound_player.dart';
import 'wave_ring.dart';

enum _State { idle, recording, done }

class RecordSheet extends StatefulWidget {
  final DialectSentence sentence;
  final String regionName;
  final Color accentColor;

  const RecordSheet({
    super.key,
    required this.sentence,
    required this.regionName,
    required this.accentColor,
  });

  @override
  State<RecordSheet> createState() => _RecordSheetState();
}

class _RecordSheetState extends State<RecordSheet> {
  final SpeechToText _speech = SpeechToText();
  _State _state = _State.idle;
  String _recognized = '';
  int _score = 0;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    final ok = await _speech.initialize(
      onError: (_) { if (mounted) setState(() => _state = _State.idle); },
    );
    if (mounted) setState(() => _ready = ok);
  }

  Future<void> _start() async {
    if (!_ready) return;
    setState(() {
      _state = _State.recording;
      _recognized = '';
    });
    await _speech.listen(
      onResult: (r) {
        if (!mounted) return;
        setState(() => _recognized = r.recognizedWords);
        if (r.finalResult) _finish();
      },
      localeId: 'ko_KR',
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
    );
  }

  void _stop() {
    _speech.stop();
    _finish();
  }

  void _finish() {
    if (_state != _State.recording) return;
    final score = SimilarityCalculator.calculate(widget.sentence.dialect, _recognized);
    setState(() {
      _score = score;
      _state = _State.done;
    });
    if (score >= 70) {
      SoundPlayer.playSuccess();
    } else {
      SoundPlayer.playFail();
    }
  }

  void _reset() => setState(() {
        _state = _State.idle;
        _recognized = '';
        _score = 0;
      });

  String get _feedback {
    if (_score >= 90) return '완벽해요! 진짜 현지인 같아요 🎉';
    if (_score >= 70) return '괜찮아요! 조금만 더 연습하면 돼요 👍';
    if (_score >= 50) return '아쉬워요. 다시 들어보고 따라해봐요 🔄';
    return '처음부터 다시 해봐요! 💪';
  }

  Color get _scoreColor {
    if (_score >= 90) return const Color(0xFF48C774);
    if (_score >= 70) return const Color(0xFFFFB347);
    if (_score >= 50) return const Color(0xFFFFD93D);
    return const Color(0xFFFF6B6B);
  }

  @override
  Widget build(BuildContext context) {
    final pastel = Color.lerp(widget.accentColor, Colors.white, 0.82)!;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 36,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들 바
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 22),

          // 지역명 칩
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: pastel.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.accentColor.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              widget.regionName,
              style: TextStyle(
                color: widget.accentColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // 사투리 문장
          Text(
            widget.sentence.dialect,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // 표준어 번역
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_forward_rounded,
                  size: 13, color: Colors.white38),
              const SizedBox(width: 4),
              Text(
                widget.sentence.standard,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          const SizedBox(height: 28),

          // 녹음 또는 결과
          if (_state == _State.done)
            _ResultSection(
              score: _score,
              recognized: _recognized,
              scoreColor: _scoreColor,
              feedback: _feedback,
              accentColor: widget.accentColor,
              pastelColor: pastel,
              onRetry: _reset,
            )
          else
            _RecordSection(
              isRecording: _state == _State.recording,
              ready: _ready,
              recognized: _recognized,
              accentColor: widget.accentColor,
              onTap: _state == _State.recording ? _stop : _start,
            ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── 녹음 섹션 ──────────────────────────────────────────────────────────────────

class _RecordSection extends StatelessWidget {
  final bool isRecording;
  final bool ready;
  final String recognized;
  final Color accentColor;
  final VoidCallback onTap;

  const _RecordSection({
    required this.isRecording,
    required this.ready,
    required this.recognized,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final btnColor = isRecording ? const Color(0xFFFF6B6B) : accentColor;
    return Column(
      children: [
        WaveRings(
          active: isRecording,
          color: accentColor,
          size: 80,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: btnColor,
                boxShadow: [
                  BoxShadow(
                    color: btnColor.withValues(alpha: 0.45),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isRecording
              ? '녹음 중... (탭하면 중지)'
              : ready
                  ? '버튼을 눌러 말해보세요'
                  : '마이크 권한이 필요해요',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isRecording && recognized.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              recognized,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}

// ── 결과 섹션 ──────────────────────────────────────────────────────────────────

class _ResultSection extends StatelessWidget {
  final int score;
  final String recognized;
  final Color scoreColor;
  final Color accentColor;
  final Color pastelColor;
  final String feedback;
  final VoidCallback onRetry;

  const _ResultSection({
    required this.score,
    required this.recognized,
    required this.scoreColor,
    required this.accentColor,
    required this.pastelColor,
    required this.feedback,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 카운트업 원형 점수
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: 0, end: score),
          duration: const Duration(milliseconds: 1400),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 136,
                height: 136,
                child: CircularProgressIndicator(
                  value: value / 100,
                  strokeWidth: 10,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation(scoreColor),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$value',
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w900,
                      color: scoreColor,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    '/100',
                    style: TextStyle(
                      color: scoreColor.withValues(alpha: 0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 인식 텍스트
        Text(
          '인식된 텍스트',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Text(
            recognized.isEmpty ? '(인식된 텍스트 없음)' : recognized,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),

        // 피드백
        Text(
          feedback,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: scoreColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 22),

        // 다시 하기 버튼
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 20),
            label: const Text('다시 해보기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}
