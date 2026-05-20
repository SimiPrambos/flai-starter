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
    return SizedBox(
      width: 224.w,
      height: 72.h,
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Scale from design viewBox: 870×234
    canvas.scale(size.width / 870, size.height / 234);

    // "Learn"
    (TextPainter(
      text: const TextSpan(
        text: 'Learn',
        style: TextStyle(
          color: Colors.white,
          fontSize: 160,
          fontWeight: FontWeight.w500,
          letterSpacing: -4,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout()).paint(canvas, Offset.zero);

    // "pert"
    (TextPainter(
      text: const TextSpan(
        text: 'pert',
        style: TextStyle(
          color: Colors.white,
          fontSize: 160,
          fontWeight: FontWeight.w500,
          letterSpacing: -4,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout()).paint(canvas, const Offset(520, 0));

    // X — blue/purple diagonal
    canvas
      ..drawPath(
        Path()
          ..moveTo(415, 40)
          ..lineTo(470, 110)
          ..lineTo(540, 200)
          ..lineTo(490, 200)
          ..lineTo(430, 125)
          ..lineTo(390, 75)
          ..close(),
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF6D8BFF), Color(0xFF3A64FF), Color(0xFF7A4DFF)],
          ).createShader(const Rect.fromLTWH(390, 40, 150, 160)),
      )
      // X — teal/green diagonal
      ..drawPath(
        Path()
          ..moveTo(395, 200)
          ..lineTo(450, 125)
          ..lineTo(505, 55)
          ..lineTo(470, 95)
          ..lineTo(430, 145)
          ..lineTo(445, 200)
          ..close(),
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Color(0xFF1BE3A3), Color(0xFF1CC7C7), Color(0xFF3A8CFF)],
          ).createShader(const Rect.fromLTWH(395, 55, 110, 145)),
      )
      // Leaf above X
      ..drawPath(
        Path()
          ..moveTo(495, 38)
          ..cubicTo(505, 25, 520, 25, 525, 35)
          ..cubicTo(520, 48, 505, 50, 495, 38)
          ..close(),
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF3A8CFF), Color(0xFF1BE3A3)],
          ).createShader(const Rect.fromLTWH(495, 25, 30, 25)),
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Decorative arch pattern
// ---------------------------------------------------------------------------

class _ArchPattern extends StatelessWidget {
  const _ArchPattern();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.75,
        child: CustomPaint(painter: _ArchPainter()),
      ),
    );
  }
}

class _ArchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Design space: 420×912 — scale to actual screen
    canvas
      ..save()
      ..scale(size.width / 420, size.height / 912);

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..blendMode = BlendMode.softLight;

    for (final path in _paths()) {
      canvas.drawPath(path, paint);
    }

    canvas.restore();
  }

  List<Path> _paths() => [
    Path()
      ..moveTo(42.43, 694.54)
      ..lineTo(42.43, 842.41)
      ..cubicTo(42.44, 850.54, 40.31, 858.59, 36.17, 866.10)
      ..cubicTo(32.03, 873.61, 25.97, 880.44, 18.32, 886.19)
      ..cubicTo(10.67, 891.94, 1.59, 896.50, -8.40, 899.61)
      ..cubicTo(-18.40, 902.72, -29.11, 904.32, -39.93, 904.32)
      ..lineTo(-39.93, 756.38)
      ..cubicTo(-39.91, 739.98, -31.23, 724.25, -15.78, 712.65)
      ..cubicTo(-0.34, 701.06, 20.60, 694.54, 42.43, 694.54)
      ..close(),
    Path()
      ..moveTo(440.35, 694.54)
      ..lineTo(440.35, 842.41)
      ..cubicTo(440.36, 850.54, 438.23, 858.59, 434.09, 866.10)
      ..cubicTo(429.95, 873.61, 423.89, 880.44, 416.24, 886.19)
      ..cubicTo(408.59, 891.94, 399.51, 896.50, 389.52, 899.61)
      ..cubicTo(379.52, 902.72, 368.81, 904.32, 357.99, 904.32)
      ..lineTo(357.99, 756.38)
      ..cubicTo(358.01, 739.98, 366.69, 724.25, 382.14, 712.65)
      ..cubicTo(397.58, 701.06, 418.52, 694.54, 440.35, 694.54)
      ..close(),
    Path()
      ..moveTo(240.78, 694.54)
      ..lineTo(240.78, 842.41)
      ..cubicTo(240.79, 850.54, 238.66, 858.59, 234.52, 866.10)
      ..cubicTo(230.39, 873.61, 224.32, 880.44, 216.67, 886.19)
      ..cubicTo(209.02, 891.94, 199.94, 896.50, 189.95, 899.61)
      ..cubicTo(179.95, 902.72, 169.24, 904.32, 158.42, 904.32)
      ..lineTo(158.42, 756.38)
      ..cubicTo(158.44, 739.98, 167.12, 724.25, 182.57, 712.65)
      ..cubicTo(198.01, 701.06, 218.95, 694.54, 240.78, 694.54)
      ..close(),
    Path()
      ..moveTo(59.12, 694.54)
      ..lineTo(59.12, 842.41)
      ..cubicTo(59.12, 850.54, 61.25, 858.59, 65.38, 866.10)
      ..cubicTo(69.52, 873.61, 75.59, 880.44, 83.23, 886.19)
      ..cubicTo(90.88, 891.94, 99.96, 896.50, 109.96, 899.61)
      ..cubicTo(119.95, 902.72, 130.67, 904.32, 141.49, 904.32)
      ..lineTo(141.49, 756.38)
      ..cubicTo(141.47, 739.98, 132.78, 724.25, 117.34, 712.65)
      ..cubicTo(101.89, 701.06, 80.96, 694.54, 59.12, 694.54)
      ..close(),
    Path()
      ..moveTo(457.04, 694.54)
      ..lineTo(457.04, 842.41)
      ..cubicTo(457.04, 850.54, 459.17, 858.59, 463.30, 866.10)
      ..cubicTo(467.44, 873.61, 473.51, 880.44, 481.16, 886.19)
      ..cubicTo(488.80, 891.94, 497.88, 896.50, 507.88, 899.61)
      ..cubicTo(517.87, 902.72, 528.59, 904.32, 539.41, 904.32)
      ..lineTo(539.41, 756.38)
      ..cubicTo(539.39, 739.98, 530.70, 724.25, 515.26, 712.65)
      ..cubicTo(499.82, 701.06, 478.88, 694.54, 457.04, 694.54)
      ..close(),
    Path()
      ..moveTo(257.47, 694.54)
      ..lineTo(257.47, 842.41)
      ..cubicTo(257.47, 850.54, 259.60, 858.59, 263.73, 866.10)
      ..cubicTo(267.87, 873.61, 273.94, 880.44, 281.59, 886.19)
      ..cubicTo(289.23, 891.94, 298.32, 896.50, 308.31, 899.61)
      ..cubicTo(318.30, 902.72, 329.02, 904.32, 339.84, 904.32)
      ..lineTo(339.84, 756.38)
      ..cubicTo(339.82, 739.98, 331.13, 724.25, 315.69, 712.65)
      ..cubicTo(300.25, 701.06, 279.31, 694.54, 257.47, 694.54)
      ..close(),
  ];

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
