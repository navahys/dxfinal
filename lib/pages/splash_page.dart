import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
    try {
      print('🔍 DEBUG: Starting auth check');
      print('🔍 Current user: ${FirebaseAuth.instance.currentUser?.email}');
      print('🔍 Current user UID: ${FirebaseAuth.instance.currentUser?.uid}');

      await FirebaseAuth.instance.signOut();
      print('🔍 SignOut completed');

      await Future.delayed(const Duration(milliseconds: 500));
      print('🔍 After delay - User: ${FirebaseAuth.instance.currentUser?.email}');

      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;
      print('🔍 Navigating to onboarding');
      Navigator.pushReplacementNamed(context, '/onboarding');

    } catch (e) {
      print('🔍 ERROR: $e');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
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