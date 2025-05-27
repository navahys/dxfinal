import 'package:flutter/material.dart';
import '../design_system/colors.dart';
import '../pages/chatting_page.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Uuid _uuid = const Uuid();
  final TextEditingController _chatController = TextEditingController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_chatController.text.trim().isNotEmpty) {
      final newConversationId = _uuid.v4();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatConversationScreen(
            conversationId: newConversationId,
            title: '틔운이와 채팅',
            initialMessage: _chatController.text.trim(),
          ),
        ),
      );
      _chatController.clear();
    }
  }

  void _handleQuickAction(String action) {
    final newConversationId = _uuid.v4();
    String initialMessage = '';

    switch (action) {
      case '이전 대화':
        Navigator.pushNamed(context, '/conversation-list');
        return;
      case '자랑거리':
        initialMessage = '오늘 있었던 자랑하고 싶은 일이 있어요';
        break;
      case '고민거리':
        initialMessage = '고민이 있어서 상담받고 싶어요';
        break;
      case '위로가 필요해':
        initialMessage = '힘든 일이 있어서 위로받고 싶어요';
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatConversationScreen(
          conversationId: newConversationId,
          title: '틔운이와 채팅',
          initialMessage: initialMessage,
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: IconButton(
            onPressed: () => _handleQuickAction(title),
            icon: Icon(
              icon,
              color: Colors.grey.shade400,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTipCard(String title, String imageUrl) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              gradient: LinearGradient(
                colors: [Colors.green.shade300, Colors.green.shade500],
              ),
            ),
            child: Icon(
              Icons.local_florist,
              color: Colors.white,
              size: 40,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 상단 영역 - 알림 아이콘
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40), // 왼쪽 여백
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: Colors.grey.shade700,
                        size: 28,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('알림 기능은 곧 추가될 예정입니다')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 메인 비주얼 - 중앙 식물 아이콘
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.eco,
                  size: 60,
                  color: Colors.green.shade600,
                ),
              ),

              const SizedBox(height: 40),

              // 입력 필드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: const Color(0xFF00C853)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _chatController,
                          decoration: const InputDecoration(
                            hintText: '무엇이든 이야기하세요',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                          onSubmitted: (value) => _sendMessage(),
                        ),
                      ),
                      IconButton(
                        onPressed: _sendMessage,
                        icon: const Icon(
                          Icons.send,
                          color: Color(0xFF00C853),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // 빠른 기능 버튼들
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickActionButton('이전 대화', Icons.history),
                    _buildQuickActionButton('자랑거리', Icons.celebration),
                    _buildQuickActionButton('고민거리', Icons.help_outline),
                    _buildQuickActionButton('위로가 필요해', Icons.favorite_border),
                  ],
                ),
              ),

              const SizedBox(height: 45),

              // 환경 정보 카드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.thermostat, color: Colors.orange.shade600, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              '적정 온도',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.wb_sunny, color: Colors.yellow.shade600, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              '조명 밝기 낮음',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.warning, color: Colors.orange.shade600, size: 20),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 콘텐츠 섹션 - 겨울철 식물 관리 팁
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '겨울철 식물 관리 팁',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '🌨️',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTipCard(
                            '겨울철 물주기, 깍지벌레 관리 팁',
                            'https://via.placeholder.com/150x100/4CAF50/FFFFFF?text=Plant1',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTipCard(
                            '겨울 걱정 NO! 겨울철 식물 이사 고민 줄여요',
                            'https://via.placeholder.com/150x100/8BC34A/FFFFFF?text=Plant2',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}