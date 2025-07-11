import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flogging_app/screens/plogging_diary_write_screen.dart';

class PloggingDiaryScreen extends StatelessWidget {
  const PloggingDiaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('Plogging Diary', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('plogging_diary').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('아직 기록이 없습니다', style: TextStyle(color: Colors.grey, fontSize: 16)));
          }
          final diaryList = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: diaryList.length,
            itemBuilder: (context, idx) {
              final item = diaryList[idx].data() as Map<String, dynamic>;
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(item['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.lightGreen[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(item['distance'] ?? '', style: const TextStyle(fontSize: 13, color: Colors.green)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // TODO: 사진 미리보기
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _Info(label: '거리', value: item['distance'] ?? '-'),
                          _Info(label: '시간', value: item['time'] ?? '-'),
                          _Info(label: '스텝', value: item['steps'] ?? '-'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          color: Colors.grey[200],
                          child: const Center(child: Text('지도 미리보기', style: TextStyle(color: Colors.grey))),
                        ),
                      ),
                      if ((item['memo'] ?? '').isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(item['memo'], style: const TextStyle(fontSize: 14, color: Colors.black87)),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PloggingDiaryWriteScreen()));
        },
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: '새 플로깅 기록 추가',
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String label;
  final String value;
  const _Info({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }
} 