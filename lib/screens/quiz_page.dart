import 'dart:math';
import 'package:flutter/material.dart';
import '../data/dialect_data.dart';
import '../theme/app_theme.dart';
import '../utils/tts_service.dart';

const int _kQuestionCount = 10;

class _Question {
  final DialectSentence sentence;
  final int correctIdx;
  final List<int> choices;

  const _Question({
    required this.sentence,
    required this.correctIdx,
    required this.choices,
  });
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<_Question> _questions;
  int _current = 0;
  int? _selected;
  int _correct = 0;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _questions = _buildQuestions();
  }

  List<_Question> _buildQuestions() {
    final rng = Random();
    final allPairs = <(int, DialectSentence)>[];
    for (int i = 0; i < regions.length; i++) {
      for (final s in regions[i].sentences) {
        allPairs.add((i, s));
      }
    }
    allPairs.shuffle(rng);

    return List.generate(
      _kQuestionCount.clamp(0, allPairs.length),
      (q) {
        final (regionIdx, sentence) = allPairs[q];
        final wrong = (List.generate(regions.length, (i) => i)..remove(regionIdx)..shuffle(rng)).take(3).toList();
        final choices = [regionIdx, ...wrong]..shuffle(rng);
        return _Question(sentence: sentence, correctIdx: regionIdx, choices: choices);
      },
    );
  }

  void _pick(int regionIdx) {
    if (_selected != null) return;
    setState(() {
      _selected = regionIdx;
      if (regionIdx == _questions[_current].correctIdx) _correct++;
    });
  }

  void _next() {
    if (_current + 1 >= _questions.length) {
      setState(() => _done = true);
    } else {
      setState(() {
        _current++;
        _selected = null;
      });
    }
  }

  void _restart() {
    setState(() {
      _questions = _buildQuestions();
      _current = 0;
      _selected = null;
      _correct = 0;
      _done = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C2E),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '🎯  사투리 퀴즈',
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
        ),
      ),
      body: _done ? _buildDone() : _buildQuestion(),
    );
  }

  // ── 문제 화면 ─────────────────────────────────────────────────────────────────

  Widget _buildQuestion() {
    final q = _questions[_current];
    final total = _questions.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 진행 바
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _current / total,
                    minHeight: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF5B8DEF)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${_current + 1} / $total',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '맞춘 문제: $_correct',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 28),

          // 문제 카드
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                Text(
                  '이 사투리, 어느 지역일까요?',
                  style: TextStyle(
                    color: const Color(0xFF5B8DEF),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        q.sentence.dialect,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          height: 1.35,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _TtsButton(text: q.sentence.dialect),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_forward_rounded,
                        size: 13, color: Colors.white.withValues(alpha: 0.28)),
                    const SizedBox(width: 4),
                    Text(
                      q.sentence.standard,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.38),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // 선택지 2x2
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.6,
            children: q.choices.map((ri) => _choiceBtn(ri, q)).toList(),
          ),

          if (_selected != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B8DEF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  _current + 1 >= _questions.length ? '결과 보기' : '다음 문제',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _choiceBtn(int regionIdx, _Question q) {
    final region = regions[regionIdx];
    final isCorrect = regionIdx == q.correctIdx;
    final isSelected = regionIdx == _selected;
    final revealed = _selected != null;

    Color bgColor = Colors.white.withValues(alpha: 0.05);
    Color borderColor = Colors.white.withValues(alpha: 0.15);
    Color textColor = Colors.white.withValues(alpha: 0.88);

    if (revealed) {
      if (isCorrect) {
        bgColor = const Color(0xFF48C774).withValues(alpha: 0.18);
        borderColor = const Color(0xFF48C774);
        textColor = const Color(0xFF48C774);
      } else if (isSelected) {
        bgColor = const Color(0xFFFF6B6B).withValues(alpha: 0.18);
        borderColor = const Color(0xFFFF6B6B);
        textColor = const Color(0xFFFF6B6B);
      }
    }

    return GestureDetector(
      onTap: revealed ? null : () => _pick(regionIdx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(region.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                region.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (revealed && isCorrect) ...[
              const SizedBox(width: 4),
              Icon(Icons.check_circle_rounded,
                  size: 16, color: const Color(0xFF48C774)),
            ],
            if (revealed && isSelected && !isCorrect) ...[
              const SizedBox(width: 4),
              Icon(Icons.cancel_rounded,
                  size: 16, color: const Color(0xFFFF6B6B)),
            ],
          ],
        ),
      ),
    );
  }

  // ── 완료 화면 ─────────────────────────────────────────────────────────────────

  Widget _buildDone() {
    final total = _questions.length;
    final pct = (_correct / total * 100).round();
    final Color color = pct >= 80
        ? const Color(0xFF48C774)
        : pct >= 50
            ? const Color(0xFFFFB347)
            : const Color(0xFFFF6B6B);
    final String msg = pct >= 90
        ? '사투리 마스터! 🏆'
        : pct >= 70
            ? '꽤 잘 알고 있어요! 👍'
            : pct >= 50
                ? '더 연습해봐요 🔄'
                : '사투리 공부 시작! 💪';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Column(
        children: [
          const Spacer(),
          Text(
            '퀴즈 완료!',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 32),

          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: _correct),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            builder: (_, val, __) => Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: val / total,
                    strokeWidth: 12,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$val',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: color,
                        height: 1,
                      ),
                    ),
                    Text(
                      '/ $total',
                      style: TextStyle(
                        color: color.withValues(alpha: 0.6),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          Text(
            msg,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            '정답률 $pct%',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _restart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B8DEF),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('다시 도전',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '돌아가기',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── TTS 버튼 ──────────────────────────────────────────────────────────────────

class _TtsButton extends StatefulWidget {
  final String text;
  const _TtsButton({required this.text});

  @override
  State<_TtsButton> createState() => _TtsButtonState();
}

class _TtsButtonState extends State<_TtsButton> {
  bool _playing = false;

  @override
  void dispose() {
    TtsService().stop();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_playing) {
      await TtsService().stop();
      if (mounted) setState(() => _playing = false);
    } else {
      if (mounted) setState(() => _playing = true);
      await TtsService().speak(
        widget.text,
        onDone: () {
          if (mounted) setState(() => _playing = false);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _playing
              ? const Color(0xFF5B8DEF).withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: _playing
                ? const Color(0xFF5B8DEF).withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(
          _playing ? Icons.stop_rounded : Icons.volume_up_rounded,
          color: _playing ? const Color(0xFF5B8DEF) : Colors.white.withValues(alpha: 0.7),
          size: 20,
        ),
      ),
    );
  }
}
