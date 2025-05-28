import 'package:flutter/material.dart';
import 'package:tiiun/pages/chatting_page.dart';
import 'package:tiiun/pages/buddy_page.dart';
import 'package:tiiun/pages/info_page.dart';
import 'package:tiiun/pages/my_page.dart';
import 'package:tiiun/design_system/colors.dart';
import 'package:tiiun/design_system/typography.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // 홈 탭 내용 (기존 HomePage 내용)
  Widget _buildHomeContent() {
    return Container(
      color: const Color(0xFFF3F5F2),
      child: SafeArea(
        child: Column(
          children: [
            // 알림 아이콘
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/icons/functions/notification_off_icon.png',
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 95),
            Container(
              child: Image.asset(
                'assets/images/tiiun_logo.png',
                width: 80,
                height: 40,
              ),
            ),
            const SizedBox(height: 95),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(1.5),
              width: double.maxFinite,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
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
                    color: const Color(0xFF10BEBE).withOpacity(0.2),
                    spreadRadius: -4,
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ],
                borderRadius: BorderRadius.circular(60),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 21),
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
                      child: Image.asset(
                        'assets/icons/functions/send_icon.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
<<<<<<< HEAD
                    SizedBox(height: 12,),


                    
=======
>>>>>>> jiyun
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 각 탭 내용 선택
  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const BuddyPage();
      case 2:
        return const InfoPage();
      case 3:
        return const MyPage();
      default:
        return _buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  label: '홈',
                  activeIcon: Icons.home,
                  inactiveIcon: Icons.home_outlined,
                ),
                _buildNavItem(
                  index: 1,
                  label: '버디',
                  activeIcon: Icons.people,
                  inactiveIcon: Icons.people_outline,
                ),
                _buildNavItem(
                  index: 2,
                  label: '정보',
                  activeIcon: Icons.info,
                  inactiveIcon: Icons.info_outline,
                ),
                _buildNavItem(
                  index: 3,
                  label: 'My',
                  activeIcon: Icons.person,
                  inactiveIcon: Icons.person_outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData activeIcon,
    required IconData inactiveIcon,
  }) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? AppColors.main700 : AppColors.grey400,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.c2.copyWith(
                color: isSelected ? AppColors.main700 : AppColors.grey400,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}