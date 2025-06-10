# 🚀 Tiiun App 성능 최적화 적용 가이드

## 📋 적용 순서

### **Phase 1: 기존 파일 백업**
```bash
# 중요: 기존 파일들을 백업합니다
cp lib/models/message_model.dart lib/models/message_model_backup.dart
cp lib/models/conversation_model.dart lib/models/conversation_model_backup.dart
cp lib/services/conversation_service.dart lib/services/conversation_service_backup.dart
cp lib/pages/home_chatting/chatting_page.dart lib/pages/home_chatting/chatting_page_backup.dart
cp lib/utils/encoding_utils.dart lib/utils/encoding_utils_backup.dart
```

### **Phase 2: 최적화된 파일들로 교체**
```bash
# 1. 모델 파일 교체
mv lib/models/message_model_optimized.dart lib/models/message_model.dart
mv lib/models/conversation_model_optimized.dart lib/models/conversation_model.dart

# 2. 서비스 파일 교체  
mv lib/services/conversation_service_optimized.dart lib/services/conversation_service.dart

# 3. 페이지 파일 교체
mv lib/pages/home_chatting/chatting_page_optimized.dart lib/pages/home_chatting/chatting_page.dart

# 4. 유틸리티 파일 교체
mv lib/utils/encoding_utils_optimized.dart lib/utils/encoding_utils.dart
```

### **Phase 3: 새 파일들 추가**
```bash
# 마이그레이션 헬퍼와 성능 모니터링 도구 추가 (이미 생성됨)
# lib/utils/migration_helper.dart
# lib/utils/performance_monitor.dart
```

### **Phase 4: 의존성 업데이트**
`pubspec.yaml`에 필요한 경우 의존성을 추가합니다:
```yaml
dependencies:
  # 기존 의존성들...
  
dev_dependencies:
  # 기존 dev 의존성들...
  test: ^1.24.0  # 성능 테스트용 (필요한 경우)
```

---

## 🛠 마이그레이션 실행

### **1. 마이그레이션 서비스 추가**
`lib/services/migration_service.dart` 파일을 생성:

```dart
// lib/services/migration_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiiun/utils/migration_helper.dart';
import 'package:tiiun/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final migrationServiceProvider = Provider<MigrationHelper>((ref) {
  final authService = ref.watch(authServiceProvider);
  return MigrationHelper(FirebaseFirestore.instance, authService);
});
```

### **2. 마이그레이션 페이지 추가**
`lib/pages/admin/migration_page.dart` 파일을 생성:

```dart
// lib/pages/admin/migration_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiiun/services/migration_service.dart';
import 'package:tiiun/utils/migration_helper.dart';
import 'package:tiiun/design_system/colors.dart';
import 'package:tiiun/design_system/typography.dart';

class MigrationPage extends ConsumerStatefulWidget {
  const MigrationPage({super.key});

  @override
  ConsumerState<MigrationPage> createState() => _MigrationPageState();
}

class _MigrationPageState extends ConsumerState<MigrationPage> {
  bool _isMigrating = false;
  MigrationResult? _lastResult;
  MigrationProgress? _progress;

  @override
  void initState() {
    super.initState();
    _checkMigrationProgress();
  }

  Future<void> _checkMigrationProgress() async {
    try {
      final migrationHelper = ref.read(migrationServiceProvider);
      final progress = await migrationHelper.checkMigrationProgress();
      setState(() {
        _progress = progress;
      });
    } catch (e) {
      debugPrint('마이그레이션 진행률 체크 실패: $e');
    }
  }

  Future<void> _startMigration() async {
    setState(() {
      _isMigrating = true;
    });

    try {
      final migrationHelper = ref.read(migrationServiceProvider);
      final result = await migrationHelper.migrateAllUserData();
      
      setState(() {
        _lastResult = result;
        _isMigrating = false;
      });

      if (result.successRate > 90) {
        _showSnackBar('✅ 마이그레이션 성공!', AppColors.main600);
      } else {
        _showSnackBar('⚠️ 마이그레이션 부분 완료', AppColors.point600);
      }
    } catch (e) {
      setState(() {
        _isMigrating = false;
      });
      _showSnackBar('❌ 마이그레이션 실패: $e', AppColors.point900);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('데이터 마이그레이션', style: AppTypography.h5),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 설명
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.main100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📊 Base64 → 직접 저장 마이그레이션',
                    style: AppTypography.s1.withColor(AppColors.main700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '데이터 크기를 33% 줄이고 성능을 개선합니다.',
                    style: AppTypography.b3.withColor(AppColors.main600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 현재 상태
            if (_progress != null) ...[
              Text('📈 현재 상태', style: AppTypography.s1),
              const SizedBox(height: 12),
              _buildProgressCard('대화', _progress!.conversationsMigrated, _progress!.conversationsTotal),
              const SizedBox(height: 8),
              _buildProgressCard('메시지', _progress!.messagesMigrated, _progress!.messagesTotal),
              const SizedBox(height: 24),
            ],

            // 마이그레이션 버튼
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isMigrating ? null : _startMigration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.main600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isMigrating
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('마이그레이션 진행 중...', style: AppTypography.largeBtn),
                        ],
                      )
                    : Text('🚀 마이그레이션 시작', style: AppTypography.largeBtn),
              ),
            ),

            const SizedBox(height: 24),

            // 결과 표시
            if (_lastResult != null) ...[
              Text('📊 마이그레이션 결과', style: AppTypography.s1),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResultRow('전체 문서', '${_lastResult!.totalDocuments}개'),
                    _buildResultRow('마이그레이션 완료', '${_lastResult!.migratedDocuments}개'),
                    _buildResultRow('성공률', '${_lastResult!.successRate.toStringAsFixed(1)}%'),
                    _buildResultRow('절약된 크기', _lastResult!.sizeSavedFormatted),
                    _buildResultRow('소요 시간', '${_lastResult!.duration.inSeconds}초'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(String title, int completed, int total) {
    final progress = total > 0 ? completed / total : 0.0;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.b2),
              Text('$completed/$total', style: AppTypography.b3.withColor(AppColors.grey600)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.grey200,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.main600),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.b3.withColor(AppColors.grey700)),
          Text(value, style: AppTypography.b2.withColor(AppColors.grey900)),
        ],
      ),
    );
  }
}
```

