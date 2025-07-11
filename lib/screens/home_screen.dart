import 'package:flutter/material.dart';
import 'plogging_diary_screen.dart';
import 'trash_camera_screen.dart';
import 'jogging_screen.dart';
import 'community_screen.dart';
import '../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeMainContent();
  }
}

class HomeMainContent extends StatelessWidget {
  const HomeMainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': Icons.menu_book, 'label': 'Plogging\nDiary'},
      {'icon': Icons.delete, 'label': 'Trash\nClassification'},
      {'icon': Icons.map, 'label': 'Jogging\nRecord'},
      {'icon': Icons.people, 'label': 'Community'},
    ];
    final gallery = [];
    final runningDiary = [];

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 16),
            // 검색창
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Search', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 오늘의 플로깅 정보 (일러스트+텍스트)
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Image.network(
                    'https://cdn.pixabay.com/photo/2017/01/31/13/14/people-2026444_1280.png',
                    width: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(Icons.directions_run, size: 100, color: Colors.grey[300]),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Today', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('3.2km  3,450 steps  3H', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // 카테고리
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Icon(Icons.chevron_right),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 110,
              child: categories.isEmpty
                  ? const Center(child: Text('카테고리가 없습니다', style: TextStyle(color: Colors.grey, fontSize: 16)))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(categories.length, (idx) {
                        final cat = categories[idx];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(32),
                            onTap: () {
                              tabIndexNotifier.value = idx + 1;
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.grey[200],
                                  child: Icon(cat['icon'] as IconData, size: 32, color: Colors.black87),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  cat['label'] as String,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
            ),
            const SizedBox(height: 24),
            // 모아보기
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('모아보기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Icon(Icons.chevron_right),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: gallery.isEmpty
                  ? const Center(child: Text('아직 기록이 없습니다', style: TextStyle(color: Colors.grey, fontSize: 16)))
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: gallery.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, idx) {
                        final item = gallery[idx];
                        return Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.network(
                                  item['img'] as String,
                                  width: 120,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 120,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['date'] as String, style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    Text('Day ${item['day']}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                    Text('${item['km']}km', style: TextStyle(fontSize: 13)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
} 