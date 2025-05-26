import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiiun/design_system/colors.dart';
import 'package:tiiun/design_system/typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // 3초간 스플래시 화면 표시
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // FirebaseAuth로부터 현재 로그인한 사용자 정보를 가져옵니다
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // 사용자가 로그인한 상태라면 HomePage를 보여줍니다
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // 사용자가 로그인하지 않은 상태라면 OnboardingPage를 보여줍니다
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 그라데이션 배경
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFEBEDEA),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 70.21,
                height: 35.26,
              ), // 로고
              const SizedBox(height: 18.74),
              Image.asset(
                'assets/images/tiiun_buddy_logo.png',
                width: 149,
                height: 29,
              ),
            ],
          ),
        ),
      ),
    );
  }
}