### **3. 마이그레이션 실행 방법**

#### **옵션 A: 개발자 모드에서 실행**
```dart
// lib/pages/mypage/my_page.dart에 디버그 버튼 추가
if (kDebugMode) {
  ListTile(
    leading: Icon(Icons.upgrade),
    title: Text('데이터 마이그레이션'),
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MigrationPage()),
    ),
  ),
}
```

#### **옵션 B: 자동 마이그레이션 (권장)**
```dart
// lib/main.dart에 추가
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 자동 마이그레이션 실행
  await _performAutomaticMigration();

  runApp(const ProviderScope(child: TiiunApp()));
}

Future<void> _performAutomaticMigration() async {
  try {
    // 간단한 마이그레이션 체크
    final migrationHelper = MigrationHelper(
      FirebaseFirestore.instance, 
      AuthService()
    );
    
    // 현재 사용자가 로그인되어 있고 마이그레이션이 필요한지 체크
    // 구현은 필요에 따라 조정
  } catch (e) {
    debugPrint('자동 마이그레이션 실패: $e');
  }
}
```

---

## 📊 성능 모니터링 설정

### **1. 모니터링 초기화**
```dart
// lib/main.dart에 추가
void main() async {
  // ... 기존 초기화 코드

  // 성능 모니터링 시작
  if (kDebugMode) {
    PerformanceMonitor.instance.startMonitoring();
  }

  runApp(const ProviderScope(child: TiiunApp()));
}
```

### **2. 주요 작업 모니터링**
```dart
// 예시: AI 응답 시간 측정
Future<AIResponse> getResponse({
  required String conversationId,
  required String userMessage,
}) async {
  PerformanceMonitor.instance.startOperation('ai_response');
  
  try {
    final response = await _langchainService.getResponse(
      conversationId: conversationId,
      userMessage: userMessage,
    );
    
    PerformanceMonitor.instance.endOperation('ai_response');
    return response;
  } catch (e) {
    PerformanceMonitor.instance.endOperation('ai_response');
    rethrow;
  }
}
```

### **3. 성능 보고서 확인**
```dart
// 개발자 도구에서 성능 보고서 출력
void printPerformanceReport() {
  if (kDebugMode) {
    final report = PerformanceMonitor.instance.generateReport();
    debugPrint(report);
  }
}
```

---

## ✅ 테스트 및 검증

### **1. 기능 테스트**
```bash
# 기본 기능 테스트 실행
flutter test
```

### **2. 성능 테스트**
```bash
# 성능 프로파일링
flutter run --profile
```

### **3. 데이터 무결성 검증**
마이그레이션 후 다음 사항들을 확인:
- [ ] 대화 제목이 올바르게 표시되는지
- [ ] 메시지 내용이 정상적으로 로드되는지  
- [ ] 새로운 메시지 생성이 정상 작동하는지
- [ ] 검색 기능이 정상 작동하는지

---

## 🚨 문제 해결

### **문제 1: 마이그레이션 실패**
```dart
// 롤백 실행
final migrationHelper = ref.read(migrationServiceProvider);
await migrationHelper.rollbackMigration();
```

### **문제 2: 성능 저하**
```dart
// 캐시 정리
final conversationService = ref.read(conversationServiceProvider);
conversationService.clearAllCaches();
```

### **문제 3: 메모리 누수**
```dart
// 성능 모니터링으로 메모리 사용량 체크
final stats = PerformanceMonitor.instance.generateStats();
debugPrint('Memory usage: ${stats.memorySnapshots.last.memoryInfo.usagePercent}%');
```

---

## 📈 기대 효과

### **성능 개선**
- ✅ **데이터 크기 33% 감소** (Base64 제거)
- ✅ **메시지 로딩 속도 향상** (페이지네이션)
- ✅ **메모리 사용량 최적화** (캐싱 및 정리)
- ✅ **스크롤 성능 개선** (ListView 최적화)

### **비용 절약**
- ✅ **Firestore 읽기/쓰기 비용 감소**
- ✅ **Firebase Storage 사용량 감소**
- ✅ **네트워크 데이터 사용량 감소**

### **사용자 경험**
- ✅ **더 빠른 앱 응답 속도**
- ✅ **부드러운 스크롤링**
- ✅ **메모리 부족으로 인한 크래시 감소**

---

## 🔄 지속적인 모니터링

### **주간 체크리스트**
- [ ] 성능 모니터링 보고서 확인
- [ ] 메모리 사용량 추세 확인  
- [ ] 사용자 피드백 수집
- [ ] 새로운 성능 이슈 확인

### **월간 최적화**
- [ ] 성능 통계 분석
- [ ] 새로운 최적화 기회 식별
- [ ] 캐시 정책 조정
- [ ] 데이터베이스 쿼리 최적화

이 가이드를 따라 단계별로 적용하면 Tiiun 앱의 성능이 크게 향상될 것입니다! 🚀
