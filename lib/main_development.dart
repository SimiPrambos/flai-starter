import 'package:template_vgv_app/app/app.dart';
import 'package:template_vgv_app/bootstrap.dart';
import 'package:template_vgv_app/core/firebase/firebase_options_development.dart';

Future<void> main() async {
  await bootstrap(
    () => const App(),
    firebaseOptions: () => DefaultFirebaseOptions.currentPlatform,
  );
}
