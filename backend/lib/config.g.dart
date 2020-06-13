// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeserverConfig _$HomeserverConfigFromJson(Map json) {
  return $checkedNew('HomeserverConfig', json, () {
    $checkKeys(json,
        allowedKeys: const ['url', 'registration_secret'],
        requiredKeys: const ['url', 'registration_secret']);
    final val = HomeserverConfig(
      url: $checkedConvert(json, 'url', (v) => v as String),
      registrationSecret:
          $checkedConvert(json, 'registration_secret', (v) => v as String),
    );
    return val;
  }, fieldKeyMap: const {'registrationSecret': 'registration_secret'});
}

Map<String, dynamic> _$HomeserverConfigToJson(HomeserverConfig instance) =>
    <String, dynamic>{
      'url': instance.url,
      'registration_secret': instance.registrationSecret,
    };

Config _$ConfigFromJson(Map json) {
  return $checkedNew('Config', json, () {
    $checkKeys(json, allowedKeys: const [
      'port',
      'database_path',
      'jwt_secret',
      'homeserver'
    ], requiredKeys: const [
      'port',
      'database_path',
      'jwt_secret',
      'homeserver'
    ]);
    final val = Config(
      port: $checkedConvert(json, 'port', (v) => v as int),
      databasePath: $checkedConvert(json, 'database_path', (v) => v as String),
      jwtSecret: $checkedConvert(json, 'jwt_secret', (v) => v as String),
      homeserver: $checkedConvert(
          json, 'homeserver', (v) => HomeserverConfig.fromJson(v as Map)),
    );
    return val;
  }, fieldKeyMap: const {
    'databasePath': 'database_path',
    'jwtSecret': 'jwt_secret'
  });
}

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'port': instance.port,
      'database_path': instance.databasePath,
      'jwt_secret': instance.jwtSecret,
      'homeserver': instance.homeserver,
    };
