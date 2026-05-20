import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

// ─── Design tokens

const _primary = Color(0xFF1570EF);
const _darkBlue = Color(0xFF194185);
const _bgPage = Color(0xFFF7F8FA);
const _textPrimary = Color(0xFF252B37);
const _textSecondary = Color(0xFF717680);
const _textMuted = Color(0xFFA4A7AE);
const _border = Color(0xFFE9EAEB);
const _cardShadow = Color(0x0F101828);

const _iconBg = Color(0xFFEFF8FF);
const _iconBorder = Color(0xFFB2DDFF);

const _purple = Color(0xFF7C3AED);
const _green = Color(0xFF059669);
const _orange = Color(0xFFEA580C);

// ─── Page

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: _bgPage,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(18.r, 20.r, 18.r, 110.r + bottomPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Header(),
                  Gap(14.r),
                  const _ContinueLearningCard(),
                  Gap(14.r),
                  const _StatsRow(),
                  Gap(14.r),
                  const _AchievementsHero(),
                  Gap(14.r),
                  const _LearningHoursCard(),
                  Gap(14.r),
                  const _QuickActionsCard(),
                  Gap(14.r),
                  const _PerformanceTrendCard(),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16.r,
            right: 16.r,
            bottom: bottomPad + 20.r,
            child: const _BottomTabBar(),
          ),
        ],
      ),
    );
  }
}

