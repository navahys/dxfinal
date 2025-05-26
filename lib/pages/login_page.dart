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

  // 이전 단계로 이동
  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
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
        content: Text(message),
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
                Image.asset('assets/images/logo.png'),
                Container(height: 19),
                Image.asset('assets/images/tiiun_buddy_logo.png'),
                const SizedBox(height: 60),

                // 소셜 로그인 버튼들
                _buildSocialLoginButton(
                  'LG 계정 로그인',
                  Icons.account_circle,
                  AppColors.point800,
                ),
                const SizedBox(height: 16),
                _buildSocialLoginButton(
                  'Google 계정으로 로그인',
                  Icons.computer,
                  Colors.red,
                ),
                const SizedBox(height: 16),
                _buildSocialLoginButton(
                  'Apple 계정으로 로그인',
                  Icons.apple,
                  Colors.black,
                ),
              ],
            ),
          ),

          // 하단 영역
          Column(
            children: [
              const Text(
                '다른 계정으로 로그인 >',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.main700,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
              const SizedBox(height: 24),
              _buildContinueButton(_nextStep),
            ],
          ),
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
            _buildHeaderWithTitle('정보\n가기'),

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

                const Text(
                  '가입하신 것을 환영합니다!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.main900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                const Text(
                  '귀하의 정보 그룹',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.main600,
                  ),
                  textAlign: TextAlign.center,
                ),
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
          title: const Text(
            '언어 설정',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.main900,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _languages.map((language) {
              return ListTile(
                title: Text(language),
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
                        content: Text('$value 선택됨 (데모용)'),
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

  // 공통 헤더 (뒤로가기 + 언어설정)
  Widget _buildHeader(String text) {
    return Row(
      children: [
        IconButton(
          onPressed: _previousStep,
          icon: const Icon(Icons.arrow_back_ios),
          color: AppColors.main900,
        ),
        Expanded(
          child: GestureDetector(
            onTap: _showLanguageSelector,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _selectedLanguage,
                  style: const TextStyle(
                    fontSize: 16,
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
        const SizedBox(width: 48),
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.main900,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  // 소셜 로그인 버튼
  Widget _buildSocialLoginButton(String text, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: OutlinedButton.icon(
        onPressed: () {
          // 소셜 로그인 로직 구현
        },
        icon: Icon(icon, color: color),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
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
      decoration: InputDecoration(
        labelText: '비밀번호 입력',
        hintText: '6자 이상 입력하세요',
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
            : const Text(
          '계속하기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
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
        child: const Text(
          '시작하기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
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
      return '비밀번호를 입력해주세요';
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