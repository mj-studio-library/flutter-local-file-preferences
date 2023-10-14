import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import 'json_file.dart';
import 'storage/storage.dart';
import 'throttler.dart';
import 'util/register.dart';

mixin LocalFilePrefMixin<T> {
  late final JsonFile _file = JsonFile(fileName, storage);
  final Throttler _throttle = Throttler(const Duration(seconds: 2));

  late final ValueNotifier<T> data = ValueNotifier<T>(load())..addListener(scheduleSave);
  T get value => data.value;
  set value(T value) => data.value = value;

  T load() {
    try {
      final Map<String, dynamic>? json = _file.load();
      if (json == null) {
        throw 0;
      }
      return fromJson(json);
    } catch (e) {
      return fallback;
    }
  }

  Future<void> save() async {
    try {
      await _file.save(toJson());
    } on Exception catch (e) {
      developer.log('LocalFilePrefMixin, failed to save', error: e);
    }
  }

  void scheduleSave() => _throttle.call(save);

  /// Serialization
  Storage get storage => globalStorage!;
  String get fileName;
  T get fallback;
  Map<String, dynamic> toJson();
  T fromJson(Map<String, dynamic> json);
}
