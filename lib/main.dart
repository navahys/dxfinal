import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tiiun/firebase_options.dart';
import 'package:tiiun/pages/home_page.dart';
import 'package:tiiun/pages/login_page.dart';
import 'package:tiiun/design_system/colors.dart';
import 'package:tiiun/pages/onboarding_page.dart';
import 'package:tiiun/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TiiunApp());
}

class TiiunApp extends StatelessWidget {
  const TiiunApp({super.key});

  // FirebaseAuth로부터 현재 로그인한 사용자 정보를 가져옵니다.

  // 사용자의 회원가입이나 로그인 여부와 관계없이 'SplashScreen'을 보여줍니다.

  // SplashScreen이 3초간 보여지고, 로그인 여부에 따라 다른 페이지로 이동합니다.

  // 만약 사용자가 로그인하지 않은 상태라면 `OnboardingPage`를 보여주고, OnboardingPage를 모두 본 다음에는 `LoginPage`로 이동합니다.
  // 만약 사용자가 로그인한 상태라면 `HomePage`를 보여줍니다.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiiun',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      // SplashScreen을 초기 화면으로 설정
      home: const SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}