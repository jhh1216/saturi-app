import 'package:flutter/material.dart';
import '../data/dialect_data.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../utils/app_settings.dart';
import '../utils/stats_service.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool _soundEnabled = AppSettings().soundEnabled;
  bool _loadingStats = true;
  List<_StatItem> _stats = [];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    if (AuthService().isLoggedIn) {
      final serverStats = await ApiService().fetchStats();
      if (mounted) {
        setState(() {
          _stats = serverStats.map((s) => _StatItem(
            regionName: s.regionName,
            emoji: _emojiFor(s.regionName),
            average: s.average,
            attempts: s.attempts,
          )).toList();
          _loadingStats = false;
        });
      }
    } else {
      final local = StatsService().all;
      if (mounted) {
        setState(() {
          _stats = local.map((s) => _StatItem(
            regionName: s.regionName,
            emoji: s.emoji,
            average: s.average,
            attempts: s.attempts,
          )).toList();
          _loadingStats = false;
        });
      }
    }
  }

  String _emojiFor(String name) {
    return regions.firstWhere((r) => r.name == name, orElse: () => regions.first).emoji;
  }

  void _toggleSound(bool val) {
    setState(() {
      _soundEnabled = val;
      AppSettings().soundEnabled = val;
    });
  }

  void _confirmReset() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('기록 초기화', style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text('모든 연습 기록이 삭제됩니다.\n정말 초기화하시겠어요?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('취소')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('초기화', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed == true && mounted) {
        await ApiService().deleteStats();
        StatsService().reset();
        if (mounted) setState(() => _stats = []);
      }
    });
  }

  void _confirmLogout() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('로그아웃', style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text('로그아웃 하시겠어요?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('취소')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('로그아웃', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed == true && mounted) {
        await AuthService().logout();
        StatsService().reset();
        if (mounted) Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
      }
    });
  }

  Color _colorFor(String regionName) {
    final idx = regions.indexWhere((r) => r.name == regionName);
    return idx >= 0 ? kRegionColors[idx] : kRegionColors[0];
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().user;
    final total = _stats.fold(0, (s, e) => s + e.attempts);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: const Color(0xFF1A1A1A),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '마이페이지',
          style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 18, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 22),
            color: Colors.grey.shade600,
            tooltip: '로그아웃',
            onPressed: _confirmLogout,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFF0F0F0)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        children: [
          _ProfileHeader(
            nickname: user?.nickname ?? '사투리 여행자',
            email: user?.email,
            total: total,
            regionCount: _stats.length,
          ),
          const SizedBox(height: 24),

          _SectionLabel(
            label: '연습 현황',
            trailing: _stats.isEmpty ? null : '${_stats.length}개 지역',
          ),
          const SizedBox(height: 12),
          if (_loadingStats)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            )
          else if (_stats.isEmpty)
            const _EmptyStats()
          else
            ..._stats.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _RegionStatCard(item: s, color: _colorFor(s.regionName)),
                )),

          const SizedBox(height: 24),
          const _SectionLabel(label: '설정'),
          const SizedBox(height: 12),
          _SettingsCard(
            soundEnabled: _soundEnabled,
            onSoundToggle: _toggleSound,
            onReset: _confirmReset,
          ),
        ],
      ),
    );
  }
}

// ── 내부 데이터 모델 ──────────────────────────────────────────────────────────

class _StatItem {
  final String regionName;
  final String emoji;
  final double average;
  final int attempts;

  const _StatItem({
    required this.regionName,
    required this.emoji,
    required this.average,
    required this.attempts,
  });
}

// ── 프로필 헤더 ──────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final String nickname;
  final String? email;
  final int total;
  final int regionCount;

  const _ProfileHeader({
    required this.nickname,
    this.email,
    required this.total,
    required this.regionCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B8DEF), Color(0xFF3DB4E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5B8DEF).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(child: Text('🗣️', style: TextStyle(fontSize: 34))),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nickname,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (email != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    email!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  total == 0 ? '아직 연습을 시작하지 않았어요' : '총 $total번 연습  ·  $regionCount개 지역',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 섹션 레이블 ────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final String? trailing;

  const _SectionLabel({required this.label, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A))),
        if (trailing != null)
          Text(trailing!,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
      ],
    );
  }
}

// ── 빈 기록 ────────────────────────────────────────────────────────────────────

class _EmptyStats extends StatelessWidget {
  const _EmptyStats();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          const Text('🗣️', style: TextStyle(fontSize: 44)),
          const SizedBox(height: 14),
          const Text('아직 연습 기록이 없어요',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 4),
          Text('지금 사투리 연습을 시작해보세요!',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}

// ── 지역 통계 카드 ─────────────────────────────────────────────────────────────

class _RegionStatCard extends StatelessWidget {
  final _StatItem item;
  final Color color;

  const _RegionStatCard({required this.item, required this.color});

  String get _grade {
    if (item.average >= 90) return '달인';
    if (item.average >= 70) return '능숙';
    if (item.average >= 50) return '초보';
    return '입문';
  }

  @override
  Widget build(BuildContext context) {
    final pastel = Color.lerp(color, Colors.white, 0.85)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(color: pastel, shape: BoxShape.circle),
                child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 19))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.regionName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A))),
                    Text('${item.attempts}번 연습',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_grade,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: item.average / 100),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (_, val, __) => LinearProgressIndicator(
                      value: val,
                      minHeight: 10,
                      backgroundColor: color.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 42,
                child: Text('${item.average.round()}%',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color),
                    textAlign: TextAlign.right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── 설정 카드 ──────────────────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  final bool soundEnabled;
  final ValueChanged<bool> onSoundToggle;
  final VoidCallback onReset;

  const _SettingsCard({
    required this.soundEnabled,
    required this.onSoundToggle,
    required this.onReset,
  });

  Widget _iconBox(Color bg, Color fg, IconData icon) => Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: fg, size: 20),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8F9FA),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          SwitchListTile(
            value: soundEnabled,
            onChanged: onSoundToggle,
            activeColor: const Color(0xFF5B8DEF),
            secondary: _iconBox(
              const Color(0xFF5B8DEF).withValues(alpha: 0.1),
              const Color(0xFF5B8DEF),
              Icons.volume_up_rounded,
            ),
            title: const Text('효과음', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            subtitle: Text('정답/오답 효과음', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ),
          Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey.shade200),
          ListTile(
            onTap: onReset,
            leading: _iconBox(Colors.red.withValues(alpha: 0.1), Colors.red, Icons.delete_outline_rounded),
            title: const Text('연습 기록 초기화',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.red)),
            subtitle: Text('모든 연습 기록을 삭제해요',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            trailing: const Icon(Icons.chevron_right_rounded, color: Colors.red, size: 20),
          ),
          Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey.shade200),
          ListTile(
            leading: _iconBox(Colors.grey.withValues(alpha: 0.12), Colors.grey.shade600, Icons.info_outline_rounded),
            title: const Text('앱 버전', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            trailing: Text('v1.0.0',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
          ),
        ],
      ),
    );
  }
}
