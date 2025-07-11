import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController _postController = TextEditingController();
  final List<Map<String, dynamic>> _posts = [];

  void _addPost() {
    final text = _postController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _posts.insert(0, {
          'content': text,
          'comments': <String>[]
        });
        _postController.clear();
      });
    }
  }

  void _addComment(int postIndex, String comment) {
    if (comment.trim().isEmpty) return;
    setState(() {
      _posts[postIndex]['comments'].add(comment.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _postController,
                      decoration: const InputDecoration(
                        hintText: '글을 작성해보세요!',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _addPost(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.green),
                    onPressed: _addPost,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _posts.isEmpty
                ? const Center(child: Text('아직 작성된 글이 없습니다.'))
                : ListView.builder(
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post['content'], style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 10),
                              Divider(),
                              ...List.generate(post['comments'].length, (cIdx) =>
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.comment, size: 16, color: Colors.grey),
                                      const SizedBox(width: 6),
                                      Expanded(child: Text(post['comments'][cIdx], style: const TextStyle(fontSize: 14, color: Colors.black87))),
                                    ],
                                  ),
                                ),
                              ),
                              _CommentInput(
                                onSubmit: (comment) => _addComment(index, comment),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CommentInput extends StatefulWidget {
  final void Function(String) onSubmit;
  const _CommentInput({required this.onSubmit});

  @override
  State<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<_CommentInput> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmit(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: '댓글을 입력하세요',
              border: InputBorder.none,
            ),
            onSubmitted: (_) => _submit(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send, size: 20, color: Colors.green),
          onPressed: _submit,
        ),
      ],
    );
  }
} 