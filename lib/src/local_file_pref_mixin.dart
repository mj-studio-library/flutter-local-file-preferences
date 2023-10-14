import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import 'json_file.dart';
import 'storage/storage.dart';
import 'throttler.dart';
import 'util/register.dart';

mixin LocalFilePrefMixin<T> implements ValueNotifier<T> {
  late final JsonFile _file = JsonFile(fileName, storage);
  late final Throttler _throttle = Throttler(throttleDuration);
  late final ValueNotifier<T> _notifier = ValueNotifier<T>(load());

  @override
  T get value => _notifier.value;
  @override
  set value(T value) {
    if (_notifier.value == value) {
      return;
    }
    _notifier.value = value;
    notifyListeners();
    scheduleSave();
  }

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

  Storage get storage => globalStorage!;
  String get fileName;
  T get fallback;
  Map<String, dynamic> toJson();
  T fromJson(Map<String, dynamic> json);
  Duration get throttleDuration => const Duration(seconds: 2);

  @override
  void dispose() {
    _notifier.dispose();
  }

  @override
  void addListener(VoidCallback listener) => _notifier.addListener(listener);

  @override
  bool get hasListeners => _notifier.hasListeners;

  @override
  void notifyListeners() => _notifier.notifyListeners();

  @override
  void removeListener(VoidCallback listener) =>
      _notifier.removeListener(listener);
}
