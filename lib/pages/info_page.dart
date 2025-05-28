import 'package:flutter/material.dart';
import 'package:tiiun/design_system/colors.dart';
import 'package:tiiun/design_system/typography.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF3F5F2),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                '정보',
                style: AppTypography.h1.copyWith(color: AppColors.grey900),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  children: [
                    _buildInfoCard(
                      icon: Icons.lightbulb_outline,
                      title: '사용 팁',
                      description: 'Tiiun을 더 효과적으로 사용하는 방법을 알아보세요',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      icon: Icons.help_outline,
                      title: '자주 묻는 질문',
                      description: '궁금한 점들을 해결해 보세요',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      icon: Icons.update,
                      title: '업데이트 소식',
                      description: '최신 기능과 개선사항을 확인하세요',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      icon: Icons.feedback_outlined,
                      title: '피드백',
                      description: '여러분의 소중한 의견을 들려주세요',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.main700.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.main700,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.b1.copyWith(color: AppColors.grey900),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTypography.b4.copyWith(color: AppColors.grey600),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.grey400,
            size: 20,
          ),
        ],
      ),
    );
  }
}