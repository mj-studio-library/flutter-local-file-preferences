abstract interface class Storage {
  String? getString(String key);
  Future<void> setString(String key, String value);
}
