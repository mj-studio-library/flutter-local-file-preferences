import 'dart:convert';

import 'storage/storage.dart';

class JsonFile {
  JsonFile(this.name, this.sp);
  final String name;
  final Storage sp;

  Map<String, dynamic>? load() => switch (sp.getString(name)) {
        null => null,
        final String string =>
          Map<String, dynamic>.from(jsonDecode(string) as Map<dynamic, dynamic>)
      };

  Future<void> save(Map<String, dynamic> data) =>
      sp.setString(name, jsonEncode(data));
}