// ─── Header

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Avatar('PS'),
        Gap(11.r),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Priya Sharma',
                style: TextStyle(
                  fontSize: 15.5.sp,
                  fontWeight: FontWeight.w500,
                  color: _textPrimary,
                  letterSpacing: -0.015,
                ),
              ),
              Text(
                'Marketing · Digital Marketing',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: _textSecondary,
                ),
              ),
            ],
          ),
        ),
        const _NotificationBell(),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar(this.initials);
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.r,
      height: 40.r,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_primary, Color(0xFF7C3AED)],
          stops: [0.0, 0.707],
        ),
      ),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.notifications_outlined, size: 20.r, color: _textPrimary),
          Positioned(
            top: 7.r,
            right: 7.r,
            child: Container(
              width: 7.r,
              height: 7.r,
              decoration: BoxDecoration(
                color: const Color(0xFFD92D20),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Continue Learning Card

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Continue learning',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: _textPrimary,
                letterSpacing: -0.015,
              ),
            ),
            Gap(12.r),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64.r,
                  height: 64.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: _border),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF699CF2), Color(0xFF2C5AA0)],
                    ),
                  ),
                ),
                Gap(12.r),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Digital Marketing Essentials',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: _textPrimary,
                              ),
                            ),
                          ),
                          Gap(8.r),
                          Text(
                            '45%',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: _textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Gap(3.r),
                      Text(
                        'Module 4 of 9 · 1h 40m left',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: _textSecondary,
                        ),
                      ),
                      Gap(5.r),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3.r),
                        child: SizedBox(
                          height: 5.r,
                          child: const LinearProgressIndicator(
                            value: 0.45,
                            backgroundColor: Color(0xFFF5F5F5),
                            color: _primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(12.r),
            SizedBox(
              height: 40.h,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Continue →',
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Gap(8.r),
            GestureDetector(
              onTap: () {},
              child: Text(
                'View all →',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                  color: _primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stats Row

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: _StatTile(
            icon: Icons.menu_book_outlined,
            value: '9 / 12',
            label: 'Courses',
            sub: 'completed',
          ),
        ),
        Gap(10.r),
        const Expanded(
          child: _StatTile(
            icon: Icons.check_circle_outline,
            value: '82%',
            label: 'Avg quiz',
            sub: 'last 30 days',
          ),
        ),
        Gap(10.r),
        const Expanded(
          child: _StatTile(
            icon: Icons.trending_up,
            value: 'Normal',
            label: 'Velocity',
            sub: 'on track',
            smallValue: true,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.sub,
    this.smallValue = false,
  });
  final IconData icon;
  final String value;
  final String label;
  final String sub;
  final bool smallValue;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: _iconBg,
                border: Border.all(color: _iconBorder),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 20.r, color: _primary),
            ),
            Gap(10.r),
            Text(
              value,
              style: TextStyle(
                fontSize: smallValue ? 17.sp : 22.sp,
                fontWeight: FontWeight.w500,
                color: _textPrimary,
                letterSpacing: -0.025,
                height: 1.1,
              ),
            ),
            Gap(4.r),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF414651),
              ),
            ),
            Text(
              sub,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w400,
                color: _textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Achievements Hero

class _AchievementsHero extends StatelessWidget {
  const _AchievementsHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_darkBlue, _primary, _primary],
          stops: [0.0, 0.389, 0.707],
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(color: _cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30.r,
            right: -28.r,
            child: SizedBox(
              width: 140.r,
              height: 140.r,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x14FFFFFF),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -20.r,
            left: -20.r,
            child: SizedBox(
              width: 110.r,
              height: 110.r,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x0FFFFFFF),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 26.r,
                      height: 26.r,
                      decoration: BoxDecoration(
                        color: const Color(0x2EFFFFFF),
                        border: Border.all(color: const Color(0x40FFFFFF)),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.emoji_events_outlined,
                        size: 16.r,
                        color: Colors.white,
                      ),
                    ),
                    Gap(8.r),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You're Outperforming The Average Learner",
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: -0.01,
                              height: 1.48,
                            ),
                          ),
                          Text(
                            "You're on a roll! Keep up the great work.",
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xD9FFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(8.r),
                const _AchievementItem(
                  emoji: '🔥',
                  title: '7-Day Streak',
                  desc: "You've kept a 7-day learning streak going",
                ),
                Gap(8.r),
                const _AchievementItem(
                  emoji: '⭐',
                  title: 'Great Progress',
                  desc: "You've completed 3 advanced exercises",
                ),
                Gap(8.r),
                const _AchievementItem(
                  emoji: '🏆',
                  title: 'High Achiever',
                  desc: 'Your quiz scores are consistently above average',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementItem extends StatelessWidget {
  const _AchievementItem({
    required this.emoji,
    required this.title,
    required this.desc,
  });
  final String emoji;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 8.r),
      decoration: BoxDecoration(
        color: const Color(0x1FFFFFFF),
        border: Border.all(color: const Color(0x2EFFFFFF)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            width: 30.r,
            height: 30.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0x2EFFFFFF),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(emoji, style: TextStyle(fontSize: 16.sp)),
          ),
          Gap(10.r),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xD1FFFFFF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Learning Hours Card

class _LearningHoursCard extends StatelessWidget {
  const _LearningHoursCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Padding(
        padding: EdgeInsets.all(18.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: _iconBg,
                    border: Border.all(color: _iconBorder),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.schedule_outlined,
                    size: 18.r,
                    color: _primary,
                  ),
                ),
                Gap(10.r),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Learning hours',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: _textPrimary,
                        ),
                      ),
                      Text(
                        'Time invested · week',
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w400,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.north_east,
                      size: 14.r,
                      color: const Color(0xFF039855),
                    ),
                    Text(
                      '+3 vs last week',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF039855),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Gap(14.r),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _HoursStat(cap: 'This Week', num: '12'),
                _HoursStat(cap: 'This Month', num: '34h'),
                _HoursStat(cap: 'Total', num: '164h'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HoursStat extends StatelessWidget {
  const _HoursStat({required this.cap, required this.num});
  final String cap;
  final String num;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cap,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: _textSecondary,
          ),
        ),
        Gap(6.r),
        Text(
          num,
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w500,
            color: _textPrimary,
            letterSpacing: -0.04,
            height: 1,
          ),
        ),
      ],
    );
  }
}

