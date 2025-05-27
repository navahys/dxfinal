import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiiun/design_system/colors.dart';
import 'package:tiiun/design_system/typography.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  int _currentStep = 1; // 1: 정보입력, 2: 완료

  // 컨트롤러들
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nicknameController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
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
      Navigator.pop(context); // 로그인 페이지로 돌아가기
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
        _nextStep(); // Step 2로 이동
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
      default:
        return _buildStep1();
    }
  }

  // Step 1: 정보 입력 화면
  Widget _buildStep1() {
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
                  _buildPasswordConfirmField(),
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

  // Step 2: 완료 화면
  Widget _buildStep2() {
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
                  '환영합니다!',
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
          color: AppColors.main900,
        ),
        hintStyle: AppTypography.b3.copyWith(
          color: AppColors.main600,
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
          color: AppColors.main900,
        ),
        hintStyle: AppTypography.b3.copyWith(
          color: AppColors.main600,
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

  // 가입하기 버튼
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
          '가입하기',
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

  // 비밀번호 확인 필드 ✅ 새로 추가
  Widget _buildPasswordConfirmField() {
    return TextFormField(
      controller: _passwordConfirmController,
      obscureText: _obscurePasswordConfirm,
      style: AppTypography.b1,
      decoration: InputDecoration(
        labelText: '비밀번호 확인',
        hintText: '비밀번호를 다시 입력하세요',
        labelStyle: AppTypography.b3.copyWith(
          color: AppColors.main900,
        ),
        hintStyle: AppTypography.b3.copyWith(
          color: AppColors.main600,
        ),
        border: const UnderlineInputBorder(),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.point800),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePasswordConfirm ? Icons.visibility : Icons.visibility_off,
            color: AppColors.main600,
          ),
          onPressed: () {
            setState(() {
              _obscurePasswordConfirm = !_obscurePasswordConfirm;
            });
          },
        ),
      ),
      validator: _validatePasswordConfirm,
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

  String? _validatePasswordConfirm(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호 확인을 입력해주세요';
    }
    if (value != _passwordController.text) {
      return '비밀번호가 일치하지 않습니다';
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