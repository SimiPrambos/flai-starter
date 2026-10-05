import 'package:flutter/material.dart';
import 'package:template_vgv_app/l10n/l10n.dart';

/// One bottom tab. [label] resolves through l10n at build time, so the list
/// can stay `const`.
@immutable
class TabConfig {
  const TabConfig({required this.icon, required this.label});

  final IconData icon;
  final String Function(AppLocalizations l10n) label;
}

/// Tabs of the signed-in shell. The order MUST match the branch order of
/// `AppShellRoute` in `lib/core/router/app_router.dart`.
const List<TabConfig> kAppTabs = [
  TabConfig(icon: Icons.people_outline, label: _usersLabel),
  TabConfig(icon: Icons.settings_outlined, label: _settingsLabel),
];

String _usersLabel(AppLocalizations l10n) => l10n.tabUsers;

String _settingsLabel(AppLocalizations l10n) => l10n.tabSettings;
