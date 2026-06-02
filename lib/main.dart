import 'package:flutter/material.dart';
import 'data/dialect_data.dart';
import 'screens/region_detail_page.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
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
        '/home': (_) => const RegionGridPage(),
      },
    );
  }
}

// ── 메인 그리드 화면 ─────────────────────────────────────────────────────────────

class RegionGridPage extends StatelessWidget {
  const RegionGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFF0F0F0),
          ),
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
        ),
      ),
    );
  }
}

// ── 지역 카드 ──────────────────────────────────────────────────────────────────

class _RegionCard extends StatelessWidget {
  final Region region;
  final Color color;

  const _RegionCard({required this.region, required this.color});

  @override
  Widget build(BuildContext context) {
    final pastel = Color.lerp(color, Colors.white, 0.82)!;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegionDetailPage(region: region, color: color),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: pastel,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이모지 아이콘
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  region.emoji,
                  style: const TextStyle(fontSize: 26),
                ),
              ),
            ),
            const Spacer(),
            // 지역명
            Text(
              region.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 3),
            // 문장 수
            Text(
              '${region.sentences.length}개 문장',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
