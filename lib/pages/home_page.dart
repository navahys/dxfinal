import 'package:flutter/material.dart';
import '../design_system/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Home Page',
          style: TextStyle(color: AppColors.main900),
        ),
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
