import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 임시 데이터
    final double totalDistance = 42.5; // km
    final int totalMinutes = 320; // 분
    final int totalTrash = 87; // 개
    final double todayDistance = 3.2;
    final int todayMinutes = 25;
    final int todayTrash = 7;
    final String recentBadge = '플로깅 스타터';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.green[100],
                        child: Icon(Icons.person, size: 36, color: Colors.green[700]),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('선영님', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('오늘도 플로깅 화이팅!', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('누적 플로깅 정보', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _InfoColumn(icon: Icons.directions_run, label: '총 거리', value: '${totalDistance.toStringAsFixed(1)}km'),
                      _InfoColumn(icon: Icons.timer, label: '총 시간', value: '${(totalMinutes ~/ 60)}h ${(totalMinutes % 60)}m'),
                      _InfoColumn(icon: Icons.delete, label: '총 쓰레기', value: '$totalTrash개'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('오늘의 플로깅', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _InfoColumn(icon: Icons.directions_run, label: '거리', value: '${todayDistance.toStringAsFixed(1)}km'),
                      _InfoColumn(icon: Icons.timer, label: '시간', value: '${todayMinutes}분'),
                      _InfoColumn(icon: Icons.delete, label: '쓰레기', value: '$todayTrash개'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.amber[700], size: 32),
                  const SizedBox(width: 16),
                  Text('최근 획득 뱃지: $recentBadge', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoColumn({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.green[700]),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }
} 