// ─── Quick Actions Card

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: _textPrimary,
              ),
            ),
            Gap(10.r),
            Row(
              children: [
                Expanded(
                  child: _QuickActionBtn(
                    icon: Icons.library_books_outlined,
                    label: 'Browse Courses',
                    iconColor: _purple,
                    iconBg: const Color(0xFFF5F3FF),
                    iconBorder: const Color(0xFFD8D4FC),
                    onTap: () {},
                  ),
                ),
                Gap(8.r),
                Expanded(
                  child: _QuickActionBtn(
                    icon: Icons.calendar_month_outlined,
                    label: 'My Schedule',
                    iconColor: _primary,
                    iconBg: _iconBg,
                    iconBorder: _iconBorder,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            Gap(8.r),
            Row(
              children: [
                Expanded(
                  child: _QuickActionBtn(
                    icon: Icons.upload_outlined,
                    label: 'Submit Work',
                    iconColor: _green,
                    iconBg: const Color(0xFFECFDF3),
                    iconBorder: const Color(0xFFA6F4C5),
                    onTap: () {},
                  ),
                ),
                Gap(8.r),
                Expanded(
                  child: _QuickActionBtn(
                    icon: Icons.help_outline,
                    label: 'Get Help',
                    iconColor: _orange,
                    iconBg: const Color(0xFFFFF7ED),
                    iconBorder: const Color(0xFFFDBA74),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  const _QuickActionBtn({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.iconBg,
    required this.iconBorder,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color iconBg;
  final Color iconBorder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFF5F5F5)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: iconBg,
                border: Border.all(color: iconBorder),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, size: 22.r, color: iconColor),
            ),
            Gap(10.r),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w500,
                  color: _textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Performance Trend Card

class _PerformanceTrendCard extends StatelessWidget {
  const _PerformanceTrendCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: _iconBg,
                    border: Border.all(color: _iconBorder),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.trending_up, size: 18.r, color: _primary),
                ),
                Gap(10.r),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Performance trend',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: _textPrimary,
                        ),
                      ),
                      Text(
                        'Avg score · last 6 courses',
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w400,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1E9FF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '↗ +15 pts',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: _primary,
                    ),
                  ),
                ),
              ],
            ),
            Gap(12.r),
            SizedBox(
              height: 110.h,
              width: double.infinity,
              child: CustomPaint(painter: _TrendChartPainter()),
            ),
            Gap(4.r),
            Row(
              children: ['Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar']
                  .map(
                    (m) => Expanded(
                      child: Text(
                        m,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: _textSecondary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  // Points in SVG coordinate space (viewBox 0 0 352 110)
  static const _pts = [
    Offset(10, 78),
    Offset(75, 67),
    Offset(141, 76),
    Offset(207, 56),
    Offset(273, 47),
    Offset(338, 37),
  ];
  static const _vw = 352.0;
  static const _vh = 110.0;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / _vw;
    final sy = size.height / _vh;
    final pts = _pts.map((p) => Offset(p.dx * sx, p.dy * sy)).toList();

    // Gradient fill area
    final fillPath = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final p in pts.skip(1)) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath
      ..lineTo(pts.last.dx, size.height)
      ..lineTo(pts.first.dx, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1570EF).withValues(alpha: 0.18),
            const Color(0xFF1570EF).withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Trend line
    final linePath = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final p in pts.skip(1)) {
      linePath.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = const Color(0xFF1570EF)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Data point dots
    for (var i = 0; i < pts.length; i++) {
      final p = pts[i];
      final r = i == pts.length - 1 ? 4.5 : 3.5;
      canvas
        ..drawCircle(p, r + 2, Paint()..color = Colors.white)
        ..drawCircle(p, r, Paint()..color = const Color(0xFF1570EF));
    }
  }

  @override
  bool shouldRepaint(_TrendChartPainter old) => false;
}

// ─── Bottom Tab Bar

class _BottomTabBar extends StatelessWidget {
  const _BottomTabBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F101828),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Color(0x1A101828),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: 56.h,
            padding: EdgeInsets.symmetric(horizontal: 6.r, vertical: 8.r),
            decoration: BoxDecoration(
              color: const Color(0xF5FFFFFF),
              border: Border.all(color: _border),
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: const Row(
              children: [
                _TabItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Dashboard',
                  isActive: true,
                ),
                _TabItem(
                  icon: Icons.menu_book_outlined,
                  label: 'My Course',
                ),
                _TabItem(
                  icon: Icons.groups_outlined,
                  label: 'Circle',
                ),
                _TabItem(
                  icon: Icons.timeline,
                  label: 'Journey',
                ),
                _TabItem(
                  icon: Icons.assignment_outlined,
                  label: 'Assessment',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.isActive = false,
  });
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? _primary : const Color(0xFF535862);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? (activeIcon ?? icon) : icon,
            size: 20.r,
            color: color,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: color,
              height: 1.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            width: 14.r,
            height: 3.r,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isActive ? _primary : Colors.transparent,
                borderRadius: BorderRadius.circular(1.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Card base

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(color: _cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}
