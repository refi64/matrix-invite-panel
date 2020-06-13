import 'package:angular/angular.dart';
import 'package:json_annotation/json_annotation.dart';

import 'src/assets.dart' as assets;

part 'config.g.dart';

@JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
    nullable: false)
class HomeserverConfig {
  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true)
  final String url;

  final String riot;

  HomeserverConfig({this.name, this.url, this.riot});

  factory HomeserverConfig.fromJson(Map<String, dynamic> json) =>
      _$HomeserverConfigFromJson(json);
  Map<String, dynamic> toJson() => _$HomeserverConfigToJson(this);
}

@JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
    nullable: false)
class Config {
  @JsonKey(required: true)
  final String backend;

  @JsonKey(required: true)
  final HomeserverConfig homeserver;

  Config({this.backend, this.homeserver});

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}

Config configFactory() =>
    Config.fromJson(assets.configJson.json() as Map<String, dynamic>);
const configProvider = FactoryProvider<Config>(Config, configFactory);
