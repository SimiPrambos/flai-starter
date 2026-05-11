import 'package:flutter/material.dart';
import 'package:template_vgv_app/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors, localizationsDelegates is a runtime value, so MaterialApp cannot be const
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
