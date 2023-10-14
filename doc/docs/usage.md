---
sidebar_position: 2
---

# Usage

## 1. Register global `Storage`

`Storage` is content provider of your local file.

We provide `SharedPreferencesStorage` class.

You can use it like that in the very first of application bootstrap.

> ⚠️Run `registerGlobalStorage` before any usage of `LocalFilePrefMixin`

```dart
import 'package:local_file_preferences/local_file_preferences.dart';

void main() async {
  var sharedPreferences = await SharedPreferences.getInstance();
  registerGlobalStorage(
    SharedPreferencesStorage(sharedPreferences: sharedPreferences)
  );
}
```

Or you can create your own local file content provider by implementing `Storage` directly.

```dart
class MyStorage implements Storage {
  @override
  String? getString(String key) {
    ...
  }

  @override
  Future<void> setString(String key, String value) {
    ...
  }
}
```

`Storage` interface is simple to implement.

## 2. Mix in your class with `LocalFilePrefMixin`

For example,

```dart
class L10NSettings with LocalFilePrefMixin<L10NSettingsValue>
```

There are methods must be implement.

### `T get fallback`

Provide your data fallback for when mixin can't load local file(maybe first install).

### `String get fileName`

The file name of preferences file in the local file system.

> e.g.)` my_data.dat`

### `Map<String, dynamic> toJson()`

Provide convert method from your data to json.

### `T fromJson(Map<String, dynamic> json)`

Provide convert method from json to your data. 

### `storage` (Optional)

Provide storage if you need differentiate local file content provider.

The default `storage` is set by `registerGlobalStorage`.

### Example

```dart
enum L10NSettingsValue {
  enUS(Locale('en', 'US')),
  ko(Locale('ko')),
  ;

  final Locale locale;
  const L10NSettingsValue(this.locale);
}

class L10NSettings with LocalFilePrefMixin<L10NSettingsValue> {
  @override
  L10NSettingsValue get fallback =>
      Intl.getCurrentLocale().startsWith('en') ? L10NSettingsValue.enUS : L10NSettingsValue.ko;

  @override
  String get fileName => 'L10N_settings.dat';

  @override
  Json toJson() => {'locale': value.name};

  @override
  L10NSettingsValue fromJson(Json json) =>
      L10NSettingsValue.values.firstWhereOrNull((element) => element.name == json['locale']) ??
      L10NSettingsValue.enUS;
}

```

## 3. `LocalFilePrefMixin` API

### `T value`

Value of your data(getter, setter).

### `ValueNotifier<T> data`

The `ValueNotifier` wrapper of your data.



### `T load()`

Load your data from local file. This can be returnned null if there is no saved local file.

This is called at first of initialization automatically.

### `Futuer<void> save()`

Save current data to local file

### `void scheduleSave()`

Schedule save with throttling(2 seconds).

This is useful for situation that you should save intensively.