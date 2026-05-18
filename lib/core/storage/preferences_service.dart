import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_service.g.dart';

@Riverpod(keepAlive: true)
Future<PreferencesService> preferencesService(PreferencesServiceRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  return PreferencesService(prefs);
}

class PreferencesService {
  const PreferencesService(this._prefs);
  final SharedPreferences _prefs;

  Future<bool> setBool({required String key, required bool value}) =>
      _prefs.setBool(key, value);

  bool? getBool({required String key}) => _prefs.getBool(key);

  Future<bool> setString({required String key, required String value}) =>
      _prefs.setString(key, value);

  String? getString({required String key}) => _prefs.getString(key);
}
