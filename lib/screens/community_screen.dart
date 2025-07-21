import 'package:flutter/material.dart';
import 'package:flogging_app/screens/community_write_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/jog_record.dart';

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
  
  // 조깅에 도움이 되는 팁 데이터 (줄임)
  final List<Map<String, dynamic>> _joggingTips = const [
    {
      'title': '🏃‍♂️ 조깅 시작하기',
      'content': '처음 조깅을 시작하는 분들을 위한 기본 가이드',
      'type': 'video',
      'thumbnail': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
      'videoUrl': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      'duration': '5분',
      'category': 'beginner'
    },
    {
      'title': '💪 올바른 자세',
      'content': '조깅할 때 올바른 자세와 호흡법',
      'type': 'video',
      'thumbnail': 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=400&h=300&fit=crop',
      'videoUrl': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      'duration': '3분',
      'category': 'technique'
    },
    {
      'title': '🎵 조깅 플레이리스트',
      'content': '조깅할 때 듣기 좋은 음악 추천',
      'type': 'playlist',
      'thumbnail': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop',
      'videoUrl': 'https://open.spotify.com/playlist/37i9dQZF1DX8NTLI2TtZa6',
      'duration': '60분',
      'category': 'motivation'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // 조깅 팁 섹션
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.orange[600], size: 24),
                const SizedBox(width: 8),
                Text(
                  '조깅 팁',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[600],
                  ),
                ),
              ],
            ),
          ),
          // 조깅 팁 가로 스크롤
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _joggingTips.length,
              itemBuilder: (context, idx) {
                final tip = _joggingTips[idx];
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 16),
                  child: _JoggingTipCard(tip: tip),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          // 모든 조깅 기록 섹션
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.history, color: Colors.green[600], size: 24),
                const SizedBox(width: 8),
                Text(
                  '모든 조깅 기록',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
          ),
          // 조깅 기록 목록
          Expanded(
            child: _JoggingHistoryList(),
          ),
        ],
      ),
    );
  }
}

class _JoggingHistoryList extends StatelessWidget {
  const _JoggingHistoryList();

  String _formatDuration(int seconds) {
    if (seconds == 0) return '0분';
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}시간 ${minutes}분';
    } else {
      return '${minutes}분';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<JogRecord>('jog_records').listenable(),
      builder: (context, Box<JogRecord> box, _) {
        final records = box.values.toList().reversed.toList();
        
        if (records.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_run,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  '아직 조깅 기록이 없습니다',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '조깅을 시작하여 기록을 남겨보세요!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // 날짜 표시
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _formatDate(record.date).split('.')[1], // 월
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _formatDate(record.date).split('.')[2], // 일
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 기록 정보
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.directions_run,
                                size: 16,
                                color: Colors.green[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '조깅 기록',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildInfoItem('거리', '${record.distanceKm.toStringAsFixed(1)}km'),
                              const SizedBox(width: 16),
                              _buildInfoItem('시간', _formatDuration(record.durationSeconds)),
                              const SizedBox(width: 16),
                              _buildInfoItem('속도', '${record.speedKmph.toStringAsFixed(1)}km/h'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // 공유 버튼
                    IconButton(
                      onPressed: () {
                        // 공유 기능 (share_plus 패키지 필요)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${_formatDate(record.date)} 조깅 기록을 공유합니다'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.share,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _JoggingTipCard extends StatelessWidget {
  final Map<String, dynamic> tip;
  
  const _JoggingTipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showTipDetail(context, tip);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 썸네일 이미지
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Stack(
                  children: [
                    Image.network(
                      tip['thumbnail'],
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(
                            tip['type'] == 'video' ? Icons.play_circle : Icons.article,
                            size: 48,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                    // 타입 아이콘
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              tip['type'] == 'video' ? Icons.play_arrow : 
                              tip['type'] == 'playlist' ? Icons.music_note : Icons.article,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              tip['duration'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 내용
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip['content'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTipDetail(BuildContext context, Map<String, dynamic> tip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TipDetailSheet(tip: tip),
    );
  }
}

class _TipDetailSheet extends StatelessWidget {
  final Map<String, dynamic> tip;
  
  const _TipDetailSheet({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 핸들바
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 헤더
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  tip['type'] == 'video' ? Icons.play_circle : 
                  tip['type'] == 'playlist' ? Icons.music_note : Icons.article,
                  color: Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  tip['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // 썸네일
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                tip['thumbnail'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      tip['type'] == 'video' ? Icons.play_circle : Icons.article,
                      size: 64,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),
          ),
          // 내용
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip['content'],
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (tip['videoUrl'].isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // URL 열기 로직 (url_launcher 패키지 필요)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${tip['title']} 링크를 열려고 합니다'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        icon: Icon(
                          tip['type'] == 'video' ? Icons.play_arrow : 
                          tip['type'] == 'playlist' ? Icons.music_note : Icons.open_in_new,
                        ),
                        label: Text(
                          tip['type'] == 'video' ? '영상 보기' : 
                          tip['type'] == 'playlist' ? '플레이리스트 듣기' : '자세히 보기',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 