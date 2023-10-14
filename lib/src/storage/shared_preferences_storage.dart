import 'package:shared_preferences/shared_preferences.dart';

import 'storage.dart';

class SharedPreferencesStorage implements Storage {
  SharedPreferencesStorage({required SharedPreferences sharedPreferences})
      : _sp = sharedPreferences;

  final SharedPreferences _sp;

  @override
  String? getString(String key) => _sp.getString(key);

  @override
  Future<void> setString(String key, String value) => _sp.setString(key, value);
}
