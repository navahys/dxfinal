import 'package:flutter/material.dart';
import 'package:tiiun/services/firebase_service.dart';
import 'package:tiiun/services/openai_service.dart';
import 'package:tiiun/models/conversation_model.dart';
import 'package:tiiun/models/message_model.dart';
import 'package:tiiun/design_system/colors.dart';
import 'package:tiiun/design_system/typography.dart';

class ChatScreen extends StatefulWidget {
  final String? initialMessage;
  final String? conversationId;

  const ChatScreen({
    super.key,
    this.initialMessage,
    this.conversationId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseService _firebaseService = FirebaseService();

  String? _currentConversationId;
  bool _isLoading = false;
  bool _isTyping = false;
  ConversationModel? _conversation;

  @override
  void initState() {
    super.initState();
    _currentConversationId = widget.conversationId;

    // 초기 메시지가 있으면 자동으로 전송
    if (widget.initialMessage != null && widget.conversationId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(widget.initialMessage!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '틔운이와 대화',
          style: AppTypography.b2.withColor(AppColors.grey900),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.grey700),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _currentConversationId != null
                ? _buildMessageList()
                : _buildEmptyState(),
          ),
          if (_isTyping) _buildTypingIndicator(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<List<MessageModel>>(
      stream: _firebaseService.getMessages(_currentConversationId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
        }

        final messages = snapshot.data ?? [];

        if (messages.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return _buildMessageBubble(message);
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(MessageModel message) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.main700 : AppColors.grey100,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: AppTypography.b3.withColor(
                isUser ? Colors.white : AppColors.grey900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.formattedTime,
              style: AppTypography.c2.withColor(
                isUser ? Colors.white70 : AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '틔운이가 입력 중',
                style: AppTypography.b4.withColor(AppColors.grey600),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.grey600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.grey300,
          ),
          SizedBox(height: 16),
          Text(
            '새로운 대화를 시작해보세요!',
            style: AppTypography.b2.withColor(AppColors.grey600),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: '메시지를 입력하세요...',
                    hintStyle: AppTypography.b3.withColor(AppColors.grey500),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _sendCurrentMessage(),
                  maxLines: null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _isLoading || _isTyping ? null : _sendCurrentMessage,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _isLoading || _isTyping
                      ? AppColors.grey300
                      : AppColors.main700,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendCurrentMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _sendMessage(message);
      _messageController.clear();
    }
  }

  Future<void> _sendMessage(String message) async {
    if (_isLoading || _isTyping) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // 새 대화인 경우 생성
      if (_currentConversationId == null) {
        final conversation = await _firebaseService.createConversation();

        if (conversation == null) {
          throw Exception('대화 생성 실패');
        }

        _currentConversationId = conversation.conversationId;
        _conversation = conversation;
      }

      // 사용자 메시지 추가
      await _firebaseService.addMessage(
        conversationId: _currentConversationId!,
        content: message,
        sender: 'user',
      );

      // 타이핑 인디케이터 표시
      setState(() {
        _isTyping = true;
        _isLoading = false;
      });

      // 약간의 지연 후 AI 응답 생성
      await Future.delayed(Duration(milliseconds: 500));

      // 🔍 API 키 검증 디버깅 (메서드명 수정)
      print('🔍 디버깅 시작...');
      print('🔑 API 키 시작 부분: ${OpenAIService.getApiKeyPrefix()}');
      print('🔍 API 키 유효성: ${OpenAIService.isApiKeyValid()}');
      print('🔍 API 키 길이: ${OpenAIService.getApiKeyLength()}');

      String aiResponse;
      if (OpenAIService.isApiKeyValid()) {
        print('✅ API 키 유효 - OpenAI 호출 시작');

        try {
          aiResponse = await OpenAIService.getChatResponse(
            message: message,
            conversationType: 'normal',
          );
          print('✅ OpenAI API 응답 받음: ${aiResponse.substring(0, aiResponse.length > 50 ? 50 : aiResponse.length)}...');
        } catch (e) {
          print('❌ OpenAI API 에러: $e');
          aiResponse = '죄송해요, AI 응답 생성 중 오류가 발생했어요. 다시 시도해주세요! 🤖';
        }
      } else {
        print('❌ API 키 무효 - 폴백 응답 사용');
        aiResponse = _generateFallbackResponse(message);
      }

      // AI 응답 저장
      await _firebaseService.addMessage(
        conversationId: _currentConversationId!,
        content: aiResponse,
        sender: 'ai',
      );

      // 스크롤을 맨 아래로
      _scrollToBottom();

    } catch (e) {
      print('메시지 전송 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('메시지 전송 중 오류가 발생했습니다'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _isTyping = false;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // OpenAI API 실패 시 대체 응답
  String _generateFallbackResponse(String message) {
    // 간단한 키워드 기반 응답
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('안녕') || lowerMessage.contains('hi') || lowerMessage.contains('hello')) {
      return '안녕하세요! 😊 오늘 하루는 어떠셨나요?';
    } else if (lowerMessage.contains('고마') || lowerMessage.contains('감사')) {
      return '천만에요! 언제든지 도와드릴게요 😄';
    } else if (lowerMessage.contains('힘들') || lowerMessage.contains('우울') || lowerMessage.contains('슬프')) {
      return '힘든 시간을 보내고 계시는군요. 괜찮아요, 저가 여기 있어요 🤗';
    } else if (lowerMessage.contains('좋') || lowerMessage.contains('기쁘') || lowerMessage.contains('행복')) {
      return '정말 좋은 소식이네요! 😄 더 자세히 얘기해주세요!';
    } else if (lowerMessage.contains('?') || lowerMessage.contains('궁금')) {
      return '궁금한 게 있으시군요! 🤔 제가 아는 선에서 도움을 드릴게요.';
    } else {
      return '흥미로운 이야기네요! 😊 더 자세히 들려주세요.';
    }
  }
}