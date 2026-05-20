import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:template_vgv_app/core/router/app_router.dart';
import 'package:template_vgv_app/features/auth/presentation/providers/login_notifier.dart';

const _bgTop = Color(0xFF04040E);
const _bgBottom = Color(0xFF1056D9);
const _btnColor = Color(0xFF1056D9);
const _inputBorder = Color(0xFFD5D7DA);
const _placeholder = Color(0xFF9AA2B1);
const _footerText = Color(0xFF868D9D);
const _labelText = Color(0xFFF7F7F7);

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginTap() {
    ref
        .read(loginNotifierProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(loginNotifierProvider, (_, next) {
      if (next is AsyncData) {
        const DashboardRoute().go(context);
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    final isLoading = ref.watch(loginNotifierProvider) is AsyncLoading;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: Stack(
          children: [
            const _ArchPattern(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _LearnXpertLogo(),
                      Gap(4.r),
                      Text(
                        'POWERED  BY  AJARI',
                        style: TextStyle(
                          fontSize: 10.sp,
                          letterSpacing: 3.2,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                      ),
                      Gap(40.r),
                      _EmailField(controller: _emailController),
                      Gap(16.r),
                      _PasswordField(
                        controller: _passwordController,
                        obscure: _obscurePassword,
                        onToggle: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      Gap(44.r),
                      _LoginButton(
                        onTap: isLoading ? null : _onLoginTap,
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 24.h,
              child: Text(
                '©2026 LearnXpert LnD',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: _footerText,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Form fields
// ---------------------------------------------------------------------------

class _LabeledInput extends StatelessWidget {
  const _LabeledInput({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: _labelText,
          ),
        ),
        Gap(6.r),
        Container(
          height: 41.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _inputBorder),
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0A0D12).withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return _LabeledInput(
      label: 'Email',
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF1A1F2B)),
        decoration: InputDecoration(
          hintText: 'yourname@learnxpert.com',
          hintStyle: TextStyle(fontSize: 14.sp, color: _placeholder),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return _LabeledInput(
      label: 'Password',
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF1A1F2B)),
              decoration: InputDecoration(
                hintText: 'Enter your password',
                hintStyle: TextStyle(fontSize: 14.sp, color: _placeholder),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: Icon(
              obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 16.r,
              color: const Color(0xFF868D9D),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Login button
// ---------------------------------------------------------------------------

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.onTap, required this.isLoading});
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _btnColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.r,
                height: 20.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Login',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// LearnXpert Logo
// ---------------------------------------------------------------------------

class _LearnXpertLogo extends StatelessWidget {
  const _LearnXpertLogo();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo_learn_expert.svg',
      width: 224.w,
      height: 88.h,
    );
  }
}

// ---------------------------------------------------------------------------
// Decorative arch pattern
// ---------------------------------------------------------------------------

class _ArchPattern extends StatelessWidget {
  const _ArchPattern();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SvgPicture.asset(
        'assets/images/decoration_bottom_login.svg',
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
