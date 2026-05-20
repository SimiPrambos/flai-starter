import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Image.asset(
      'assets/images/logo_learn_expert.png',
      width: 224.w,
      height: 88.h,
      fit: BoxFit.contain,
    );
  }
}

// ---------------------------------------------------------------------------
// Decorative arch pattern
// Paths from decoration_bottom_login.svg — design space 420×318.
// Only row 1 (6 arches, y ≥ 100) is visible within the 318-tall viewport.
// ---------------------------------------------------------------------------

class _ArchPattern extends StatelessWidget {
  const _ArchPattern();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AspectRatio(
        aspectRatio: 420 / 318,
        child: CustomPaint(painter: _ArchPainter()),
      ),
    );
  }
}

class _ArchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Design space: 420×318
    canvas
      ..save()
      ..scale(size.width / 420, size.height / 318);

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..blendMode = BlendMode.softLight;

    for (final path in _paths()) {
      canvas.drawPath(path, paint);
    }

    canvas.restore();
  }

  // Row 1 — 6 arches from decoration_bottom_login.svg (y starts at 100)
  List<Path> _paths() => [
    Path()
      ..moveTo(42.431, 100.542)
      ..lineTo(42.431, 248.409)
      ..cubicTo(42.435, 256.539, 40.308, 264.589, 36.171, 272.101)
      ..cubicTo(32.034, 279.612, 25.968, 286.438, 18.319, 292.187)
      ..cubicTo(10.671, 297.937, 1.590, 302.497, -8.405, 305.609)
      ..cubicTo(-18.400, 308.721, -29.112, 310.323, -39.931, 310.323)
      ..lineTo(-39.931, 162.382)
      ..cubicTo(-39.914, 145.976, -31.229, 130.247, -15.785, 118.651)
      ..cubicTo(-0.341, 107.056, 20.599, 100.542, 42.431, 100.542)
      ..close(),
    Path()
      ..moveTo(440.352, 100.542)
      ..lineTo(440.352, 248.409)
      ..cubicTo(440.356, 256.539, 438.229, 264.589, 434.091, 272.101)
      ..cubicTo(429.954, 279.612, 423.888, 286.438, 416.240, 292.187)
      ..cubicTo(408.591, 297.937, 399.510, 302.497, 389.516, 305.609)
      ..cubicTo(379.521, 308.721, 368.808, 310.323, 357.990, 310.323)
      ..lineTo(357.990, 162.382)
      ..cubicTo(358.007, 145.976, 366.692, 130.247, 382.136, 118.651)
      ..cubicTo(397.580, 107.056, 418.519, 100.542, 440.352, 100.542)
      ..close(),
    Path()
      ..moveTo(240.782, 100.542)
      ..lineTo(240.782, 248.409)
      ..cubicTo(240.786, 256.539, 238.659, 264.589, 234.522, 272.101)
      ..cubicTo(230.385, 279.612, 224.319, 286.438, 216.670, 292.187)
      ..cubicTo(209.022, 297.937, 199.941, 302.497, 189.946, 305.609)
      ..cubicTo(179.951, 308.721, 169.239, 310.323, 158.420, 310.323)
      ..lineTo(158.420, 162.382)
      ..cubicTo(158.437, 145.976, 167.122, 130.247, 182.566, 118.651)
      ..cubicTo(198.010, 107.056, 218.950, 100.542, 240.782, 100.542)
      ..close(),
    Path()
      ..moveTo(59.123, 100.542)
      ..lineTo(59.123, 248.409)
      ..cubicTo(59.118, 256.539, 61.246, 264.589, 65.383, 272.101)
      ..cubicTo(69.520, 279.612, 75.586, 286.438, 83.234, 292.187)
      ..cubicTo(90.883, 297.937, 99.964, 302.497, 109.959, 305.609)
      ..cubicTo(119.953, 308.721, 130.666, 310.323, 141.485, 310.323)
      ..lineTo(141.485, 162.382)
      ..cubicTo(141.467, 145.976, 132.782, 130.247, 117.338, 118.651)
      ..cubicTo(101.894, 107.056, 80.955, 100.542, 59.123, 100.542)
      ..close(),
    Path()
      ..moveTo(457.043, 100.542)
      ..lineTo(457.043, 248.409)
      ..cubicTo(457.039, 256.539, 459.166, 264.589, 463.303, 272.101)
      ..cubicTo(467.440, 279.612, 473.506, 286.438, 481.155, 292.187)
      ..cubicTo(488.803, 297.937, 497.884, 302.497, 507.879, 305.609)
      ..cubicTo(517.874, 308.721, 528.586, 310.323, 539.405, 310.323)
      ..lineTo(539.405, 162.382)
      ..cubicTo(539.388, 145.976, 530.703, 130.247, 515.259, 118.651)
      ..cubicTo(499.815, 107.056, 478.876, 100.542, 457.043, 100.542)
      ..close(),
    Path()
      ..moveTo(257.474, 100.542)
      ..lineTo(257.474, 248.409)
      ..cubicTo(257.469, 256.539, 259.597, 264.589, 263.734, 272.101)
      ..cubicTo(267.871, 279.612, 273.937, 286.438, 281.585, 292.187)
      ..cubicTo(289.234, 297.937, 298.315, 302.497, 308.310, 305.609)
      ..cubicTo(318.304, 308.721, 329.017, 310.323, 339.836, 310.323)
      ..lineTo(339.836, 162.382)
      ..cubicTo(339.818, 145.976, 331.133, 130.247, 315.689, 118.651)
      ..cubicTo(300.245, 107.056, 279.306, 100.542, 257.474, 100.542)
      ..close(),
  ];

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
