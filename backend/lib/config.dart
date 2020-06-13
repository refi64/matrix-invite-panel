import 'dart:io';

import 'package:checked_yaml/checked_yaml.dart';
import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'inject.dart';

part 'config.g.dart';

void _requireNonEmpty(String key, String value) {
  if (key.isEmpty) {
    throw ArgumentError.value(key, 'Cannot be empty.');
  }
}

@JsonSerializable(
    anyMap: true,
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
    nullable: false)
class HomeserverConfig {
  @JsonKey(required: true)
  final String url;

  @JsonKey(required: true)
  final String registrationSecret;

  HomeserverConfig({this.url, this.registrationSecret}) {
    _requireNonEmpty('url', url);
    _requireNonEmpty('registrationSecret', registrationSecret);
  }

  factory HomeserverConfig.fromJson(Map json) =>
      _$HomeserverConfigFromJson(json);
  Map<String, dynamic> toJson() => _$HomeserverConfigToJson(this);
}

class ConfigFile {
  final File file;
  ConfigFile(this.file);

  factory ConfigFile.fromPath(String path) => ConfigFile(File(path));
}

@singleton
@JsonSerializable(
    anyMap: true,
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
    nullable: false)
class Config {
  @JsonKey(required: true)
  final int port;

  @JsonKey(required: true)
  final String databasePath;

  @JsonKey(required: true)
  final String jwtSecret;

  @JsonKey(required: true)
  final HomeserverConfig homeserver;

  Config({this.port, this.databasePath, this.jwtSecret, this.homeserver}) {
    _requireNonEmpty('jwt_secret', jwtSecret);
  }

  factory Config.fromJson(Map json) => _$ConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ConfigToJson(this);

  static File get _yamlFile => getIt<ConfigFile>().file;

  @factoryMethod
  static Future<Config> loadYamlFile() async => checkedYamlDecode(
      await _yamlFile.readAsString(), (json) => Config.fromJson(json),
      sourceUrl: _yamlFile.toString());
}
