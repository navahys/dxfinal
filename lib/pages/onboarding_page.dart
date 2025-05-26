import 'package:flutter/material.dart';
import '../pages/login_page.dart';

import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 3; // 전체 온보딩 페이지 수

  // 각 온보딩 페이지 위젯 리스트 - 더 실제적인 온보딩 내용으로 개선
  final List<Widget> _onboardingPages = [
    Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Text(
              '환영합니다!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                '밖에서도 언제나 틔운 버디와 대화를 나누어보세요!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    ),
    Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rocket_launch, size: 100, color: Colors.white),
            SizedBox(height: 30),
            Text(
              '빠르고 간편하게',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                '나의 감정을 살펴보고 마음을 관리해보아요',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    ),
    Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFee0979), Color(0xFFff6a00)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 100, color: Colors.white),
            SizedBox(height: 30),
            Text(
              '지금 시작하세요!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                '유용한 팁으로 나만의 틔운을 꾸미고 틔워보아요!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            physics: const PageScrollPhysics(), // 스크롤 물리 명시적 설정
            allowImplicitScrolling: true, // 암시적 스크롤 허용
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: _onboardingPages,
          ),

          // 건너뛰기 버튼 (마지막 페이지가 아닐 때만 표시)
          if (_currentPage != _numPages - 1)
            Positioned(
              top: 50.0,
              right: 20.0,
              child: TextButton(
                onPressed: () {
                  // 바로 로그인 페이지로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text(
                  '건너뛰기',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ),

          // 디버깅용 네비게이션 버튼들 (임시)
          Positioned(
            bottom: 150.0,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed:
                      _currentPage > 0
                          ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                          : null,
                  child: const Text('이전'),
                ),
                Text(
                  '${_currentPage + 1} / $_numPages',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                ElevatedButton(
                  onPressed:
                      _currentPage < _numPages - 1
                          ? () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                          : null,
                  child: const Text('다음'),
                ),
              ],
            ),
          ),

          // 마지막 페이지에만 '로그인하기' 버튼 표시
          if (_currentPage == _numPages - 1)
            Positioned(
              bottom: 100.0,
              left: 40,
              right: 40,
              child: ElevatedButton(
                onPressed: () {
                  // 로그인 페이지로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFee0979),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  '로그인하기',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

          // 페이지 인디케이터
          Positioned(
            bottom: 50.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _numPages,
                (index) => buildDot(index: index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 페이지 인디케이터 점 위젯
  Widget buildDot({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8.0),
      height: 10,
      width: _currentPage == index ? 25 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
