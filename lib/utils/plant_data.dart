class PlantData {
  final String name;
  final String displayName;
  final String imagePath;
  final String description;
  final List<String> careRequirements;

  const PlantData({
    required this.name,
    required this.displayName,
    required this.imagePath,
    required this.description,
    required this.careRequirements,
  });
}

class PlantDataUtils {
  static const List<PlantData> availablePlants = [
    PlantData(
      name: '금어초',
      displayName: '금어초 (노랑)',
      imagePath: 'assets/images/shop/image_geumuh_yell.png',
      description: '화려한 노란색 꽃이 아름다운 금어초입니다.',
      careRequirements: ['충분한 햇빛', '적당한 물주기', '배수가 잘 되는 토양'],
    ),
    PlantData(
      name: '금어초_분홍',
      displayName: '금어초 (분홍)',
      imagePath: 'assets/images/shop/image_geumuh_pink.png',
      description: '우아한 분홍색 꽃이 매력적인 금어초입니다.',
      careRequirements: ['충분한 햇빛', '적당한 물주기', '배수가 잘 되는 토양'],
    ),
    PlantData(
      name: '방울토마토',
      displayName: '방울토마토',
      imagePath: 'assets/images/shop/image_tomato.png',
      description: '작고 달콤한 방울토마토를 키워보세요.',
      careRequirements: ['충분한 햇빛', '규칙적인 물주기', '영양분이 풍부한 토양'],
    ),
    PlantData(
      name: '푸름이',
      displayName: '푸름이 (랜덤씨앗)',
      imagePath: 'assets/images/shop/image_pureum.png',
      description: '어떤 식물이 자랄지 모르는 신비로운 씨앗입니다.',
      careRequirements: ['기본 관리', '적당한 햇빛', '규칙적인 물주기'],
    ),
    PlantData(
      name: '라벤더',
      displayName: '라벤더',
      imagePath: 'assets/images/shop/image_lavandula.png',
      description: '향긋한 라벤더로 공간을 가득 채워보세요.',
      careRequirements: ['충분한 햇빛', '배수가 잘 되는 토양', '적당한 건조함'],
    ),
    PlantData(
      name: '바질',
      displayName: '바질',
      imagePath: 'assets/images/shop/image_catnip.png',
      description: '요리에 활용할 수 있는 신선한 바질입니다.',
      careRequirements: ['적당한 햇빛', '규칙적인 물주기', '따뜻한 환경'],
    ),
    PlantData(
      name: '딜',
      displayName: '딜',
      imagePath: 'assets/images/shop/image_diil.png',
      description: '섬세한 잎과 독특한 향이 매력적인 딜입니다.',
      careRequirements: ['충분한 햇빛', '적당한 물주기', '서늘한 환경'],
    ),
    PlantData(
      name: '펜넬',
      displayName: '펜넬',
      imagePath: 'assets/images/shop/image_pennel.png',
      description: '회향이라고도 불리는 향긋한 허브식물입니다.',
      careRequirements: ['충분한 햇빛', '배수가 잘 되는 토양', '적당한 물주기'],
    ),
    PlantData(
      name: '타임',
      displayName: '타임',
      imagePath: 'assets/images/shop/image_time.png',
      description: '작은 잎에 강한 향이 나는 허브식물입니다.',
      careRequirements: ['충분한 햇빛', '배수가 잘 되는 토양', '건조한 환경'],
    ),
    PlantData(
      name: '채송화',
      displayName: '채송화 (분홍)',
      imagePath: 'assets/images/shop/image_cheasong_pink.png',
      description: '여름철에 피는 귀여운 분홍색 채송화입니다.',
      careRequirements: ['충분한 햇빛', '적당한 물주기', '더위에 강함'],
    ),
    PlantData(
      name: '채송화_노랑',
      displayName: '채송화 (노랑)',
      imagePath: 'assets/images/shop/image_cheasong_yell.png',
      description: '밝은 노란색이 아름다운 채송화입니다.',
      careRequirements: ['충분한 햇빛', '적당한 물주기', '더위에 강함'],
    ),
    PlantData(
      name: '스톡',
      displayName: '스톡 (보라)',
      imagePath: 'assets/images/shop/image_stock_violet.png',
      description: '우아한 보라색 꽃이 특징인 스톡입니다.',
      careRequirements: ['충분한 햇빛', '서늘한 환경', '적당한 물주기'],
    ),
    PlantData(
      name: '스톡_노랑',
      displayName: '스톡 (노랑)',
      imagePath: 'assets/images/shop/image_stock_yell.png',
      description: '화사한 노란색 꽃이 아름다운 스톡입니다.',
      careRequirements: ['충분한 햇빛', '서늘한 환경', '적당한 물주기'],
    ),
    PlantData(
      name: '임파티엔스',
      displayName: '임파티엔스 (분홍)',
      imagePath: 'assets/images/shop/image_impha_pink.png',
      description: '그늘에서도 잘 자라는 분홍색 임파티엔스입니다.',
      careRequirements: ['반그늘', '충분한 물주기', '습한 환경'],
    ),
    PlantData(
      name: '임파티엔스_하양',
      displayName: '임파티엔스 (하양)',
      imagePath: 'assets/images/shop/image_impha_white.png',
      description: '순백색이 우아한 임파티엔스입니다.',
      careRequirements: ['반그늘', '충분한 물주기', '습한 환경'],
    ),
    PlantData(
      name: '가자니아',
      displayName: '가자니아',
      imagePath: 'assets/images/shop/image_gaza.png',
      description: '해바라기를 닮은 밝은 색상의 가자니아입니다.',
      careRequirements: ['충분한 햇빛', '배수가 잘 되는 토양', '건조한 환경'],
    ),
    PlantData(
      name: '꽃',
      displayName: '꽃 (파랑)',
      imagePath: 'assets/images/shop/image_flower_blue.png',
      description: '신비로운 파란색 꽃입니다.',
      careRequirements: ['충분한 햇빛', '적당한 물주기', '서늘한 환경'],
    ),
    PlantData(
      name: '꽃_분홍',
      displayName: '꽃 (분홍)',
      imagePath: 'assets/images/shop/image_flower_pink.png',
      description: '사랑스러운 분홍색 꽃입니다.',
      careRequirements: ['충분한 햇빛', '적당한 물주기', '따뜻한 환경'],
    ),
  ];

  // 식물 이름으로 PlantData 찾기
  static PlantData? getPlantByName(String name) {
    try {
      return availablePlants.firstWhere(
        (plant) => plant.name == name || plant.displayName == name,
      );
    } catch (e) {
      return null;
    }
  }

  // 이미지 경로 가져오기
  static String getImagePath(String plantName) {
    final plant = getPlantByName(plantName);
    return plant?.imagePath ?? 'assets/images/shop/image_pureum.png'; // 기본 이미지
  }

  // 식물 설명 가져오기
  static String getDescription(String plantName) {
    final plant = getPlantByName(plantName);
    return plant?.description ?? '식물에 대한 설명이 없습니다.';
  }

  // 관리 요구사항 가져오기
  static List<String> getCareRequirements(String plantName) {
    final plant = getPlantByName(plantName);
    return plant?.careRequirements ?? ['기본적인 관리가 필요합니다.'];
  }

  // 표시 이름으로 실제 이름 가져오기
  static String getNameByDisplayName(String displayName) {
    final plant = availablePlants.where(
      (plant) => plant.displayName == displayName,
    ).firstOrNull;
    return plant?.name ?? displayName;
  }
}
