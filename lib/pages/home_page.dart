import 'package:flutter/material.dart';
import 'package:tiiun/pages/chatting_page.dart';
import 'package:tiiun/pages/buddy_page.dart';
import 'package:tiiun/pages/info_page.dart';
import 'package:tiiun/pages/my_page.dart';
import 'package:tiiun/design_system/colors.dart';
import 'package:tiiun/design_system/typography.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

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
      child: CustomScrollView(
        slivers: [
          // 상단 고정/유연 영역
          SliverToBoxAdapter(
            child: SafeArea(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 400, // 최소 높이
                  maxHeight: 574, // 최대 높이 (y축 574)
                ),
                child: Column(
                  children: [
                    // 알림 아이콘
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/functions/notification_off.svg',
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2), // 유연한 공간

                    // 로고
                    Container(
                      child: SvgPicture.asset(
                        'assets/images/tiiun_logo.svg',
                        width: 80,
                        height: 40,
                      ),
                    ),
                    const Spacer(flex: 2), // 유연한 공간

                    // 검색창
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(1.5),
                      width: double.maxFinite,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF72ED98),
                            Color(0xFF10BEBE),
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
                              child: SvgPicture.asset(
                                'assets/icons/functions/Paper_Plane.svg',
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 12,),

                    // 퀵 액션 버튼들 (가로 스크롤)
                    SizedBox(
                      height: 32,
                      child: Stack(
                        children: [
                          // 스크롤 가능한 버튼 리스트
                          ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 24),
                            children: [
                              _buildQuickActionWithIcon('이전 대화', 'assets/icons/functions/icon_dialog.svg'),
                              const SizedBox(width: 8),
                              _buildQuickActionText('자랑거리'),
                              const SizedBox(width: 8),
                              _buildQuickActionText('고민거리'),
                              const SizedBox(width: 8),
                              _buildQuickActionText('위로가 필요할 때'),
                              const SizedBox(width: 8),
                              _buildQuickActionText('시시콜콜'),
                              const SizedBox(width: 8),
                              _buildQuickActionText('끝말 잇기'),
                              const SizedBox(width: 8),
                              _buildQuickActionText('화가 나요'),
                              const SizedBox(width: 24), // 마지막 여백
                            ],
                          ),
                          // 왼쪽 그라데이션
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 24,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    const Color(0xFFF3F5F2),
                                    const Color(0xFFF3F5F2).withOpacity(0.0),
                                  ],
                                  stops: [0.1, 1.0],
                                ),
                              ),
                            ),
                          ),
                          // 오른쪽 그라데이션
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 24,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    const Color(0xFFF3F5F2).withOpacity(0.0),
                                    const Color(0xFFF3F5F2),
                                  ],
                                  stops: [0.9, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 126,),

                    // 틔운 상태 창
                    Container(
                      // width: 320,
                      height: 56,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.grey100,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/functions/temperature_off.svg',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 2),
                          Text('적정 온도',
                            style: AppTypography.b3.copyWith(
                                color: AppColors.grey700,
                            ),
                          ),

                          const SizedBox(width: 12,),

                          Container(
                            width: 1,
                            height: 15,
                            color: AppColors.grey200,
                          ),

                          const SizedBox(width: 12,),
                          
                          SvgPicture.asset(
                            'assets/icons/functions/light_on.svg',
                            width: 24,
                            height: 24,
                          ),

                          SizedBox(width: 2,),

                          Text('조명 밝기 낮음',
                            style: AppTypography.b3.copyWith(
                              color: AppColors.grey700,
                            ),
                          ),

                          const Spacer(),

                          SvgPicture.asset(
                            'assets/icons/functions/more.svg',
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // 겨울철 식물 관리 팁 섹션 (스크롤 가능한 영역)
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '겨울철 식물 관리 팁',
                      style: AppTypography.s1.copyWith(
                        color: AppColors.grey900,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 식물 관리 팁 카드들
                    _buildPlantTipCard(
                      '겨울철 물주기, 깍지벌레 관리 팁',
                      'assets/images/plant1.jpg',
                    ),
                    const SizedBox(height: 16),

                    _buildPlantTipCard(
                      '겨울 걱정 No! 겨울철 식물 이사 고민 줄여요',
                      'assets/images/plant2.jpg',
                    ),
                    const SizedBox(height: 16),

                    _buildPlantTipCard(
                      '실내 공기 정화 식물로 겨울철 건강 지키기',
                      'assets/images/plant3.jpg',
                    ),
                    const SizedBox(height: 16),

                    _buildPlantTipCard(
                      '토분이 관리하기 쉽다고? 누가!',
                      'assets/images/plant4.jpg',
                    ),

                    // 하단 여백 (네비게이션 바와 겹치지 않게)
                    const SizedBox(height: 100),

                    SizedBox(height: 12,),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 아이콘 + 텍스트가 있는 퀵 액션 버튼 (이전 대화용)
  Widget _buildQuickActionWithIcon(String text, String iconPath) {
    return GestureDetector(
      onTap: () {
        // 버튼 동작 구현
      },
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: AppTypography.b4.copyWith(
                color: AppColors.grey700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 식물 관리 팁 카드 위젯
  Widget _buildPlantTipCard(String title, String imagePath) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 이미지
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: const Icon(
              Icons.eco,
              size: 48,
              color: Colors.green,
            ),
          ),
          // 텍스트 내용
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTypography.b1.copyWith(
                      color: AppColors.grey900,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
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

  // 텍스트만 있는 퀵 액션 버튼
  Widget _buildQuickActionText(String text) {
    return GestureDetector(
      onTap: () {
        // 버튼 동작 구현
      },
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTypography.b4.copyWith(
              color: AppColors.grey700,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            width: 360,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                top: BorderSide(
                  color: AppColors.grey100,
                  width: 1,
                ),
              ),
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
                      activeIcon: 'assets/icons/navbar/home.svg',
                      inactiveIcon: 'assets/icons/navbar/home.svg',
                    ),
                    _buildNavItem(
                      index: 1,
                      label: '버디',
                      activeIcon: 'assets/icons/navbar/leaves.svg',
                      inactiveIcon: 'assets/icons/navbar/leaves.svg',
                    ),
                    _buildNavItem(
                      index: 2,
                      label: '정보',
                      activeIcon: 'assets/icons/navbar/information.svg',
                      inactiveIcon: 'assets/icons/navbar/information.svg',
                    ),
                    _buildNavItem(
                      index: 3,
                      label: 'My',
                      activeIcon: 'assets/icons/navbar/my.svg',
                      inactiveIcon: 'assets/icons/navbar/my.svg',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required String activeIcon,
    required String inactiveIcon,
  }) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isSelected ? activeIcon : inactiveIcon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.grey900 : AppColors.grey300,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.c2.copyWith(
                color: isSelected ? AppColors.grey900 : AppColors.grey300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}