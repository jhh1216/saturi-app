import 'package:flutter/material.dart';
import 'data/dialect_data.dart';
import 'screens/auth_screen.dart';
import 'screens/my_page.dart';
import 'screens/quiz_page.dart';
import 'screens/region_detail_page.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';
import 'utils/stats_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService().init();
  runApp(const SaturiApp());
}

class SaturiApp extends StatelessWidget {
  const SaturiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '사투리',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/auth': (_) => const AuthScreen(),
        '/home': (_) => const RegionGridPage(),
        '/mypage': (_) => const MyPage(),
      },
    );
  }
}

// ── 메인 그리드 화면 ─────────────────────────────────────────────────────────────

class RegionGridPage extends StatefulWidget {
  const RegionGridPage({super.key});

  @override
  State<RegionGridPage> createState() => _RegionGridPageState();
}

class _RegionGridPageState extends State<RegionGridPage> {
  void _openRegion(Region region, Color color) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegionDetailPage(region: region, color: color),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🇰🇷', style: TextStyle(fontSize: 18)),
            SizedBox(width: 8),
            Text(
              '사투리',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.person_rounded, size: 26),
              color: const Color(0xFF1A1A1A),
              tooltip: '마이페이지',
              onPressed: () =>
                  Navigator.pushNamed(context, '/mypage').then((_) => setState(() {})),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFF0F0F0)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuizPage()),
        ),
        backgroundColor: const Color(0xFF1C1C2E),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Text('🎯', style: TextStyle(fontSize: 18)),
        label: const Text(
          '사투리 퀴즈',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: regions.length,
        itemBuilder: (context, i) => _RegionCard(
          region: regions[i],
          color: kRegionColors[i],
          onTap: () => _openRegion(regions[i], kRegionColors[i]),
        ),
      ),
    );
  }
}

// ── 지역 카드 ──────────────────────────────────────────────────────────────────

class _RegionCard extends StatelessWidget {
  final Region region;
  final Color color;
  final VoidCallback onTap;

  const _RegionCard({required this.region, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final pastel = Color.lerp(color, Colors.white, 0.82)!;
    final total = region.sentences.length;
    final cleared = StatsService().clearedCount(region.name);
    final practiced = StatsService().practicedCount(region.name);
    final hasProgress = practiced > 0;
    final isComplete = cleared >= total;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: pastel,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(region.emoji, style: const TextStyle(fontSize: 26)),
                  ),
                ),
                if (isComplete) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '완주 🏅',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color),
                    ),
                  ),
                ],
              ],
            ),
            const Spacer(),
            Text(
              region.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            if (hasProgress) ...[
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: cleared / total,
                        minHeight: 4,
                        backgroundColor: color.withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$cleared/$total',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
            ] else
              Text(
                '$total개 문장',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade500),
              ),
          ],
        ),
      ),
    );
  }
}
