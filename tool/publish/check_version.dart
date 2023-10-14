import 'dart:io';

import 'package:yaml/yaml.dart';

// ignore_for_file: avoid_print

void main(List<String> args) {
  print(args);
  var pubspec = File('pubspec.yaml');
  var content = loadYaml(pubspec.readAsStringSync()) as YamlMap;

  var pubspecVersion = content['version'] as String;
  var tagVersion = '';
  if (args.isNotEmpty) {
    tagVersion = args[0].split('/').last;
  } else {
    throw Exception();
  }
  if (tagVersion.startsWith('v')) {
    tagVersion = tagVersion.substring(1);
  }

  String changeLog = File('CHANGELOG.md').readAsStringSync();
  if (!changeLog.startsWith('## $tagVersion')) {
    throw Exception(
        'CHANGELOG.md doesn\'t started with \'## $tagVersion\' tag version ($tagVersion)');
  }
}
