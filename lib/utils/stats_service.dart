import '../data/dialect_data.dart';
import '../services/api_service.dart';

class RegionStats {
  final String regionName;
  final String emoji;
  final double average;
  final int attempts;

  const RegionStats({
    required this.regionName,
    required this.emoji,
    required this.average,
    required this.attempts,
  });
}

class _Entry {
  final String emoji;
  final List<int> scores = [];
  _Entry(this.emoji);

  double get average => scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;
}

class StatsService {
  static final StatsService _i = StatsService._();
  factory StatsService() => _i;
  StatsService._();

  final Map<String, _Entry> _map = {};
  final Map<String, Set<String>> _practiced = {};
  final Map<String, Set<String>> _cleared = {};

  void record(String regionName, String sentence, int score) {
    final emoji = regions
        .firstWhere((r) => r.name == regionName, orElse: () => regions.first)
        .emoji;
    _map.putIfAbsent(regionName, () => _Entry(emoji)).scores.add(score);
    _practiced.putIfAbsent(regionName, () => {}).add(sentence);
    if (score >= 70) _cleared.putIfAbsent(regionName, () => {}).add(sentence);

    ApiService().recordScore(regionName, sentence, score);
  }

  int practicedCount(String regionName) => _practiced[regionName]?.length ?? 0;
  int clearedCount(String regionName) => _cleared[regionName]?.length ?? 0;

  List<RegionStats> get all => _map.entries
      .map((e) => RegionStats(
            regionName: e.key,
            emoji: e.value.emoji,
            average: e.value.average,
            attempts: e.value.scores.length,
          ))
      .toList()
    ..sort((a, b) => b.average.compareTo(a.average));

  int get totalAttempts => _map.values.fold(0, (s, e) => s + e.scores.length);
  int get regionCount => _map.length;

  void reset() {
    _map.clear();
    _practiced.clear();
    _cleared.clear();
  }
}
