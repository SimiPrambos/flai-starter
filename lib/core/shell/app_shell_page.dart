import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:template_vgv_app/core/shell/tab_config.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';
import 'package:template_vgv_app/core/theme/app_text_styles.dart';
import 'package:template_vgv_app/l10n/l10n.dart';

/// Bottom-tab scaffold for a `StatefulShellRoute`.
///
/// It knows nothing about specific tabs. Pass the navigation shell and a
/// [TabConfig] list whose order matches the shell's branches. Never add
/// tab- or role-specific logic here.
class AppShellPage extends StatelessWidget {
  const AppShellPage({
    required this.navigationShell,
    required this.tabs,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final List<TabConfig> tabs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: _BottomTabBar(
        tabs: tabs,
        currentIndex: navigationShell.currentIndex,
        // Re-tapping the active tab pops its branch back to the root.
        onTap: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class _BottomTabBar extends StatelessWidget {
  const _BottomTabBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  final List<TabConfig> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xs,
            AppSpacing.sm,
            AppSpacing.xs,
            AppSpacing.sm,
          ),
          child: Row(
            children: List.generate(
              tabs.length,
              (i) => _TabItem(
                icon: tabs[i].icon,
                label: tabs[i].label(l10n),
                isActive: currentIndex == i,
                onTap: () => onTap(i),
              ),
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
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.onSurfaceDim;
    return Expanded(
      child: Semantics(
        button: true,
        selected: isActive,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 28.h,
                width: 60.w,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.infoSurface : null,
                  borderRadius: BorderRadius.circular(28.r),
                ),
                child: Icon(icon, size: 22.r, color: color),
              ),
              Gap(AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.labelSm.copyWith(
                  fontSize: 10.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
