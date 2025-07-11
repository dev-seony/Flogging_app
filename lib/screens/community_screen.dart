import 'package:flutter/material.dart';
import 'package:flogging_app/screens/community_write_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int _selectedTab = 0; // 0: Rank, 1: Badge, 2: 모아보기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('Community', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TabButton(
                text: 'Rank',
                selected: _selectedTab == 0,
                onTap: () => setState(() => _selectedTab = 0),
              ),
              const SizedBox(width: 8),
              _TabButton(
                text: 'Badge',
                selected: _selectedTab == 1,
                onTap: () => setState(() => _selectedTab = 1),
              ),
              const SizedBox(width: 8),
              _TabButton(
                text: '모아보기',
                selected: _selectedTab == 2,
                onTap: () => setState(() => _selectedTab = 2),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: const [
                _RankTab(),
                _BadgeTab(),
                _FeedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton({required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _RankTab extends StatelessWidget {
  const _RankTab();
  @override
  Widget build(BuildContext context) {
    final distance = null;
    final time = null;
    final rankList = [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  label: 'Distance',
                  value: distance ?? '-',
                  sub: '현재 시각 기준',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoCard(
                  label: 'Time',
                  value: time ?? '-',
                  sub: '현재 시각 기준',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Rank', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                if (rankList.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: const [
                        Text('-', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Text('-', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                else ...List.generate(rankList.length, (i) {
                  final user = rankList[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Text('${i + 1}${_rankSuffix(i + 1)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: user['img'] != null ? NetworkImage(user['img'] as String) : null,
                          child: user['img'] == null ? const Icon(Icons.person, color: Colors.white) : null,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(user['email'] ?? '-', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _rankSuffix(int n) {
  if (n == 1) return 'st';
  if (n == 2) return 'nd';
  if (n == 3) return 'rd';
  return 'th';
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  const _InfoCard({required this.label, required this.value, required this.sub});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _BadgeTab extends StatelessWidget {
  const _BadgeTab();
  @override
  Widget build(BuildContext context) {
    final badgeList = [];
    return badgeList.isEmpty
        ? const Center(child: Text('아직 뱃지가 없습니다', style: TextStyle(color: Colors.grey, fontSize: 16)))
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: GridView.builder(
              itemCount: badgeList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 8,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, idx) {
                final badge = badgeList[idx];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: badge['img'] != null ? NetworkImage(badge['img'] as String) : null,
                      child: badge['img'] == null ? const Icon(Icons.emoji_events, color: Colors.white, size: 28) : null,
                    ),
                    const SizedBox(height: 4),
                    Text(badge['label'] ?? '', style: const TextStyle(fontSize: 11)),
                  ],
                );
              },
            ),
          );
  }
}

class _FeedTab extends StatelessWidget {
  const _FeedTab();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('community_posts').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          final feedList = snapshot.hasData ? snapshot.data!.docs : [];
          return GridView.builder(
            itemCount: 1 + feedList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, idx) {
              if (idx == 0) {
                // 내 게시글 작성 + 카드
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunityWriteScreen()));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, size: 48, color: Colors.lightGreen),
                          SizedBox(height: 8),
                          Text('글쓰기', style: TextStyle(fontSize: 16, color: Colors.lightGreen, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                final item = feedList[idx - 1].data() as Map<String, dynamic>;
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['title'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(item['content'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.black87), maxLines: 3, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
} 