import 'package:template_vgv_app/app/app.dart';
import 'package:template_vgv_app/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
