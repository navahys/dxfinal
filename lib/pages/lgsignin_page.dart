import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiiun/design_system/colors.dart';
import 'package:tiiun/design_system/typography.dart';

class LGSigninPage extends StatefulWidget {
  const LGSigninPage({super.key});

  @override
  State<LGSigninPage> createState() => _LGSigninPageState();
}

class _LGSigninPageState extends State<LGSigninPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // 유효성 검사 상태 추가
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    // 텍스트 변경 감지
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 실시간 폼 유효성 검사
  void _validateForm() {
    setState(() {
      // 이메일 검사
      String email = _emailController.text.trim();
      if (email.isEmpty) {
        _isEmailValid = false;
        _emailError = null;
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        _isEmailValid = false;
        _emailError = '이메일 형식을 확인해주세요';
      } else {
        _isEmailValid = true;
        _emailError = null;
      }

      // 비밀번호 검사
      String password = _passwordController.text;
      if (password.isEmpty) {
        _isPasswordValid = false;
        _passwordError = null;
      } else if (password.length < 8) {
        _isPasswordValid = false;
        _passwordError = '비밀번호는 최소 8자 이상이어야 합니다';
      } else if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password)) {
        _isPasswordValid = false;
        _passwordError = '영문과 숫자를 포함해야 합니다';
      } else {
        _isPasswordValid = true;
        _passwordError = null;
      }
    });
  }

  // 로그인 버튼 활성화 여부
  bool get _isFormValid => _isEmailValid && _isPasswordValid;

  // Firebase 로그인 처리
  Future<void> _handleSignIn() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
              (route) => false,
        );
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

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return '등록되지 않은 이메일입니다.';
      case 'wrong-password':
        return '비밀번호가 올바르지 않습니다.';
      case 'invalid-email':
        return '유효하지 않은 이메일 형식입니다.';
      default:
        return '로그인에 실패했습니다.';
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTypography.b2),
        backgroundColor: AppColors.point900,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 헤더 (고정)
                _buildHeader(),

                // 입력 필드들 (자동 확장)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ID 라벨
                      Text(
                        'ID',
                        style: AppTypography.b2.copyWith(
                          color: AppColors.grey800,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // 이메일 입력 필드
                      _buildTextFormField(
                        controller: _emailController,
                        hintText: '이메일 입력',
                        keyboardType: TextInputType.emailAddress,
                        hasError: _emailError != null,
                        isValid: _isEmailValid,
                      ),

                      // 이메일 에러 메시지
                      if (_emailError != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _emailError!,
                          style: AppTypography.c1.copyWith(
                            color: AppColors.point900,
                          ),
                        ),
                      ],

                      const SizedBox(height: 29.5),

                      // PASSWORD 라벨
                      Text(
                        'PASSWORD',
                        style: AppTypography.b2.copyWith(
                          color: AppColors.grey900,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 비밀번호 입력 필드
                      _buildPasswordField(),

                      // 비밀번호 에러 메시지
                      if (_passwordError != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _passwordError!,
                          style: AppTypography.c1.copyWith(
                            color: AppColors.point900,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // 로그인 버튼 (하단 고정)
                _buildSignInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 56,
      child: Stack(
        children: [
          // 뒤로가기 버튼 (왼쪽)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: 24,
              color: AppColors.grey700,
            ),
          ),
          // 제목 (가운데)
          Center(
            child: Text(
              'LG 계정 로그인',
              style: AppTypography.b2.copyWith(
                color: AppColors.grey900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool hasError = false,
    bool isValid = false,
  }) {
    Color getBorderColor() {
      if (hasError) return AppColors.point800;
      if (isValid) return AppColors.main700;
      return AppColors.grey300;
    }
    return Container(
      height: 48,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppTypography.b1,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTypography.b1.copyWith(
            color: AppColors.grey400,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: getBorderColor(),
              width: 1.5,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: getBorderColor(),
              width: 1.5,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.point800,
              width: 1.5,
            ),
          ),
          contentPadding: EdgeInsets.only(left: 8),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    Color getBorderColor() {
      if (_passwordError != null) return AppColors.point800;
<<<<<<< HEAD
      if (_isPasswordValid) return AppColors.main700;  // 또는 AppColors.point900
=======
      if (_isPasswordValid) return AppColors.main700;
>>>>>>> jiyun
      return AppColors.grey300;
    }
    return Container(
      height: 48,
      child: Stack(
        children: [
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: AppTypography.b2,
            decoration: InputDecoration(
              hintText: '패스워드 입력',
              hintStyle: AppTypography.b1.copyWith(
                color: AppColors.grey400,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: getBorderColor(),
                  width: 1.5,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: getBorderColor(),
                  width: 1.5,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _passwordError != null ? AppColors.point900 : AppColors.point900,
                  width: 1.5,
                ),
              ),
              contentPadding: EdgeInsets.only(left: 8),
            ),
          ),

          // 아이콘 대신 이미지 사용
          Positioned(
            right: 0,
            top: 12, // 이미지를 텍스트와 같은 높이로 조정
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              child: Image.asset(
                _obscurePassword
                    ? 'assets/icons/functions/dontshow_icon.png'
                    : 'assets/icons/functions/show_icon.png',
                width: 20,
                height: 20,
                color: AppColors.grey500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: (_isFormValid && !_isLoading) ? _handleSignIn : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid ? AppColors.main700 : AppColors.grey200,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            : Text(
          '로그인',
          style: AppTypography.largeBtn.copyWith(
            color: _isFormValid ? Colors.white : AppColors.grey400,
          ),
        ),
      ),
    );
  }
}