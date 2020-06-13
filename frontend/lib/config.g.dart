// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeserverConfig _$HomeserverConfigFromJson(Map<String, dynamic> json) {
  return $checkedNew('HomeserverConfig', json, () {
    $checkKeys(json,
        allowedKeys: const ['name', 'url', 'riot'],
        requiredKeys: const ['name', 'url']);
    final val = HomeserverConfig(
      name: $checkedConvert(json, 'name', (v) => v as String),
      url: $checkedConvert(json, 'url', (v) => v as String),
      riot: $checkedConvert(json, 'riot', (v) => v as String),
    );
    return val;
  });
}

Map<String, dynamic> _$HomeserverConfigToJson(HomeserverConfig instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'riot': instance.riot,
    };

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return $checkedNew('Config', json, () {
    $checkKeys(json,
        allowedKeys: const ['backend', 'homeserver'],
        requiredKeys: const ['backend', 'homeserver']);
    final val = Config(
      backend: $checkedConvert(json, 'backend', (v) => v as String),
      homeserver: $checkedConvert(json, 'homeserver',
          (v) => HomeserverConfig.fromJson(v as Map<String, dynamic>)),
    );
    return val;
  });
}

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'backend': instance.backend,
      'homeserver': instance.homeserver,
    };
