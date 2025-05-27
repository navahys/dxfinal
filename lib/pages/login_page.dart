import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiiun/design_system/colors.dart';
import 'package:tiiun/design_system/typography.dart';
import 'package:tiiun/pages/lgsignin_page.dart';
import 'signup_page.dart'; // 회원가입 페이지 import

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    super.initState();
    _forceLogout();
  }

  Future<void> _forceLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('LoginPage: Force logout completed');
    } catch (e) {
      print('LoginPage logout error: $e');
    }
  }

  // 언어 설정
  String _selectedLanguage = '언어 변경';
  final List<String> _languages = [
    '한국어',
    'English',
    '中国话',
    '日本語',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildLoginScreen(),
      ),
    );
  }

  // 로그인 화면
  Widget _buildLoginScreen() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // 상단 헤더
          _buildHeader(_selectedLanguage),

          // 중앙 로고 영역
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 210),

                Image.asset('assets/images/logo.png', width: 70.21, height: 35.26),
                Container(height: 19),
                Image.asset('assets/images/tiiun_buddy_logo.png', width: 148.32, height: 27.98),

                const SizedBox(height: 240),

                // 소셜 로그인 버튼들
                _buildSocialLoginButton(
                  'LG 계정 로그인',
                  'assets/images/lg_logo.png',
                  Color(0xFF97282F),
                  onTap: () {
                    // LG 로그인 폼으로 이동
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LGSigninPage()),
                    );
                  }, // 로그인 성공 시 홈으로
                ),
                const SizedBox(height: 10),
                _buildSocialLoginButton(
                  'Google 계정으로 로그인',
                  'assets/images/google_logo.png',
                  Color(0xFF477BDF),
                ),
                const SizedBox(height: 10),
                _buildSocialLoginButton(
                  'Apple 계정으로 로그인',
                  'assets/images/apple_logo.png',
                  Colors.black,
                ),
              ],
            ),
          ),

          Container(height: 24),
          // 하단 영역 - 회원가입으로 변경
          GestureDetector(
            onTap: _navigateToSignup, // 회원가입 페이지로 이동
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '계정이 없으신가요? 회원가입',
                  style: AppTypography.largeBtn.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.grey300,
                  size: 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 회원가입 페이지로 이동
  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
  }

  // HomePage로 이동
  void _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
          (route) => false,
    );
  }

  // 언어 선택 다이얼로그 표시
  void _showLanguageSelector() {
    showDialog(
      context: context,
      barrierColor: Color.fromRGBO(0, 0, 0, 0.5),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Container(
            width: double.maxFinite,
            height: 284,
            padding: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 헤더 (제목 + X 버튼)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '언어 설정',
                        style: AppTypography.h5.copyWith(
                          color: Color(0xFF1B1C1A),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 24,
                        height: 24,
                        child: Icon(
                          Icons.close,
                          size: 24,
                          color: AppColors.grey800,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // 언어 목록
                Expanded(
                  child: Column(
                    children: _languages.asMap().entries.map((entry) {
                      int index = entry.key;
                      String language = entry.value;

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _selectedLanguage = language;
                              });
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '$language 선택됨 (데모용)',
                                    style: AppTypography.b1,
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                language,
                                style: AppTypography.b1,
                              ),
                            ),
                          ),
                          // 마지막 항목이 아니면 구분선 추가
                          if (index < _languages.length - 1)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColors.grey200,
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 공통 헤더 (언어설정만)
  Widget _buildHeader(String text) {
    return Row(
      children: [
        const SizedBox(width: 48), // 왼쪽 여백
        Expanded(
          child: GestureDetector(
            onTap: _showLanguageSelector,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _selectedLanguage,
                  style: AppTypography.b2.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.grey300,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 48), // 오른쪽 여백
      ],
    );
  }

  // 소셜 로그인 버튼
  Widget _buildSocialLoginButton(String text, dynamic iconOrPath, Color color, {VoidCallback? onTap}) {
    return Container(
      width: double.infinity,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: onTap ?? () {
          print('$text 버튼 클릭됨');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          children: [
            SizedBox(width: 12),
            Image.asset(
              iconOrPath,
              width: 26,
              height: 26,
            ),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: AppTypography.largeBtn.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 28),
          ],
        ),
      ),
    );
  }
}