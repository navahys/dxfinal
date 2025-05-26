import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiiun/design_system/colors.dart';
import 'package:tiiun/design_system/typography.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _currentStep = 1; // 1: 로고, 2: 정보입력, 3: 완료

  // Step 2용 컨트롤러들
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  // 언어 설정
  String _selectedLanguage = '대한민국/한국어';
  final List<String> _languages = [
    '대한민국/한국어',
    'English/영어',
    '中文/중국어',
    '日本語/일본어',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  // 다음 단계로 이동
  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  // 이전 단계로 이동 (Step 1에서는 onboarding으로)
  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    } else {
      // Step 1에서는 onboarding으로 돌아가지 않고 그대로 유지
      // Navigator.pop(context);
    }
  }

  // Firebase 회원가입 처리
  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      await userCredential.user?.updateDisplayName(_nicknameController.text.trim());

      if (mounted) {
        _nextStep(); // Step 3로 이동
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getErrorMessage(e.code);
      if (mounted) {
        _showErrorSnackBar(errorMessage);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('알 수 없는 오류가 발생했습니다: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 에러 메시지 변환
  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return '이미 사용 중인 이메일입니다.';
      case 'weak-password':
        return '비밀번호가 너무 약합니다.';
      case 'invalid-email':
        return '유효하지 않은 이메일 형식입니다.';
      default:
        return '오류가 발생했습니다.';
    }
  }

  // 에러 스낵바 표시
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTypography.b3),
        backgroundColor: Colors.red,
      ),
    );
  }

  // HomePage로 이동
  void _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildCurrentStep(),
      ),
    );
  }

  // 현재 단계에 맞는 위젯 반환
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return _buildStep1();
    }
  }

  // Step 1: 로고 화면
  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // 상단 헤더
          _buildHeader(_selectedLanguage),

          // 중앙 로고 영역
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 210),

                Image.asset('assets/images/logo.png', width: 70.21, height: 35.26),
                Container(height: 19),
                Image.asset('assets/images/tiiun_buddy_logo.png', width: 148.32, height: 27.98,),

                const SizedBox(height: 240),

                // 소셜 로그인 버튼들
                _buildSocialLoginButton(
                  'LG 계정 로그인',
                  'assets/images/lg_logo.png',
                  Color(0xFF97282F),
                  onTap: _nextStep,
                ),
                const SizedBox(height: 10),
                _buildSocialLoginButton(
                  'Google 계정으로 로그인',
                  'assets/images/google_logo.png',
                  Color(0xFF477BDF),
                ),
                const SizedBox(height: 10),
                _buildSocialLoginButton(
                  'Apple 계정으로 로그인',
                  'assets/images/apple_logo.png',
                  Colors.black,
                ),
              ],
            ),
          ),

          Container(height: 24,),
          // 하단 영역
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '다른 계정으로 로그인',
                style: AppTypography.largeBtn.copyWith(
                  color: AppColors.grey400,
                ),
              ),
              const SizedBox(width: 10), // 텍스트와 아이콘 사이 간격
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.grey300,
                size: 10,
              ),
            ],
          )
        ],
      ),
    );
  }

  // Step 2: 정보 입력 화면
  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 헤더
            _buildHeaderWithTitle('뒤로 가기'),

            const SizedBox(height: 60),

            // 입력 필드들
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextFormField(
                    controller: _emailController,
                    labelText: '이메일 입력',
                    hintText: 'example@email.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 24),
                  _buildPasswordField(),
                  const SizedBox(height: 24),
                  _buildTextFormField(
                    controller: _nicknameController,
                    labelText: '닉네임 입력',
                    hintText: '사용할 닉네임을 입력하세요',
                    validator: _validateNickname,
                  ),
                ],
              ),
            ),

            // 하단 계속하기 버튼
            _buildContinueButton(_isLoading ? null : _handleSignUp, isLoading: _isLoading),
          ],
        ),
      ),
    );
  }

  // Step 3: 완료 화면
  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 60),

          // 중앙 완료 메시지
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 완료 아이콘
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.point800.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 60,
                    color: AppColors.point800,
                  ),
                ),
                const SizedBox(height: 40),

                Text(
                  '가입하신 것을 환영합니다!',
                  style: AppTypography.h4.copyWith(
                    color: AppColors.main900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

              ],
            ),
          ),

          // 시작하기 버튼
          _buildStartButton(),
        ],
      ),
    );
  }

  // 언어 선택 다이얼로그 표시
  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '언어 설정',
            style: AppTypography.s1.copyWith(
              color: AppColors.main900,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _languages.map((language) {
              return ListTile(
                title: Text(
                  language,
                  style: AppTypography.b3,
                ),
                leading: Radio<String>(
                  value: language,
                  groupValue: _selectedLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.of(context).pop();
                    // 실제 언어 변경 로직은 구현하지 않음
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$value 선택됨 (데모용)',
                          style: AppTypography.b3,
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  activeColor: AppColors.point800,
                ),
                contentPadding: EdgeInsets.zero,
                dense: true,
              );
            }).toList(),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  // 공통 헤더 (언어설정만)
  Widget _buildHeader(String text) {
    return Row(
      children: [
        const SizedBox(width: 48), // 왼쪽 여백
        Expanded(
          child: GestureDetector(
            onTap: _showLanguageSelector,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _selectedLanguage,
                  style: AppTypography.b2.copyWith(
                    color: AppColors.main700,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.main700,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 48), // 오른쪽 여백
      ],
    );
  }

  // 헤더 + 타이틀
  Widget _buildHeaderWithTitle(String title) {
    return Row(
      children: [
        IconButton(
          onPressed: _previousStep,
          icon: const Icon(Icons.arrow_back_ios),
          color: AppColors.main900,
        ),
        Text(
          title,
          style: AppTypography.s1.copyWith(
            color: AppColors.main900,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  // 소셜 로그인 버튼
  Widget _buildSocialLoginButton(String text, dynamic iconOrPath, Color color, {VoidCallback? onTap}) {
    return Container(
      width: double.infinity,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: onTap ?? () {
          print('$text 버튼 클릭됨');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // 버튼 배경색을 각 브랜드 색상으로
          foregroundColor: Colors.white, // 텍스트 색상은 흰색으로
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60), // 둥근 모서리
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          children: [
            SizedBox(width: 12), // 아이콘 왼쪽 패딩 (선택적)
            Image.asset(
              iconOrPath,
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 12), // 아이콘과 텍스트 사이 간격
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: AppTypography.largeBtn.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 28), // 오른쪽 공간 확보 (아이콘과 균형 맞추기 위함)
          ],
        ),

      ),
    );
  }

  // 일반 텍스트 필드
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTypography.b1,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: AppTypography.b3.copyWith(
          color: AppColors.main600,
        ),
        hintStyle: AppTypography.b3.copyWith(
          color: AppColors.main500, // main400 대신 main500 사용
        ),
        border: const UnderlineInputBorder(),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.point800),
        ),
      ),
      validator: validator,
    );
  }

  // 비밀번호 필드
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: AppTypography.b1,
      decoration: InputDecoration(
        labelText: '비밀번호 입력',
        hintText: '6자 이상 입력하세요',
        labelStyle: AppTypography.b3.copyWith(
          color: AppColors.main600,
        ),
        hintStyle: AppTypography.b3.copyWith(
          color: AppColors.main500, // main400 대신 main500 사용
        ),
        border: const UnderlineInputBorder(),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.point800),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: AppColors.main600,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      validator: _validatePassword,
    );
  }

  // 계속하기 버튼
  Widget _buildContinueButton(VoidCallback? onPressed, {bool isLoading = false}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.point800,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          '계속하기',
          style: AppTypography.largeBtn.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // 시작하기 버튼
  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _navigateToHome,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.point800,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          '시작하기',
          style: AppTypography.largeBtn.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // 유효성 검사 함수들
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return '유효한 이메일을 입력해주세요';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번하를 입력해주세요';
    }
    if (value.length < 6) {
      return '비밀번호는 최소 6자 이상이어야 합니다';
    }
    return null;
  }

  String? _validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return '닉네임을 입력해주세요';
    }
    if (value.length < 2) {
      return '닉네임은 최소 2자 이상이어야 합니다';
    }
    return null;
  }
}