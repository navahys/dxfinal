import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiiun/design_system/colors.dart';
import 'package:tiiun/design_system/typography.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tiiun/pages/buddy/buddy_diary.dart';
import '../../models/plant_model.dart';
import '../../services/backend_providers.dart';
import '../../utils/plant_data.dart';
import 'buddy_deco.dart';
import 'buddy_shop_page.dart';
import 'buddy_history.dart';
import 'add_plant_page.dart';
import 'dart:ui';

class BuddyPage extends ConsumerStatefulWidget {
  const BuddyPage({super.key});

  @override
  ConsumerState<BuddyPage> createState() => _BuddyPageState();
}

class _BuddyPageState extends ConsumerState<BuddyPage> {
  late final PageController _pageController;
  int _currentPlantIndex = 0;
  List<Plant> _plants = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPlantIndex,
      viewportFraction: 0.325,
    );
    _loadPlants();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadPlants() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final plantService = ref.read(plantApiServiceProvider);
      final response = await plantService.getMyPlants(isActive: true);

      if (response.isSuccess && response.data != null) {
        setState(() {
          _plants = response.data!;
          _isLoading = false;
          // 식물이 있으면 첫 번째 식물을 선택
          if (_plants.isNotEmpty && _currentPlantIndex >= _plants.length) {
            _currentPlantIndex = 0;
          }
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = response.error ?? '식물 목록을 불러오는데 실패했습니다.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '식물 목록을 불러오는 중 오류가 발생했습니다: $e';
      });
    }
  }

  // 식물 추가 후 목록 새로고침
  Future<void> _navigateToAddPlant() async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => const AddPlantPage()),
    );
    
    // 식물이 추가되었으면 목록을 새로고침
    if (result == true) {
      await _loadPlants();
    }
  }

  // 조명 밝기 변경 함수
  void _updateLightLevel(int level) {
    // TODO: 실제 조명 밝기 업데이트 API 호출
    setState(() {
      // 임시로 UI만 업데이트
    });
  }

  // 심은 날짜로부터 경과 일수 계산
  int _calculateDaysFromPlanted(DateTime? plantedDate) {
    if (plantedDate == null) return 0;
    final now = DateTime.now();
    return now.difference(plantedDate).inDays;
  }

  // 식물에 대한 이미지 경로 가져오기
  String _getPlantImagePath(Plant plant) {
    if (plant.imageUrl != null && plant.imageUrl!.isNotEmpty) {
      return plant.imageUrl!;
    }
    return PlantDataUtils.getImagePath(plant.speciesName);
  }

  // 식물 표시명 가져오기
  String _getPlantDisplayName(Plant plant) {
    final plantData = PlantDataUtils.getPlantByName(plant.speciesName);
    return plantData?.displayName ?? plant.speciesName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD4F5F5), Color(0xFFE8F6F6)],
            stops: [0.6, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 고정 헤더
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('버디', style: AppTypography.s1.withColor(AppColors.grey900)),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _navigateToAddPlant(),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: AppColors.main600,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BuddyShopPage())),
                            child: SvgPicture.asset('assets/icons/buddy/Handbag.svg', width: 24, height: 24),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BuddyHistoryPage())),
                            child: SvgPicture.asset('assets/icons/functions/icon_buddy.svg', width: 24, height: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 스크롤 가능한 영역
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.main600),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: AppTypography.b3.withColor(AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPlants,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.main600,
                foregroundColor: Colors.white,
              ),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (_plants.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // 이미지 카드 영역
          SizedBox(
            height: 140,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _plants.length,
              onPageChanged: (index) => setState(() => _currentPlantIndex = index),
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double scale = 1.0;
                    if (_pageController.position.haveDimensions) {
                      double diff = (_pageController.page! - index).abs();
                      scale = 1.0 - (diff * 0.429).clamp(0.0, 0.429);
                    }
                    return Center(
                      child: Transform.scale(
                        scale: scale,
                        child: _buildBuddyImageCard(_plants[index], index == _currentPlantIndex),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          _buildPlantInfo(_plants[_currentPlantIndex]),

          const SizedBox(height: 24),

          // 버디 화면 꾸미러가기 버튼
          _buildDecoButton(),

          const SizedBox(height: 12),

          // 상태 카드들
          _buildStatusCards(_plants[_currentPlantIndex]),

          const SizedBox(height: 12),

          // 조명 정보 카드
          _buildLightInfoCard(_plants[_currentPlantIndex]),

          const SizedBox(height: 10),

          // 씨앗 키트 제거 버튼
          _buildSeedKitRemoveButton(_plants[_currentPlantIndex]),

          // 하단 여백
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/functions/icon_buddy.svg',
            width: 64,
            height: 64,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            '아직 등록된 식물이 없어요',
            style: AppTypography.s2.withColor(AppColors.grey600),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 번째 식물을 등록해보세요!',
            style: AppTypography.b3.withColor(AppColors.grey500),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _navigateToAddPlant,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.main600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              '식물 등록하기',
              style: AppTypography.s2.withColor(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuddyImageCard(Plant plant, bool isActive) {
    final imagePath = _getPlantImagePath(plant);
    
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: isActive ? Colors.white : AppColors.grey200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF131927).withOpacity(0.08),
            blurRadius: 16,
            spreadRadius: -6,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: isActive
            ? Stack(
          children: [
            // isActive일 때: 배경만 blur
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ),
            // 선명한 이미지
            Center(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.local_florist,
                      size: 64,
                      color: AppColors.grey500,
                    ),
                  );
                },
              ),
            ),
          ],
        )
            : BackdropFilter(
          // isActive가 아닐 때: 전체(배경+이미지) blur
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
            ),
            child: Center(
              child: Transform.scale(
                scale: 0.85,
                child: Image.asset(
                  imagePath,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey200,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.local_florist,
                        size: 54,
                        color: AppColors.grey500,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlantInfo(Plant plant) {
    final daysPlanted = _calculateDaysFromPlanted(plant.plantedDate);
    final displayName = _getPlantDisplayName(plant);
    
    return Column(
      children: [
        Text('${daysPlanted}일차', style: AppTypography.b4.withColor(AppColors.main900)),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                plant.nickname ?? displayName,
                style: AppTypography.h5.withColor(AppColors.grey900),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BuddyDiaryPage(
                        plantName: plant.nickname ?? displayName,
                        plantVariety: displayName,
                        plantedDate: _calculatePlantedDate(daysPlanted),
                        plantImage: _getPlantImagePath(plant),
                        daysPlanted: daysPlanted,
                        plantId: plant.plantId,
                      ),
                    ),
                  );
                },
                child: SvgPicture.asset(
                  'assets/icons/functions/more.svg',
                  width: 24,
                  height: 24,
                  color: AppColors.grey400,
                ),
              ),
            ],
          ),
        ),
        Text(displayName, style: AppTypography.b3.withColor(AppColors.grey500)),
      ],
    );
  }

  // 버디 화면 꾸미러가기 버튼
  Widget _buildDecoButton() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BuddyDecoPage()),
      ),
      child: Container(
        width: double.infinity,
        height: 44,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '버디 화면 꾸미러가기',
              style: AppTypography.b3.withColor(AppColors.grey800),
            ),
            SvgPicture.asset(
              'assets/icons/functions/more.svg',
              width: 24,
              height: 24,
              color: AppColors.grey500,
            )
          ],
        ),
      ),
    );
  }

  // 상태 카드들
  Widget _buildStatusCards(Plant plant) {
    return Column(
      children: [
        // 건강 상태
        _buildStatusCard(
          icon: _getHealthStatusIcon(plant.healthStatus),
          title: '${plant.healthStatus ?? "건강"} 상태',
          description: _getHealthStatusDescription(plant.healthStatus),
          backgroundColor: Colors.white,
        ),

        const SizedBox(height: 10),

        // 성장 단계
        _buildStatusCard(
          icon: _getGrowthStageIcon(plant.growthStage),
          title: '성장 단계: ${plant.growthStage ?? "알 수 없음"}',
          description: _getGrowthStageDescription(plant.growthStage),
          backgroundColor: Colors.white,
        ),
      ],
    );
  }

  String _getHealthStatusIcon(String? healthStatus) {
    switch (healthStatus) {
      case '건강':
        return 'assets/icons/buddy/temperature_off_gradient.svg';
      case '주의':
        return 'assets/icons/buddy/half_bottle.svg';
      case '위험':
        return 'assets/icons/buddy/temperature_off_gradient.svg';
      default:
        return 'assets/icons/buddy/temperature_off_gradient.svg';
    }
  }

  String _getHealthStatusDescription(String? healthStatus) {
    switch (healthStatus) {
      case '건강':
        return '식물이 건강하게 자라고 있어요';
      case '주의':
        return '식물 상태에 주의가 필요해요';
      case '위험':
        return '식물이 위험한 상태예요. 관리가 필요합니다';
      default:
        return '식물 상태를 확인해주세요';
    }
  }

  String _getGrowthStageIcon(String? growthStage) {
    switch (growthStage) {
      case '씨앗':
        return 'assets/icons/buddy/temperature_off_gradient.svg';
      case '새싹':
        return 'assets/icons/buddy/half_bottle.svg';
      case '성장':
        return 'assets/icons/buddy/temperature_off_gradient.svg';
      case '개화':
        return 'assets/icons/buddy/half_bottle.svg';
      case '열매':
        return 'assets/icons/buddy/temperature_off_gradient.svg';
      default:
        return 'assets/icons/buddy/temperature_off_gradient.svg';
    }
  }

  String _getGrowthStageDescription(String? growthStage) {
    switch (growthStage) {
      case '씨앗':
        return '씨앗이 발아를 기다리고 있어요';
      case '새싹':
        return '새싹이 올라오기 시작했어요';
      case '성장':
        return '식물이 건강하게 자라고 있어요';
      case '개화':
        return '아름다운 꽃이 피었어요';
      case '열매':
        return '열매가 맺혔어요';
      default:
        return '식물이 성장하고 있어요';
    }
  }

  // 개별 상태 카드
  Widget _buildStatusCard({
    required String icon,
    required String title,
    required String description,
    required Color backgroundColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘과 타이틀을 같은 선상에
          Row(
            children: [
              SvgPicture.asset(
                icon,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.b2.withColor(AppColors.grey900),
                ),
              ),
            ],
          ),
          // description은 아래에
          if (description.isNotEmpty) ...[
            Text(
              description,
              style: AppTypography.c1.withColor(AppColors.grey700),
            ),
          ],
        ],
      ),
    );
  }

  // 조명 정보 카드 (기본 정보로 표시)
  Widget _buildLightInfoCard(Plant plant) {
    // 기본값으로 설정
    const int lightHours = 12;
    const int lightLevel = 3;
    const String lightStart = '오전 8:00';
    const String lightEnd = '오후 8:00';
    
    // 10~18시간 범위로 계산하고, 범위를 벗어나면 제한
    double progressValue = ((lightHours - 10) / (18 - 10)).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/functions/light_on.svg',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 2),
                Text(
                  '조명 밝기 보통',
                  style: AppTypography.b2.withColor(AppColors.grey900),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 조명 시간
          Text(
            '조명 시간',
            style: AppTypography.b4.withColor(AppColors.grey900),
          ),
          const SizedBox(height: 2,),
          Text(
            '$lightStart - $lightEnd',
            style: AppTypography.c1.withColor(AppColors.grey700),
          ),

          Container(
            height: 0.5,
            color: AppColors.grey200,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),

          // 조명 지속시간
          Text(
            '조명 지속시간',
            style: AppTypography.b4.withColor(AppColors.grey900),
          ),
          const SizedBox(height: 2,),
          Text(
            '${lightHours}시간',
            style: AppTypography.c2.withColor(AppColors.main900),
          ),

          const SizedBox(height: 2),

          // 프로그레스 바
          Container(
            margin: const EdgeInsets.fromLTRB(0, 12, 0, 4),
            height: 12,
            child: Stack(
              children: [
                // 회색 배경 (전체)
                Container(
                  width: double.infinity,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                // 그라데이션 (진행률만큼)
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressValue,
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF72ED98), Color(0xFF10BEBE)],
                        stops: [0.4, 1.0],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 프로그레스 바 아래 시간 표시
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '10시간',
                style: AppTypography.c1.withColor(AppColors.grey700),
              ),
              Text(
                '18시간',
                style: AppTypography.c1.withColor(AppColors.grey700),
              ),
            ],
          ),
          const SizedBox(height: 4),

          const SizedBox(height: 2),

          Text(
            '조명 시간이 적당하여 버디가 잘 자랄 거예요',
            style: AppTypography.c1.withColor(AppColors.grey700),
          ),

          Container(
            height: 0.5,
            color: AppColors.grey200,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),

          // 조명 밝기
          Text(
            '조명 밝기',
            style: AppTypography.b4.withColor(AppColors.grey900),
          ),
          const SizedBox(height: 2),
          Text(
            '${lightLevel}단계',
            style: AppTypography.c2.withColor(AppColors.main900),
          ),
          const SizedBox(height: 2),

          // 조명 레벨 표시 (터치 가능)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1단계',
                style: AppTypography.c1.withColor(AppColors.grey700),
              ),
              ...List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => _updateLightLevel(index + 1),
                  child: Container(
                    padding: const EdgeInsets.all(4), // 터치 영역을 늘리기 위한 패딩
                    child: SvgPicture.asset(
                      index < lightLevel
                          ? 'assets/icons/buddy/light_on.svg'
                          : 'assets/icons/buddy/light_off.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                );
              }),
              Text(
                '5단계',
                style: AppTypography.c1.withColor(AppColors.grey700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 씨앗 키트 제거 버튼
  Widget _buildSeedKitRemoveButton(Plant plant) {
    return GestureDetector(
      onTap: () {
        _showRemovePlantDialog(plant);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: AppColors.main600,
              width: 1.5
          ),
        ),
        child: Center(
          child: Text(
            '식물 제거',
            style: AppTypography.s2.withColor(AppColors.main800),
          ),
        ),
      ),
    );
  }

  // 식물 제거 확인 다이얼로그
  void _showRemovePlantDialog(Plant plant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '식물 제거',
            style: AppTypography.s1.withColor(AppColors.grey900),
          ),
          content: Text(
            '${plant.nickname ?? _getPlantDisplayName(plant)}을(를) 정말 제거하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.',
            style: AppTypography.b3.withColor(AppColors.grey700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: AppTypography.s2.withColor(AppColors.grey600),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _removePlant(plant);
              },
              child: Text(
                '제거',
                style: AppTypography.s2.withColor(Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // 식물 제거 실행
  Future<void> _removePlant(Plant plant) async {
    try {
      final plantService = ref.read(plantApiServiceProvider);
      final response = await plantService.deletePlant(plant.plantId);

      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${plant.nickname ?? _getPlantDisplayName(plant)}이(가) 제거되었습니다.'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadPlants();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error ?? '식물 제거 중 오류가 발생했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('식물 제거 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 심은 날짜 계산 메서드
  String _calculatePlantedDate(int days) {
    final now = DateTime.now();
    final plantedDate = now.subtract(Duration(days: days));
    return '${plantedDate.year}.${plantedDate.month.toString().padLeft(2, '0')}.${plantedDate.day.toString().padLeft(2, '0')}';
  }
}
