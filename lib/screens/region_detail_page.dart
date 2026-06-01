import 'package:flutter/material.dart';
import '../data/dialect_data.dart';
import '../widgets/record_sheet.dart';

class RegionDetailPage extends StatelessWidget {
  final Region region;
  final Color color;

  const RegionDetailPage({
    super.key,
    required this.region,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pastel = Color.lerp(color, Colors.white, 0.82)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: const Color(0xFF1A1A1A),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: pastel,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(region.emoji, style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              region.name,
              style: const TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFF0F0F0)),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: region.sentences.length,
        separatorBuilder: (context, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) => _SentenceTile(
          sentence: region.sentences[index],
          index: index,
          regionName: region.name,
          accentColor: color,
          pastelColor: pastel,
        ),
      ),
    );
  }
}

class _SentenceTile extends StatelessWidget {
  final DialectSentence sentence;
  final int index;
  final String regionName;
  final Color accentColor;
  final Color pastelColor;

  const _SentenceTile({
    required this.sentence,
    required this.index,
    required this.regionName,
    required this.accentColor,
    required this.pastelColor,
  });

  void _openRecord(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecordSheet(
        sentence: sentence,
        regionName: regionName,
        accentColor: accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          // 번호 뱃지
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: pastelColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: accentColor,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 문장
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sentence.dialect,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.arrow_forward_rounded,
                        size: 12, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        sentence.standard,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // 마이크 버튼
          GestureDetector(
            onTap: () => _openRecord(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: pastelColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.mic_rounded, color: accentColor, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
