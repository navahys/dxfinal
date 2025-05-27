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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Firebase 로그인 처리
  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        // 로그인 성공 시 홈으로 이동
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
        backgroundColor: Colors.red,
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
                // 뒤로가기 버튼
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios),
                      color: AppColors.main900,
                    ),
                    Text(
                      'LG 계정 로그인',
                      style: AppTypography.s1.copyWith(
                        color: AppColors.main900,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),

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
                    ],
                  ),
                ),

                // 로그인 버튼
                _buildSignInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
        labelStyle: AppTypography.b3.copyWith(color: AppColors.main900),
        hintStyle: AppTypography.b3.copyWith(color: AppColors.main600),
        border: const UnderlineInputBorder(),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.point800),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: AppTypography.b1,
      decoration: InputDecoration(
        labelText: '비밀번호 입력',
        hintText: '비밀번호를 입력하세요',
        labelStyle: AppTypography.b3.copyWith(color: AppColors.main900),
        hintStyle: AppTypography.b3.copyWith(color: AppColors.main600),
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

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF97282F), // LG 빨간색
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          '로그인',
          style: AppTypography.largeBtn.copyWith(color: Colors.white),
        ),
      ),
    );
  }

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
    return null;
  }
}