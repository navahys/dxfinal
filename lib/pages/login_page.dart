import 'package:flutter/material.dart';
import 'package:tiiun/design_system/colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인하기', style: TextStyle(color: AppColors.main900)),
      ),
      body: const Center(
        child: Text(
          'Welcome to my app!',
          style: TextStyle(color: AppColors.point800),
        ),
      ),
    );
  }
}
