import 'package:flutter/material.dart';

/// 마이크 주변 파동(ripple) 애니메이션
class WaveRings extends StatefulWidget {
  final bool active;
  final Color color;
  final double size;
  final Widget child;

  const WaveRings({
    super.key,
    required this.active,
    required this.color,
    required this.size,
    required this.child,
  });

  @override
  State<WaveRings> createState() => _WaveRingsState();
}

class _WaveRingsState extends State<WaveRings> with TickerProviderStateMixin {
  static const _count = 3;
  late final List<AnimationController> _ctrls;
  late final List<Animation<double>> _scaleAnim;
  late final List<Animation<double>> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(
      _count,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1700),
      ),
    );
    _scaleAnim = _ctrls
        .map((c) => Tween<double>(begin: 1.0, end: 2.3).animate(
              CurvedAnimation(parent: c, curve: Curves.easeOut),
            ))
        .toList();
    _fadeAnim = _ctrls
        .map((c) => Tween<double>(begin: 0.65, end: 0.0).animate(
              CurvedAnimation(parent: c, curve: Curves.easeOut),
            ))
        .toList();

    if (widget.active) _startAll();
  }

  void _startAll() {
    for (int i = 0; i < _count; i++) {
      Future.delayed(Duration(milliseconds: i * 520), () {
        if (mounted) _ctrls[i].repeat();
      });
    }
  }

  void _stopAll() {
    for (final c in _ctrls) {
      c.stop();
      c.reset();
    }
  }

  @override
  void didUpdateWidget(WaveRings old) {
    super.didUpdateWidget(old);
    if (widget.active != old.active) {
      widget.active ? _startAll() : _stopAll();
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final outer = widget.size * 2.7;
    return SizedBox(
      width: outer,
      height: outer,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int i = 0; i < _count; i++)
            AnimatedBuilder(
              animation: _ctrls[i],
              builder: (context, _) => Opacity(
                opacity: widget.active ? _fadeAnim[i].value : 0.0,
                child: Transform.scale(
                  scale: _scaleAnim[i].value,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: widget.color, width: 2.5),
                    ),
                  ),
                ),
              ),
            ),
          widget.child,
        ],
      ),
    );
  }
}
