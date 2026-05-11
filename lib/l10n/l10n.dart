import 'package:flutter/widgets.dart';
import 'package:template_vgv_app/l10n/gen/app_localizations.dart';

export 'package:template_vgv_app/l10n/gen/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
