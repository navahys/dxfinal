import 'package:flutter/material.dart';
import '../pages/chatting_page.dart';
import '../design_system/colors.dart';
import '../design_system/typography.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();

  void _goToChatScreen() {
    if (_textController.text.trim().isNotEmpty) {
      String message = _textController.text.trim();
      _textController.clear();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            initialMessage: message,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose(); // 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F2),
      body: SafeArea(
        child: Column(
          children: [
            // 알림 아이콘
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset('assets/icons/functions/notification_off_icon.png', width: 24, height: 24,),
                ],
              ),
            ),
            SizedBox(height: 95,),
            Container(
              child: Image.asset('assets/images/tiiun_logo.png', width: 80, height: 40,),
            ),
            SizedBox(height: 95,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.all(1.5), // 테두리 두께
              width: double.maxFinite,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF72ED98),
                    Color(0xFF10BCBE),
                  ],
                  stops: [0.4, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF10BEBE).withOpacity(0.2),
                    spreadRadius: -4,
                    blurRadius: 16,
                    offset: Offset(0, 4)
                  )
                ],
                borderRadius: BorderRadius.circular(60),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 21),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(57),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        onSubmitted: (value) => _goToChatScreen(),
                        decoration: InputDecoration(
                          hintText: '무엇이든 이야기하세요',
                          hintStyle: AppTypography.b4.copyWith(color: AppColors.grey400),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _goToChatScreen,
                      child: Image.asset('assets/icons/functions/send_icon.png', width: 24, height: 24,),
                    ),
                    SizedBox(height: 12,),


                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}