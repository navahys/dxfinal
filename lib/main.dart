import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tiiun/firebase_options.dart';
import 'package:tiiun/pages/home_page.dart';
import 'package:tiiun/pages/login_page.dart';
import 'package:tiiun/design_system/colors.dart';
import 'package:tiiun/pages/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TiiunApp());
}

class TiiunApp extends StatelessWidget {
  const TiiunApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // FirebaseAuth로부터 현재 로그인한 사용자 정보를 가져옵니다.

    // 만약 사용자가 로그인하지 않은 상태라면 `LoginPage`를 보여줍니다.
    // 만약 사용자가 로그인한 상태라면 `FeedPage`를 보여줍니다.

    return MaterialApp(
      title: 'Tiiun',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(),
    );
  }
}
